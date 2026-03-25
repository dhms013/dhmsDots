#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# services.sh — Enable and start required services
# ─────────────────────────────────────────────────────────────────────────────

enable_services() {
  echo "==> Enabling services"
  awww-daemon &
  systemctl --user enable --now pipewire.service pipewire-pulse wireplumber
  sudo updatedb
}

enable_services
