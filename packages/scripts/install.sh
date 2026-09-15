#!/bin/bash

# dhms:summary=Configure pacman, install paru, and install all packages
# dhms:requires-sudo=true

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"

BOOTSTRAP="base-devel git"
PACMAN="sudo pacman -S --needed --noconfirm"
PARU="paru -S --needed --noconfirm"

setup_pacman() {
  echo "==> Configuring pacman"
  # Timestamped: a rerun must never overwrite the .bak holding the user's
  # ORIGINAL pacman.conf with the previous run's repo copy.
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  sudo cp /etc/pacman.conf "/etc/pacman.conf.bak.$ts"
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
  cd /tmp/paru || exit 1

  makepkg -s --noconfirm
  sudo pacman -U --noconfirm paru-*.pkg.tar.zst

  cd - >/dev/null || exit 1
  rm -rf /tmp/paru
}

install_packages() {
  local all repo_pkgs=() aur_pkgs=() pkg
  all=$(grep -v '^\s*#' "$DOTFILES_DIR/packages/pkgList" | xargs)

  # Split the list by availability in a repo: pacman aborts the ENTIRE
  # transaction when one name is unknown, so AUR entries must not be in it.
  # shellcheck disable=SC2048 # intentional word splitting of a package list
  for pkg in $all; do
    if pacman -Si "$pkg" >/dev/null 2>&1; then
      repo_pkgs+=("$pkg")
    else
      aur_pkgs+=("$pkg")
    fi
  done

  if ((${#repo_pkgs[@]})); then
    echo "==> Batch-installing ${#repo_pkgs[@]} repo packages via pacman"
    # shellcheck disable=SC2086,SC2048 # intentional word split of the package list
    $PACMAN ${repo_pkgs[*]} || echo "==> Warning: batch pacman install failed, falling back per-package"
  fi

  if ((${#aur_pkgs[@]})); then
    echo "==> Batch-installing ${#aur_pkgs[@]} AUR packages via paru"
    $PARU "${aur_pkgs[@]}" || true
  fi

  # Safety net: retry anything still missing one-by-one so a single failure
  # does not mask the rest.
  # shellcheck disable=SC2048 # intentional word splitting of a package list
  for pkg in $all; do
    pacman -Qi "$pkg" >/dev/null 2>&1 && continue
    echo "==> Retrying missing package: $pkg"
    $PARU "$pkg" || echo "==> Warning: failed to install $pkg, continuing..."
  done
}

setup_pacman
install_bootstrap
install_paru
install_packages
