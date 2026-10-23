#!/bin/bash

# dhms:summary=Send precise agent done/blocked toasts for herdr
# dhms:group=herdr
# dhms:name=agent-toasts-notify
# dhms:hidden=true

set -euo pipefail

export PATH="${DHMSDOTS_PATH:-$HOME/.dhmsDots}/bin:${HOME}/.local/bin:${PATH:-/usr/bin}"
herdr_bin=${HERDR_BIN_PATH:-herdr}

event_json=${HERDR_PLUGIN_EVENT_JSON:-}
if [[ -z $event_json ]]; then
  exit 0
fi

status=$(jq -r '.data.agent_status // empty' <<<"$event_json")
case $status in
# `done` is an unseen completion; `idle` is the same turn after it was viewed.
done) verb="finished"; kind=completion ;;
blocked) verb="needs attention"; kind=blocked ;;
*) exit 0 ;;
esac

pane_id=$(jq -r '.data.pane_id // empty' <<<"$event_json")
if [[ -z $pane_id ]]; then
  exit 0
fi

# Capture the source immediately. Herdr 0.9.1 has no completion_seq field, so
# `done` (unseen completion) is the only reliable completion event; `idle` is a
# completion the user has already viewed, or startup idle.
source_pane() {
  "$herdr_bin" agent list | jq -c --arg p "$pane_id" \
    '[.result.agents[] | select(.pane_id == $p)] | if length == 1 then .[0] else empty end'
}
generation() {
  jq -ce --arg kind "$kind" '
    select(.terminal_id != null and .terminal_id != "") |
    select(.state_change_seq != null) |
    select(if $kind == "completion" then
      .agent_status == "done"
    else .agent_status == "blocked" end) |
    {terminal_id, agent, session: .agent_session,
      terminal_title: (if .agent_session == null then .terminal_title_stripped else null end),
      kind: $kind, generation: .state_change_seq}' <<<"$1"
}
pane=$(source_pane)
[[ -n $pane ]] || exit 0
initial=$(generation "$pane") || exit 0

# Mirror ui.toast.delay_seconds, then serialize delivery for this terminal.
sleep 1
umask 077
state_dir=${HERDR_PLUGIN_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/herdr/plugins/dhms.agent-toasts}
mkdir -p -- "$state_dir"
chmod 700 -- "$state_dir"
terminal_id=$(jq -r '.terminal_id' <<<"$initial")
key=$(printf '%s\0%s' "${HERDR_SOCKET_PATH:-}" "$terminal_id" | sha256sum)
key=${key%% *}
exec {lock_fd}>"$state_dir/$key.lock"
flock "$lock_fd"

# A viewed completion may transition done -> idle without changing generation.
# A session switch, new response, blocked transition, or removed pane cancels it.
pane=$(source_pane)
[[ -n $pane ]] || exit 0
current=$(generation "$pane") || exit 0
[[ $current == "$initial" ]] || exit 0
marker="$state_dir/$key.sent"
if [[ -f $marker && $(<"$marker") == "$current" ]]; then
  exit 0
fi

# Skip when the user is actually looking at it: the foot window hosting herdr
# must be Hyprland's active window, AND the agent's tab must be herdr's active
# tab in the focused workspace. Otherwise (another app focused, another tab
# open) always notify.
workspace_id=$(jq -r '.workspace_id' <<<"$pane")
tab_id=$(jq -r '.tab_id' <<<"$pane")
tab=$("$herdr_bin" tab list --workspace "$workspace_id" |
  jq -r --arg t "$tab_id" --arg w "$workspace_id" \
    '.result.tabs[] | select(.tab_id == $t and .workspace_id == $w)')
workspace=$("$herdr_bin" workspace list |
  jq -r --arg w "$workspace_id" '.result.workspaces[] | select(.workspace_id == $w)')
active_class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty')
if [[ $active_class == "foot" ]] &&
  [[ $(jq -r '.focused' <<<"$workspace") == "true" ]] &&
  [[ $tab_id == "$(jq -r '.active_tab_id' <<<"$workspace")" ]]; then
  exit 0
fi

tab_label=$(jq -r '.label // empty' <<<"$tab")
if [[ -z ${tab_label//[[:space:]]/} ]]; then
  echo "Herdr notification: source tab title is unavailable for $pane_id" >&2
  exit 1
fi

# Resolve the actual chat name from this pane's reported session identity.
# A missing identity/title is an error; do not substitute status text, an
# agent/pane label, or the name of another chat sharing its working directory.
plugin_root=${HERDR_PLUGIN_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)}
if ! msg=$(python3 "$plugin_root/session-title.py" <<<"$pane"); then
  echo "Herdr notification: chat title resolution failed for source pane $pane_id" >&2
  exit 1
fi

# The event belongs to this pane's tab, regardless of the tab currently shown.
title="${tab_label} ${verb}"

dhms-notification-send --app-name Herdr -u normal -g "󰊏" "$title" "$msg"

# Only successful delivery counts. Atomic replacement keeps concurrent hooks
# from observing a partial marker; flock covers both delivery and this write.
pending_marker=$(mktemp "$state_dir/$key.sent.XXXXXX")
trap 'rm -f -- "$pending_marker"' EXIT
printf '%s\n' "$current" >"$pending_marker"
mv -f -- "$pending_marker" "$marker"
