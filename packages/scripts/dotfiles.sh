#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# dotfiles.sh — Stow dotfiles and copy supplementary config
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"

STOW_PKGS=(
  bash btop elephant fastfetch ghostty
  hypr hyprland-preview-share-picker
  kitty mako nvim scripts starship
  swayosd themes tmux walker waybar
)

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "==> Backing up: $target → ${target}.bak"
    mv "$target" "${target}.bak"
  fi
}

resolve_stow_target() {
  local pkg="$1"

  case "$pkg" in
  bash) echo "$HOME/.bashrc" ;;
  starship) echo "$HOME/.config/starship.toml" ;;
  *) echo "$HOME/.config/$pkg" ;;
  esac
}

stow_dotfiles() {
  echo "==> Backing up existing configs before stowing"
  for pkg in "${STOW_PKGS[@]}"; do
    target="$(resolve_stow_target "$pkg")"
    backup_if_exists "$target"
  done

  echo "==> Stowing dotfiles"
  cd "$DOTFILES_DIR"
  stow --adopt "${STOW_PKGS[@]}"
}

copy_extra_configs() {
  echo "==> Copying application launchers and extra configs"
  cp -R "$DOTFILES_DIR/applications/" ~/.local/share/
  cp -R "$DOTFILES_DIR/config/"* ~/.config/
  chmod -R 775 ~/.config/scripts/
  mkdir -p ~/.config/themes/current/
}

stow_dotfiles
copy_extra_configs
