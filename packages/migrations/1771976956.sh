echo "Replace elephant-all-git with minimal elephant services"

if pkg-present elephant-all-git; then
  pkgdrop elephant-all-git
fi

if pkg-missing elephant; then
  pkgadd elephant
  pkgadd elephant-calc
  pkgadd elephant-clipboard
  pkgadd elephantdesktopapplications
  pkgadd elephant-menus
  pkgadd elephant-symbols
  services
fi
