#!/bin/bash

# dhms:summary=Stow dotfiles and copy supplementary config

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"

STOW_PKGS=(
  bash btop fastfetch foot ghostty
  hypr hyprland-preview-share-picker
  kitty nvim shell themes tmux
)

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    # Timestamped: a rerun must never overwrite the .bak holding the
    # user's ORIGINAL config with the previous run's output.
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    echo "==> Backing up: $target → ${target}.bak.$ts"
    mv "$target" "${target}.bak.$ts"
  fi
}

resolve_stow_target() {
  local pkg="$1"

  case "$pkg" in
  bash) echo "$HOME/.bashrc" ;;
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
  cd "$DOTFILES_DIR" || exit 1
  # No --adopt: after backup_if_exists there is nothing to adopt, and adopt
  # would silently rewrite repo files with machine-local content if a target
  # slipped through (e.g. a nested path the backup loop did not cover).
  stow "${STOW_PKGS[@]}"
}

copy_extra_configs() {
  echo "==> Copying extra configs"
  # applications/ was removed: since the quickshell -> dhms shell migration the
  # shell ships its own launchers, so nothing is copied to
  # ~/.local/share/applications from here anymore.
  cp -R "$DOTFILES_DIR/config/"* ~/.config/
  chmod -R 775 ~/.dhmsDots/bin/
  mkdir -p ~/.config/themes/current/
}

restart_terminal() {
  if pgrep -x kitty; then
    killall -SIGUSR1 kitty
  fi

  if pgrep -x ghostty; then
    killall -SIGUSR2 ghostty
  fi
}

stow_dotfiles
copy_extra_configs
restart_terminal
