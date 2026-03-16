echo "replace s-tui with bottom"

if pkg-present s-tui; then
  pkgdrop s-tui
fi

if pkg-missing bottom; then
  pkgadd bottom
fi

waybar
