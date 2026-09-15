#!/bin/bash

# dhms:summary=Enable and start required services
# dhms:requires-sudo=true

enable_services() {
  echo "==> Enabling services"
  systemctl --user enable --now pipewire.service pipewire-pulse wireplumber
  sudo updatedb
}

enable_services
