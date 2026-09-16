#!/bin/bash

# dhms:summary=Enable and start required services
# dhms:requires-sudo=true

enable_services() {
  echo "==> Enabling services"
  systemctl --user enable --now pipewire.service pipewire-pulse wireplumber
  # Guarantees the fan/thermal platform profile follows the selected power
  # profile from boot, instead of waiting for a D-Bus activation.
  sudo systemctl enable power-profiles-daemon.service
  sudo updatedb
}

enable_services
