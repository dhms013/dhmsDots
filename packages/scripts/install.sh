#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# install.sh — Configure pacman, install yay, and install all packages
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"

BOOTSTRAP="base-devel git"
PACMAN="sudo pacman -S --needed --noconfirm"
YAY="yay -S --needed --noconfirm"

setup_pacman() {
  echo "==> Configuring pacman"
  sudo mv /etc/pacman.conf /etc/pacman.conf.bak
  sudo cp -r "$DOTFILES_DIR/packages/pacman/pacman.conf" /etc/pacman.conf
  echo "Server = https://mirror.omarchy.org/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist
}

install_bootstrap() {
  echo "==> Installing bootstrap packages"
  $PACMAN $BOOTSTRAP
}

install_yay() {
  if command -v yay >/dev/null; then
    echo "==> yay already installed, skipping"
    return
  fi

  echo "==> Installing yay"
  [ -d /tmp/yay ] && rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm && cd -
  rm -rf /tmp/yay
}

install_packages() {
  local pkgs
  pkgs=$(cat "$DOTFILES_DIR/packages/pkgList")

  echo "==> Installing all packages via yay"
  for pkg in $pkgs; do
    echo "==> Installing: $pkg"
    $YAY "$pkg" || echo "==> Warning: failed to install $pkg, continuing..."
  done
}

setup_pacman
install_bootstrap
install_yay
install_packages
