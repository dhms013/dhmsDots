echo "Switch speedtest-cli to ookla-speedtest-bin"

remove_old_pkg() {
  if pkg-present speedtest-cli; then
    pkgdrop speedtest-cli
  fi
}

install_new_pkg() {
  if pkg-missing ookla-speedtest-bin; then
    pkgadd ookla-speedtest-bin
  fi
}

remove_old_pkg
install_new_pkg
