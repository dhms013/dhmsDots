gum log --level info "Switch awww-bin to awww"

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

remove_old_pkg
install_new_pkg
