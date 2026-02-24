#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# sddm.sh — Install and configure the SDDM login theme
# ─────────────────────────────────────────────────────────────────────────────

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
    echo "==> Backing up existing ${CONFIG_FILE}"
    sudo mv -f "$CONFIG_FILE" "${CONFIG_FILE}.bak"
  fi

  sudo tee "$CONFIG_FILE" >/dev/null <<EOF
[Theme]
Current=${THEME_NAME}
EOF
}

install_sddm_theme
configure_sddm
