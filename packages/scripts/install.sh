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
  cd /tmp/yay

  makepkg -s --noconfirm
  sudo pacman -U --noconfirm yay-*.pkg.tar.zst

  cd -
  rm -rf /tmp/yay
}

setup_cachyos_repo() {
  echo "==> Adding CachyOS repository"

  local tmp_dir="/tmp/cachyos-repo"
  [ -d "$tmp_dir" ] && rm -rf "$tmp_dir"
  mkdir -p "$tmp_dir"

  curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o "$tmp_dir/cachyos-repo.tar.xz"
  tar xvf "$tmp_dir/cachyos-repo.tar.xz" -C "$tmp_dir" --strip-components=1

  # Pipe 'y' to auto-confirm all prompts
  yes | sudo bash "$tmp_dir/cachyos-repo.sh"

  rm -rf "$tmp_dir"

  echo "==> Syncing package databases"
  sudo pacman -Sy
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
setup_cachyos_repo
install_packages
