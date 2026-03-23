echo "Fix previous migration"

set -euo pipefail

for unit in waybar swayosd; do
  if systemctl --user is-active --quiet "$unit" 2>/dev/null; then
    echo "  [stop]    $unit is active — stopping..."
    systemctl --user stop "$unit"
  else
    echo "  [skip]    $unit is not active"
  fi

  if systemctl --user is-enabled --quiet "$unit" 2>/dev/null; then
    echo "  [disable] $unit is enabled — disabling..."
    systemctl --user disable "$unit"
  else
    echo "  [skip]    $unit is not enabled"
  fi
done

SERVICE_FILE="$HOME/.config/systemd/user/swayosd-server.service"

if [[ -f "$SERVICE_FILE" ]]; then
  echo "  [rm]   Found $SERVICE_FILE — removing..."
  rm -f "$SERVICE_FILE"
  systemctl --user daemon-reload
else
  echo "  [skip] $SERVICE_FILE not found"
fi

WP_DEST="$HOME/.config/wireplumber"
WP_SRC="$HOME/.dhmsDots/config/wireplumber"

if [[ ! -d "$WP_DEST" ]]; then
  if [[ -d "$WP_SRC" ]]; then
    echo "  [cp]   $WP_DEST not found — copying from $WP_SRC..."
    cp -r "$WP_SRC" "$WP_DEST"
  else
    echo "  [warn] Source $WP_SRC not found — skipping wireplumber copy"
  fi
else
  echo "  [skip] $WP_DEST already exists"
fi

systemctl --user enable --now pipewire.service pipewire-pulse wireplumber
