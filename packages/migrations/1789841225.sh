# shellcheck shell=bash

add_omarchy_repo() {
  local conf=/etc/pacman.conf
  local omarchy_block
  omarchy_block=$(cat <<'EOF'
[omarchy]
Server = https://pkgs.omarchy.org/stable/$arch
SigLevel = Required
EOF
)

  if [[ -e $conf ]] && grep -q '^\[omarchy\]' "$conf"; then
    echo "omarchy repo is already present in $conf"
    return
  fi

  # Timestamped backup: a rerun must never destroy the current config (the
  # laptop's /etc/pacman.conf carries a blackarch section we must preserve).
  sudo cp "$conf" "$conf.bak.$(date +%Y%m%d-%H%M%S)"

  # Insert omarchy BEFORE blackarch (earlier = higher repo priority), so the
  # update order stays official > AUR > omarchy > blackarch. Append at the end
  # when no blackarch section exists. The file is edited in place, never
  # replaced wholesale.
  local tmp
  tmp=$(mktemp)
  awk -v block="$omarchy_block" '
    /^\[blackarch\]/ && !done { print block; print ""; done=1 }
    { print }
    END { if (!done) { print ""; print block } }
  ' "$conf" > "$tmp"
  sudo cp --no-preserve=mode "$tmp" "$conf"
  rm -f "$tmp"

  echo "Added the omarchy repository to $conf (backup saved next to it)"
}

add_omarchy_repo