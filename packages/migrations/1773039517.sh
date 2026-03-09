echo "==> Updating envs"

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"
UWSM_ENV="$HOME/.config/uwsm/env"
NEW_PATH_ENTRY="export PATH=\$HOME/.dhmsDots/bin:\$PATH"

migrate_uwsm_env() {
  if grep -qF "$NEW_PATH_ENTRY" "$UWSM_ENV" 2>/dev/null; then
    echo "==> uwsm env already up to date, skipping"
    return
  fi

  local backup="$UWSM_ENV.bak$(date +%Y%m%d%H%M%S)"
  echo "==> Backing up $UWSM_ENV → $backup"
  mv "$UWSM_ENV" "$backup"

  echo "==> Copying new uwsm env"
  cp "$DOTFILES_DIR/config/uwsm/env" "$UWSM_ENV"
}

remove_config_scripts() {
  if [ -d "$HOME/.config/scripts" ]; then
    echo "==> Removing ~/.config/scripts"
    rm -rf "$HOME/.config/scripts"
  else
    echo "==> ~/.config/scripts not found, skipping"
  fi
}

set_bin_permissions() {
  echo "==> Setting permissions on new scripts env"
  chmod -R 775 "$DOTFILES_DIR/bin/"
}

reboot_countdown() {
  gum spin --spinner "globe" --title "Rebooting in" --show-output -- \
    bash -c '
      for i in 5 4 3 2 1; do
        echo -n "$i... "
        sleep 1
      done
      echo "0"
    '

  echo ""
  echo "Rebooting now..."
  systemctl reboot
}

migrate_uwsm_env
remove_config_scripts
set_bin_permissions
reboot_countdown
