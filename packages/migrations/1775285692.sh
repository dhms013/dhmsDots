echo "replace yay with paru"

if pkg-present yay; then
  pkgdrop yay
fi

if pkg-missing paru; then
  echo "==> Installing paru"
  [ -d /tmp/paru ] && rm -rf /tmp/paru
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  cd /tmp/paru

  makepkg -s --noconfirm
  sudo pacman -U --noconfirm paru-*.pkg.tar.zst

  cd -
  rm -rf /tmp/paru
fi
