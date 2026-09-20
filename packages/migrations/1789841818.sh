# shellcheck shell=bash

strip_omarchy_siglevel() {
  local conf=/etc/pacman.conf
  if [[ ! -e $conf ]]; then
    echo "/etc/pacman.conf is missing; nothing to strip"
    return 1
  fi

  # The mirror publishes no omarchy.db.sig. A per-repo SigLevel that demands a
  # DB signature (e.g. `SigLevel = Required` from migration 1789841225) breaks
  # `pacman -Sy` for EVERY repo. Remove it so the section inherits the global
  # "Required DatabaseOptional" — packages must be signed+trusted, the database
  # may be unsigned. Same rule as omarchy's own 1787589206 migration.
  if ! sed -n '/^\[omarchy\]/,/^\[/p' "$conf" 2>/dev/null | grep -q '^SigLevel = '; then
    echo "The [omarchy] section already has no SigLevel override"
    return 0
  fi

  # Timestamped backup before editing /etc/pacman.conf.
  sudo cp "$conf" "$conf.bak.$(date +%Y%m%d-%H%M%S)"
  sudo sed -i '/^\[omarchy\]/,/^\[/{/^SigLevel = /d}' "$conf"

  if sed -n '/^\[omarchy\]/,/^\[/p' "$conf" 2>/dev/null | grep -q '^SigLevel = '; then
    echo "Failed to strip SigLevel from the [omarchy] section" >&2
    return 1
  fi
  echo "Removed the SigLevel override from the [omarchy] section"
}

strip_omarchy_siglevel