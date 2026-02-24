#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# services.sh — Enable and start required services
# ─────────────────────────────────────────────────────────────────────────────

enable_services() {
  echo "==> Enabling services"
  sh ~/.config/scripts/services
  systemctl --user enable --now hypridle.service
  sudo updatedb
}

enable_services
