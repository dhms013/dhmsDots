echo "Removing foot.. ghostty is just too convenience"

STOW_DIR="$HOME/.dhmsDots"
PACKAGE="foot"
TARGET="$HOME/.config/foot"
BACKUP="$HOME/.config/foot.bak"

unstow_foot() {
  if [ -L "$TARGET" ] && [ "$(readlink -f "$TARGET")" = "$STOW_DIR/$PACKAGE/.config/foot" ]; then
    echo "unstowing foot from .dhmsDots"
    stow -d "$STOW_DIR" -t "$HOME" -D "$PACKAGE"
  else
    echo "foot is not stowed from .dhmsDots — skipping unstow"
  fi

  if [ -e "$BACKUP" ]; then
    echo "restoring foot.bak → foot"
    rm -rf "$TARGET"
    mv "$BACKUP" "$TARGET"
  fi

  if [ ! -e "$TARGET" ]; then
    echo "foot config removed"
  fi
}

remove_foot_confirmation() {
  gum style --border normal --padding "1 2" "Remove foot package?"
  CHOICE=$(gum choose "Remove foot package" "Keep foot package")

  if [ "$CHOICE" = "Remove foot package" ]; then
    pkgdrop foot
  else
    echo "foot still installed"
  fi
}

unstow_foot
remove_foot_confirmation
