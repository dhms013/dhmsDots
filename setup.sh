#!/bin/bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$BASE_DIR/packages/scripts"

# shared vars for stages
export YAY="yay -S --needed --noconfirm"
export PACMAN="sudo pacman -S --needed --noconfirm"
export BOOTSTRAP="base-devel git"
export PKGS="$(cat "$PKG_DIR/pkgList" 2>/dev/null || cat packages/pkgList)"

# run stages
source "$PKG_DIR/logo.sh"
source "$PKG_DIR/bootstrap.sh"
source "$PKG_DIR/sudo.sh"
source "$PKG_DIR/groups.sh"
source "$PKG_DIR/install.sh"
source "$PKG_DIR/dotfiles.sh"
source "$PKG_DIR/dirs.sh"
source "$PKG_DIR/theme.sh"
source "$PKG_DIR/defaults.sh"
source "$PKG_DIR/services.sh"
source "$PKG_DIR/sddm.sh"

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
