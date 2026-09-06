echo "Provision browsers (brave-origin default + extensions), retire legacy quickshell, reshell via stow"

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

configure_browsers() {
  echo "Provisioning Chromium-family browsers (policy dirs, flags, extensions)"

  STOW_DIR="$HOME/.dhmsDots"
  EXTENSIONS_DIR="$STOW_DIR/packages/browser/extensions"
  FLAGS_TEMPLATE="$STOW_DIR/packages/browser/chromium-flags.tpl"
  HOSTS_SRC="$STOW_DIR/packages/browser/native-messaging-hosts"

  # theme-browser writes without sudo afterward, so dirs are made a+rw once here.
  local policy_dirs=(/etc/chromium/policies/managed /etc/opt/chrome/policies/managed /etc/opt/edge/policies/managed /etc/brave/policies/managed)
  for dir in "${policy_dirs[@]}"; do
    sudo mkdir -p "$dir"
    sudo chmod a+rw "$dir"
  done

  local flag_files=(chromium-flags.conf chrome-flags.conf brave-flags.conf brave-origin-flags.conf microsoft-edge-stable-flags.conf)
  mkdir -p "$HOME/.config"
  for file in "${flag_files[@]}"; do
    sed "s|{{ EXTENSIONS_DIR }}|$EXTENSIONS_DIR|g" "$FLAGS_TEMPLATE" > "$HOME/.config/$file"
  done

  local browser_dirs=(
    "$HOME/.config/chromium"
    "$HOME/.config/google-chrome"
    "$HOME/.config/google-chrome-beta"
    "$HOME/.config/google-chrome-unstable"
    "$HOME/.config/BraveSoftware/Brave-Browser"
    "$HOME/.config/BraveSoftware/Brave-Browser-Beta"
    "$HOME/.config/BraveSoftware/Brave-Browser-Nightly"
    "$HOME/.config/BraveSoftware/Brave-Origin"
    "$HOME/.config/microsoft-edge"
    "$HOME/.config/microsoft-edge-dev"
  )

  for host in com.omarchy.copy_url com.omarchy.ytdlp; do
    case $host in
    com.omarchy.copy_url) host_bin="browser-copy-url-host" ;;
    com.omarchy.ytdlp) host_bin="browser-ytdlp-host" ;;
    esac
    for dir in "${browser_dirs[@]}"; do
      mkdir -p "$dir/NativeMessagingHosts"
      sed "s|__HOST_PATH__|$STOW_DIR/bin/$host_bin|g" "$HOSTS_SRC/$host.json" > "$dir/NativeMessagingHosts/$host.json"
    done
  done

  "$STOW_DIR/bin/theme-browser"
}

remove_orphaned_quickshell() {
  STOW_DIR="$HOME/.dhmsDots"
  TARGET="$HOME/.config/quickshell"

  if [ ! -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "quickshell is already gone — nothing to do"
    return
  fi

  if [ -L "$TARGET" ]; then
    # Repo package removed, so a stowed link can only be a broken orphan.
    # realpath -m resolves even when the target is gone (readlink -f would not).
    if [ "$(realpath -m "$TARGET")" = "$(realpath -m "$STOW_DIR/quickshell/.config/quickshell")" ]; then
      echo "quickshell is stowed from .dhmsDots (orphaned) — removing the link"
      rm "$TARGET"
    else
      echo "quickshell is a symlink but not from .dhmsDots — leaving it alone"
    fi
    return
  fi

  echo "quickshell is a real directory, not from .dhmsDots — leaving it alone"
}

ensure_shell_stowed() {
  STOW_DIR="$HOME/.dhmsDots"
  PACKAGE="shell"
  TARGET="$HOME/.config/$PACKAGE"

  if [ -L "$TARGET" ] && [ "$(realpath -m "$TARGET")" = "$(realpath -m "$STOW_DIR/$PACKAGE/.config/$PACKAGE")" ]; then
    echo "shell is already stowed from .dhmsDots — nothing to do"
    return
  fi

  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    echo "shell exists but is not from .dhmsDots — backing up to shell.bak"
    mv "$TARGET" "$HOME/.config/shell.bak"
  fi

  stow -d "$STOW_DIR" -t "$HOME" "$PACKAGE"
  echo "shell stowed from .dhmsDots"
}

install_new_pkg
set_defaults
configure_browsers
remove_orphaned_quickshell
ensure_shell_stowed