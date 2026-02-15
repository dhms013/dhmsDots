echo "==> Installing bootstrap packages"
$PACMAN $BOOTSTRAP

if ! command -v yay >/dev/null; then
  echo "==> Installing yay"
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo "==> yay already installed"
fi
