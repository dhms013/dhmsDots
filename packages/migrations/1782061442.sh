echo "Add foot terminal config"

STOW_DIR="$HOME/.dhmsDots"
PACKAGE="foot"
TARGET="$HOME/.config/foot"

if [ -e "$TARGET" ]; then
  if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$STOW_DIR/$PACKAGE/.config/foot" ]; then
    echo "foot is already stowed from .dhmsDots — nothing to do"
    exit 0
  else
    echo "foot exists but is not from .dhmsDots — backing up to foot.bak"
    mv "$TARGET" "$HOME/.config/foot.bak"
  fi
fi

stow -d "$STOW_DIR" -t "$HOME" "$PACKAGE"
