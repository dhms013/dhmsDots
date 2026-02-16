#!/bin/bash

# Fallback function - automatically runs setup-old.sh on any error
run_fallback() {
  echo ""
  echo "╔════════════════════════════════════════════╗"
  echo "║  ⚠️  Modular setup encountered an error!   ║"
  echo "║  Automatically falling back to old setup   ║"
  echo "╚════════════════════════════════════════════╝"
  echo ""
  sleep 3

  # Kill the sudo keep-alive loop if it's running
  jobs -p | xargs -r kill 2>/dev/null

  # Run the old setup script (exec replaces current process)
  exec bash "$(dirname "${BASH_SOURCE[0]}")/setup-old.sh"
}

# Set up error trap BEFORE set -e
trap 'run_fallback' ERR

set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$BASE_DIR"
PKG_DIR="$BASE_DIR/packages/scripts"

# shared vars for stages
export YAY="yay -S --needed --noconfirm"
export PACMAN="sudo pacman -S --needed --noconfirm"
export BOOTSTRAP="base-devel git"
export PKGS="$(cat "$PKG_DIR/pkgList" 2>/dev/null || cat packages/pkgList)"

# run stages
source "$PKG_DIR/logo.sh"

echo "==> edit pacman.conf"
sudo mv /etc/pacman.conf /etc/pacman.conf.bak
sudo cp -r ./packages/pacman/pacman.conf /etc/pacman.conf

echo "==> Installing bootstrap packages (for building AUR helper)"
$PACMAN $BOOTSTRAP

if ! command -v yay >/dev/null; then
  echo "==> Installing yay"
  if [ -d /tmp/yay ]; then
    echo "==> Removing existing /tmp/yay directory"
    rm -rf /tmp/yay
  fi
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo "==> yay already installed"
fi

# Request sudo password upfront
echo "==> This script requires sudo privileges. Please enter your password:"
sudo -v

# Keep sudo alive throughout the script
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

sudo usermod -aG input ${USER}

source "$PKG_DIR/install.sh"
source "$PKG_DIR/dotfiles.sh"
source "$PKG_DIR/dirs.sh"
source "$PKG_DIR/theme.sh"
source "$PKG_DIR/sddm.sh"
source "$PKG_DIR/defaults.sh"
source "$PKG_DIR/services.sh"

source "$PKG_DIR/logo.sh"

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Setup complete! Rebooting to start        ║"
echo "║  Hyprland with your new configuration.     ║"
echo "╚════════════════════════════════════════════╝"
echo ""

echo -n "Rebooting in: "
for i in 5 4 3 2 1; do
  echo -n "$i..."
  sleep 1
done
echo ""

systemctl reboot
