#!/bin/bash

# ─────────────────────────────────────────────────────────────────────────────
# Remote bootstrap: if piped via curl, clone the repo and re-run from disk
# ─────────────────────────────────────────────────────────────────────────────
REPO="dhms013/dhmsDots"
BRANCH="main"
DOTFILES_DIR="$HOME/.dhmsDots"

echo "Installing dhmsDots..."

# Clone the repo
if [ -d "$DOTFILES_DIR" ]; then
  echo "Updating existing dotfiles..."
  git -C "$DOTFILES_DIR" pull
else
  git clone --depth=1 "https://github.com/$REPO.git" "$DOTFILES_DIR"
fi

# Run your setup from inside the repo
cd "$DOTFILES_DIR"
# e.g. bash setup.sh, or stow, or symlink manually
echo "Done!"

# curl -fsSL https://raw.githubusercontent.com/dhms013/dhmsDots/main/setup.sh | bash
#
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

stow --adopt bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes tmux walker waybar

cp -R ./applications/ ~/.local/share/
cp -R ./config/* ~/.config/
chmod -R 775 ~/.config/scripts/

echo "==> Creating user directories"

mkdir -p ~/.config/themes/current/
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Videos/Screenrecords

sudo cp -r ./packages/sddm/dhms /usr/share/sddm/themes/

CONFIG_FILE="/etc/sddm.conf"
THEME_NAME="dhms"
BACKUP_FILE="${CONFIG_FILE}.bak"

echo "Setting SDDM theme to '${THEME_NAME}'..."

if [ -f "$CONFIG_FILE" ]; then
  echo "Existing /etc/sddm.conf found. Backing it up to ${BACKUP_FILE}"
  sudo mv -f "$CONFIG_FILE" "$BACKUP_FILE"
else
  echo "No existing /etc/sddm.conf found. Creating a new one."
fi

echo "Creating new /etc/sddm.conf with theme override..."
sudo tee "$CONFIG_FILE" >/dev/null <<EOF
[Theme]
Current=${THEME_NAME}
EOF

echo "==> Setting default applications"
sh ./packages/scripts/defaults.sh

echo "==> Applying GTK and icon theme"

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-olive-dark"

sudo gtk-update-icon-cache /usr/share/icons/Yaru

echo "==> Setting initial theme"

ln -snf ~/.config/themes/themeLists/dhms ~/.config/themes/current/theme
ln -snf ~/.config/themes/current/theme/backgrounds/1.png ~/.config/themes/current/background

echo "==> setting up background"
awww-daemon &
awww img ~/.config/themes/current/background

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
systemctl --user enable --now hypridle.service
sudo updatedb

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  Setup complete! Rebooting to start        ║"
echo "║  Hyprland with your new configuration.     ║"
echo "╚════════════════════════════════════════════╝"
echo ""

gum spin --spinner "globe" --title "Rebooting in" --show-output -- \
  bash -c '
        for i in 5 4 3 2 1; do
            echo -n "$i... "
            sleep 1
        done
        echo "0"
    '

echo ""
echo "Rebooting now..."

systemctl reboot
