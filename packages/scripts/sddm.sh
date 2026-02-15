#!/bin/bash

if [ -z "$BASE_DIR" ]; then
  BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi

THEME_DIR="${BASE_DIR}/sddm/dhms"
TARGET_DIR="/usr/share/sddm/themes/dhms"

echo "Copying SDDM theme from ${THEME_DIR} to ${TARGET_DIR}..."
sudo cp -r "$THEME_DIR" "$TARGET_DIR"

CONFIG_FILE="/etc/sddm.conf"
THEME_NAME="dhms"
BACKUP_FILE="${CONFIG_FILE}.bak"

echo "Setting SDDM theme to '${THEME_NAME}'..."

if [ -f "$CONFIG_FILE" ]; then
  echo "Existing /etc/sddm.conf found. Backing it up to ${BACKUP_FILE}"
  sudo mv -f "$CONFIG_FILE" "$BACKUP_FILE"
else
  echo "No existing /etc/sddm.conf found. Creating a new one."
fi

echo "Creating new /etc/sddm.conf with theme override..."
sudo tee "$CONFIG_FILE" >/dev/null <<EOF
[Theme]
Current=${THEME_NAME}
EOF

echo "SDDM theme setup complete!"
