echo "add the multiple input method ability"

# shellcheck shell=bash

export PATH="$HOME/.dhmsDots/bin:$PATH"

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    # Timestamped: a rerun must never overwrite the backup of the original.
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    echo "==> Backing up: $target → ${target}.bak.$ts"
    mv "$target" "${target}.bak.$ts"
  fi
}

install_input_method_packages() {
  if pkg-missing fcitx5 fcitx5-mozc fcitx5-qt fcitx5-gtk noto-fonts-cjk; then
    pkgadd fcitx5 fcitx5-mozc fcitx5-qt fcitx5-gtk noto-fonts-cjk
  fi
}

provision_environment() {
  local target="$HOME/.config/environment.d"
  backup_if_exists "$target"
  mkdir -p "$target"
  cp "$HOME/.dhmsDots/config/environment.d/envvars.conf" "$target/envvars.conf"
}

provision_fcitx5() {
  local target="$HOME/.config/fcitx5"
  backup_if_exists "$target"
  cp -R "$HOME/.dhmsDots/config/fcitx5" "$target"
}

install_input_method_packages
provision_environment
provision_fcitx5
