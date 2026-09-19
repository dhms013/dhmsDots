echo "Migrate from hyprlock to the in-shell lock plugin"

remove_hyprlock_package() {
  if pkg-present hyprlock; then
    pkgdrop hyprlock
  fi
  # Drop a stray running instance pointing at a config that's about to go.
  pkill -x hyprlock 2>/dev/null || true
}

remove_hyprlock_pam() {
  # hyprlock ships its own PAM service (plus an optional fingerprint stack);
  # the shell lock uses dhms-lock-password / dhms-lock-fingerprint instead.
  sudo rm -f /etc/pam.d/hyprlock /etc/pam.d/hyprlock-fingerprint
}

retire_stale_hyprlock_files() {
  local config="$HOME/.config/hypr/hyprlock.conf"

  # Repo-managed copy (stow symlink into .dhmsDots): remove the orphan link.
  if [[ -L $config ]] && [[ $(realpath -m "$config") = $(realpath -m "$HOME/.dhmsDots/hypr/.config/hypr/hyprlock.conf") ]]; then
    rm "$config"
  # A real file pre-dates the switch; keep a timestamped backup.
  elif [[ -e $config ]]; then
    mv "$config" "$config.bak.$(date +%Y%m%d-%H%M%S)"
  fi

  # Generated theme output; the theme engine no longer renders this template.
  rm -f "$HOME/.config/themes/current/theme/hyprlock.conf"

  # Leftover runtime cache.
  rm -rf "$HOME/.cache/hyprlock"
}

provision_lock_pam() {
  # Idempotent: writes /etc/pam.d/dhms-lock-password and adds/removes the
  # fingerprint stack based on the user's enrolled prints.
  "$HOME/.dhmsDots/bin/dhms-apply-lock-pam"
}

remove_hyprlock_package
remove_hyprlock_pam
retire_stale_hyprlock_files
provision_lock_pam
