#!/bin/bash

# dhms:summary=Install the SDDM login theme and set it as current
# dhms:requires-sudo=true

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"

CONFIG_FILE="/etc/sddm.conf"
THEME_NAME="dhms"

install_sddm_theme() {
  echo "==> Installing SDDM theme"
  sudo cp -r "$DOTFILES_DIR/packages/sddm/dhms" /usr/share/sddm/themes/
}

configure_sddm() {
  echo "==> Configuring SDDM theme to '${THEME_NAME}'"

  if [ -f "$CONFIG_FILE" ]; then
    # Timestamped: a rerun must never overwrite the .bak holding the user's
    # ORIGINAL sddm.conf with the previous run's output.
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    echo "==> Backing up existing ${CONFIG_FILE} → ${CONFIG_FILE}.bak.$ts"
    sudo cp "$CONFIG_FILE" "${CONFIG_FILE}.bak.$ts"
  fi

  sudo tee "$CONFIG_FILE" >/dev/null <<EOF
[Theme]
Current=${THEME_NAME}
EOF
}

if command -v sddm &>/dev/null; then
  install_sddm_theme
  configure_sddm
else
  echo "==> sddm not installed, skipping setup"
fi
