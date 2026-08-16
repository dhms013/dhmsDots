gum log --level info "Switch awww-bin to awww"

stop_daemon() {
  pkill -x awww-daemon || true
}

remove_old_pkg() {
  if pkg-present awww-bin; then
    pkgdrop awww-bin
  fi
}

install_new_pkg() {
  if pkg-missing awww; then
    pkgadd awww
  fi
}

start_daemon() {
  if [ -n "$WAYLAND_DISPLAY" ]; then
    systemd-run --user --unit=awww-daemon --collect awww-daemon
  else
    gum log --level info "No Wayland session — awww-daemon will start on next login"
  fi
}

stop_daemon
remove_old_pkg
install_new_pkg
start_daemon
