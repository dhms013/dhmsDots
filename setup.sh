#!/bin/bash
set -euo pipefail # Fail fast on errors, undefined vars, pipe failures

print_logo() {
  cat <<"EOF"

██████╗ ██╗  ██╗███╗   ███╗███████╗          Z
██╔══██╗██║  ██║████╗ ████║██╔════╝      Z    
██║  ██║███████║██╔████╔██║███████╗    z      
██║  ██║██╔══██║██║╚██╔╝██║╚════██║ z         
██████╔╝██║  ██║██║ ╚═╝ ██║███████║
╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
                                   
EOF
}

# Package list (single file: official + AUR mixed)
PKGS=$(cat packages/pkgList)
YAY="yay -S --needed --noconfirm --skipreview"

BOOTSTRAP="base-devel git"
PACMAN="sudo pacman -S --needed --noconfirm"

# Main execution
print_logo

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

echo "==> Installing all packages (official + AUR) via yay"
for pkg in $PKGS; do
  echo "==> Installing: $pkg"
  $YAY "$pkg" || echo "==> Failed to install $pkg, continuing..."
done

echo "==> Stowing dotfiles"
stow --adopt bash btop elephant environment.d eza fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd systemd themes walker waybar waypaper yazi

# Enable services
echo "==> Enabling services"
sh ~/.config/scripts/services

# Set initial theme
echo "==> Setting up theme"
ln -snf ~/.config/themes/themeLists/dhms ~/.config/themes/current/theme
ln -snf ~/.config/themes/current/theme/backgrounds/green-street.png ~/.config/themes/current/background

# Set Background
echo "==> setting up background"
awww-daemon &
awww img ~/.config/themes/current/background

# Make sure there's no conflict with existing theme configs from stow
rm -rf ~/.config/btop/themes/current.theme
rm -rf ~/.config/mako/config
rm -rf ~/.config/nvim/lua/plugins/theme.lua
ln -snf ~/.config/themes/current/theme/btop.theme ~/.config/btop/themes/current.theme
ln -snf ~/.config/themes/current/theme/mako.ini ~/.config/mako/config
ln -snf ~/.config/themes/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Setup complete! Please reboot to start    ║"
echo "║  Hyprland with your new configuration.     ║"
echo "╚════════════════════════════════════════════╝"
echo ""
read -p "Reboot now? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  systemctl reboot
fi
