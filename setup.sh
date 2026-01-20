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
YAY="yay -S --needed --noconfirm"

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

echo "==> Installing all packages (official + AUR) via yay"
for pkg in $PKGS; do
  echo "==> Installing: $pkg"
  $YAY "$pkg" || echo "==> Failed to install $pkg, continuing..."
done

echo "==> Stowing dotfiles"
rm -rf ~/.bashrc
rm -rf ~/.config/hypr
rm -rf ~/.config/kitty

stow --adopt applications bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes walker waybar
cp -R ./config/* ~/.config/

chmod -R 775 ~/.config/scripts/

# Set dark mode
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-olive-dark"

sudo gtk-update-icon-cache /usr/share/icons/Yaru

# Make sure user dirs are up to date,
# and make default direrctiries for screenshoots and screenrecords
mkdir -p ~/.config/themes/current/
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Videos/Screenrecords

# Set default applications
sh ./packages/mimetypes.sh

# Set initial theme
echo "==> Setting up theme"
ln -snf ~/.config/themes/themeLists/dhms ~/.config/themes/current/theme
ln -snf ~/.config/themes/current/theme/backgrounds/1.png ~/.config/themes/current/background

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

# Enable services
echo "==> Enabling services"
sh ~/.config/scripts/services

echo ""
echo ""
print_logo
echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Setup complete! Please reboot to start    ║"
echo "║  Hyprland with your new configuration.     ║"
echo "╚════════════════════════════════════════════╝"
echo ""
echo
systemctl reboot
