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
done) verb="finished" ;;
blocked) verb="needs attention" ;;
*) exit 0 ;;
esac

pane_id=$(jq -r '.data.pane_id // empty' <<<"$event_json")
if [[ -z $pane_id ]]; then
  exit 0
fi

# Mirror ui.toast.delay_seconds: only notify if the state held.
sleep 1

agents=$("$herdr_bin" agent list)
pane=$(jq -r --arg p "$pane_id" '.result.agents[] | select(.pane_id == $p)' <<<"$agents")
if [[ -z $pane ]]; then
  exit 0
fi

current=$(jq -r '.agent_status' <<<"$pane")
if [[ $current != "$status" ]]; then
  exit 0
fi

# Skip when the agent's tab is the active tab of the focused workspace.
workspace_id=$(jq -r '.workspace_id' <<<"$pane")
tab_id=$(jq -r '.tab_id' <<<"$pane")
workspace=$("$herdr_bin" workspace list |
  jq -r --arg w "$workspace_id" '.result.workspaces[] | select(.workspace_id == $w)')
if [[ $(jq -r '.focused' <<<"$workspace") == "true" ]] &&
  [[ $tab_id == "$(jq -r '.active_tab_id' <<<"$workspace")" ]]; then
  exit 0
fi

ws_label=$(jq -r '.label // .workspace_id' <<<"$workspace")

# Message content: agent's chat session title (from terminal title stripped).
# Opencode prefixes its own terminal title with "OC | "; herdr does not strip
# it, so remove any leading "<XX> | " agent-code prefix here.
msg=$(jq -r '.terminal_title_stripped // empty' <<<"$pane")
if [[ $msg =~ ^[A-Z][A-Z]\ \|\ (.*)$ ]]; then
  msg=${BASH_REMATCH[1]}
fi
if [[ -z $msg ]]; then
  msg="${ws_label} · ${pane_id##*:}"
fi

# Title: herdr workspace name + finished/needs attention/blocked
title="${ws_label} ${verb}"

dhms-notification-send --app-name Herdr -u normal -g "󰊏" "$title" "$msg"
