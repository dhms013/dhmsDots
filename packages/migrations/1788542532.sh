echo "Switch default browser zen-browser -> brave-origin"

install_new_pkg() {
  if pkg-missing brave-origin-bin; then
    pkgadd brave-origin-bin
  fi
}

set_defaults() {
  xdg-settings set default-web-browser brave-origin.desktop
  xdg-mime default brave-origin.desktop x-scheme-handler/http
  xdg-mime default brave-origin.desktop x-scheme-handler/https
  xdg-mime default brave-origin.desktop text/html
}

install_new_pkg
set_defaults
