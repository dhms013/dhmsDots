echo "Replace walker-elephant with Rofi"

if pkg-present walker; then
  systemctl --user disable elephant.service
  pkgdrop walker-git
  pkgdrop elephant
  pkgdrop elephant-calc
  pkgdrop elephant-clipboard
  pkgdrop elephant-desktopapplications
  pkgdrop elephant-menus
  pkgdrop elephant-symbols
fi

if pkg-missing rofi; then
  pkgadd rofi
  pkgadd rofi-emoji
  pkgadd rofi-calc
  stow rofi
fi
