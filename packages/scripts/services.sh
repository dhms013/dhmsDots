#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# services.sh — Enable and start required services
# ─────────────────────────────────────────────────────────────────────────────

SWAYOSD_DIR="$HOME/.config/systemd/user/"

enable_services() {
  echo "==> Writing swayosd service file"
  cat >"$SWAYOSD_DIR/swayosd-server.service" <<'EOF'
[Unit]
Description=SwayOSD Display Server
PartOf=graphical-session.target
After=graphical-session.target

[Service]
Type=dbus
BusName=org.erikreider.swayosd
ExecStart=/usr/bin/swayosd-server
Restart=on-failure

[Install]
WantedBy=graphical-session.target
EOF

  echo "==> Enabling services"
  systemctl --user enable swayosd-server.service
  systemctl --user enable waybar.service
  sudo updatedb
}

enable_services
