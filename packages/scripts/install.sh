#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# install.sh — Configure pacman, install paru, and install all packages
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"

BOOTSTRAP="base-devel git"
PACMAN="sudo pacman -S --needed --noconfirm"
PARU="paru -S --needed --noconfirm"

setup_pacman() {
  echo "==> Configuring pacman"
  sudo mv /etc/pacman.conf /etc/pacman.conf.bak
  sudo cp -r "$DOTFILES_DIR/packages/pacman/pacman.conf" /etc/pacman.conf
}

install_bootstrap() {
  echo "==> Installing bootstrap packages"
  $PACMAN $BOOTSTRAP
}

install_paru() {
  if command -v paru >/dev/null; then
    echo "==> paru already installed, skipping"
    return
  fi

  echo "==> Installing paru"
  [ -d /tmp/paru ] && rm -rf /tmp/paru
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  cd /tmp/paru

  makepkg -s --noconfirm
  sudo pacman -U --noconfirm paru-*.pkg.tar.zst

  cd -
  rm -rf /tmp/paru
}

install_packages() {
  local pkgs
  pkgs=$(cat "$DOTFILES_DIR/packages/pkgList")

  echo "==> Installing all packages via paru"
  for pkg in $pkgs; do
    echo "==> Installing: $pkg"
    $PARU "$pkg" || echo "==> Warning: failed to install $pkg, continuing..."
  done
}

setup_pacman
install_bootstrap
install_paru
install_packages
