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
PARU="paru -S --needed --noconfirm --skipreview"

# Bootstrap: Essential for building paru (via pacman, since paru doesn't exist yet)
BOOTSTRAP="base-devel git"
PACMAN="sudo pacman -S --needed --noconfirm"

# Stow targets
STOW_HOME="bash"
STOW_CONFIG="backgrounds bash btop environment.d eza fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim starship swayosd themes walker waybar waypaper yazi"
CONFIG_HOME="$HOME/.config"

# Safe stow helpers
safe_stow_home() {
  local dir="$1"
  if [ -e "$HOME/.$dirrc" ] && [ ! -L "$HOME/.$dirrc" ]; then
    echo "==> Backing up .$dirrc"
    mv "$HOME/.$dirrc" "$HOME/.$dirrc.pre-stow"
  fi
  stow "$dir"
}

safe_stow_config() {
  local dir="$1"
  if [ -d "$CONFIG_HOME/$dir" ] && [ ! -L "$CONFIG_HOME/$dir" ]; then
    echo "==> Backing up $dir config"
    mv "$CONFIG_HOME/$dir" "$CONFIG_HOME/$dir.pre-stow"
  fi
  stow "$dir"
}

# Main execution
print_logo

echo "==> Installing bootstrap packages (for building AUR helper)"
$PACMAN $BOOTSTRAP

if ! command -v paru >/dev/null; then
  echo "==> Installing paru"
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  cd /tmp/paru
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/paru
else
  echo "==> paru already installed"
fi

echo "==> Installing all packages (official + AUR) via paru"
for pkg in $PKGS; do
  echo "==> Installing: $pkg"
  $PARU "$pkg" || echo "==> Failed to install $pkg, continuing..."
done

echo "==> Stowing dotfiles"
for dir in $STOW_HOME; do
  echo "==> Stowing $dir (HOME)"
  safe_stow_home "$dir"
done
for dir in $STOW_CONFIG; do
  echo "==> Stowing $dir (CONFIG)"
  safe_stow_config "$dir"
done


# Set initial theme
ln -snf ~/.config/themes/themeLists/dhms ~/.config/themes/current/theme

# Set Background
set_background() {
    local bg_image="$1"
    if [[ -f "$bg_image" ]]; then
        echo "Setting background to: $bg_image"
        waypaper --set-auto "$bg_image"
    else
        echo "Error: Image file not found at $bg_image"
    fi
}
WALLPAPER_PATH="~/.config/themes/themeLists/dhms/green-street.png"

set_background "$WALLPAPER_PATH"

ln -snf ~/.config/omarchy/current/theme/btop.theme ~/.config/btop/themes/current.theme

ln -snf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config

echo "==> Have fun~"
