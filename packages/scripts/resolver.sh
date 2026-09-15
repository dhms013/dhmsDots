#!/bin/bash

# dhms:summary=Enable systemd-resolved and point /etc/resolv.conf at its stub
# dhms:requires-sudo=true
#
# https://wiki.archlinux.org/title/Systemd-resolved
# Ensures systemd-resolved is running BEFORE pointing /etc/resolv.conf at its
# stub. Without this, a minimal Arch install without resolved enabled ends up
# with a resolver stub that nothing is listening on — DNS silently breaks.

if ! systemctl is-enabled systemd-resolved >/dev/null 2>&1; then
  echo "==> Enabling systemd-resolved"
  sudo systemctl enable --now systemd-resolved
fi

echo "==> Symlinking resolved stub-resolv to /etc/resolv.conf"
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
