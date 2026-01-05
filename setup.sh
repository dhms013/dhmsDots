#!/bin/bash

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

# Package files
BASE_PKGS=$(cat packages/basePkg)
AUR_PKGS=$(cat packages/aurPkg)
PACMAN="sudo pacman -S --needed --noconfirm"
PARU="paru -S --needed --noconfirm --skipreview"

# Stow targets
STOW_HOME="bash"
STOW_CONFIG="backgrounds bash btop environment.d eza fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim starship swayosd themes walker waybar waypaper yazi"
CONFIG_HOME="$HOME/.config"

# Safe stow helpers
safe_stow_home() {
  local dir=$1
  if [ -e "$HOME/.$dirrc" ] && [ ! -L "$HOME/.$dirrc" ]; then
    echo "==> Backing up .$dirrc"
    mv "$HOME/.$dirrc" "$HOME/.$dirrc.pre-stow"
  fi
  stow "$dir"
}

safe_stow_config() {
  local dir=$1
  if [ -d "$CONFIG_HOME/$dir" ] && [ ! -L "$CONFIG_HOME/$dir" ]; then
    echo "==> Backing up $dir config"
    mv "$CONFIG_HOME/$dir" "$CONFIG_HOME/$dir.pre-stow"
  fi
  stow "$dir"
}

# Main execution
print_logo

echo "==> Installing base packages"
$PACMAN $BASE_PKGS

if ! command -v paru >/dev/null; then
  echo "==> Installing paru"
  git clone https://aur.archlinux.org/paru.git
  cd paru && makepkg -si --noconfirm
  cd ..
  rm -rf paru
  cd -
else
  echo "==> paru already installed"
fi

echo "==> Installing AUR packages"
for pkg in $AUR_PKGS; do
  echo "==> Installing AUR package: $pkg"
  $PARU $pkg || echo "==> Failed to install $pkg, continuing to next package..."
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

echo "==> Setup complete!"
