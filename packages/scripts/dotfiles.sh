#!/bin/bash

echo "==> Stowing dotfiles"

PACKAGES=(bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes tmux walker waybar)
TARGET_STOW="$HOME"

echo "Checking for existing files before stowing..."

for pkg in "${PACKAGES[@]}"; do
  pkg_path="$BASE_DIR/$pkg"
  [[ -d "$pkg_path" ]] || continue

  while IFS= read -r -d '' item; do
    rel="${item#"$pkg_path"/}"
    target="$TARGET_STOW/$rel"

    # Skip if target doesn't exist or is already a symlink (managed by stow)
    if [[ -e "$target" && ! -L "$target" ]]; then
      echo "  Backing up: $target -> ${target}.bak"
      mv "$target" "${target}.bak"
    fi
  done < <(find "$pkg_path" -mindepth 1 -print0)
done

cd "$BASE_DIR"

stow --adopt bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes tmux walker waybar

# rm -rf ~/.bashrc
# rm -rf ~/.config/hypr
# rm -rf ~/.config/kitty
#
# cd "$BASE_DIR"
#
# stow --adopt bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes walker waybar

cp -R ./applications/ ~/.local/share/
cp -R ./config/* ~/.config/
chmod -R 775 ~/.config/scripts/
