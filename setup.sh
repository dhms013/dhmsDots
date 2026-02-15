#!/bin/bash
set -euo pipefail

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

PKGS=$(cat packages/pkgList)
YAY="yay -S --needed --noconfirm"

BOOTSTRAP="base-devel git"
PACMAN="sudo pacman -S --needed --noconfirm"

# Main execution
print_logo

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

echo "==> Installing all packages (official + AUR) via yay"
for pkg in $PKGS; do
  echo "==> Installing: $pkg"
  $YAY "$pkg" || echo "==> Failed to install $pkg, continuing..."
done

echo "==> Stowing dotfiles"

rm -rf ~/.bashrc
rm -rf ~/.config/hypr
rm -rf ~/.config/kitty

stow --adopt bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes walker waybar

cp -R ./applications/ ~/.local/share/
cp -R ./config/* ~/.config/
chmod -R 775 ~/.config/scripts/

source ~/.bashrc

echo "==> Creating user directories"

mkdir -p ~/.config/themes/current/
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Videos/Screenrecords

echo "==> Setting default applications"
sh ./packages/mimetypes.sh

echo "==> Applying GTK and icon theme"

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-olive-dark"

sudo gtk-update-icon-cache /usr/share/icons/Yaru

echo "==> Setting initial theme"

theme-set dhms

echo "==> Linking theme consumers"

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
