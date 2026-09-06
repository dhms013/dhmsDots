#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# browsers.sh — One-time Chromium-family browser provisioning: managed policy
# dirs (themeable without sudo afterward), Wayland/keyring flags, and the
# Copy URL / yt-dlp / WhatsApp Slim extensions with their native messaging hosts.
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd -- "$SCRIPT_DIR/../.." && pwd)}"
export PATH="$DOTFILES_DIR/bin:$PATH"

# The logged-in human, not root, even under sudo — sudo resets $HOME to /root,
# which would redirect every user-facing write into root's config.
TARGET_USER="${SUDO_USER:-${USER:-$(id -un)}}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
export HOME="${TARGET_HOME:-$HOME}"
EXTENSIONS_DIR="$DOTFILES_DIR/packages/browser/extensions"
FLAGS_TEMPLATE="$DOTFILES_DIR/packages/browser/chromium-flags.tpl"
HOSTS_SRC="$DOTFILES_DIR/packages/browser/native-messaging-hosts"

# The browser theme (whose per-browser flag file lives at ~/.config/<name>-flags.conf)
# is written by theme-browser without sudo, so these dirs are made a+rw once here.
MANAGED_POLICY_DIRS=(
  /etc/chromium/policies/managed
  /etc/opt/chrome/policies/managed
  /etc/opt/edge/policies/managed
  /etc/brave/policies/managed
)

# Chromium-based browser flag files, one per product name.
BROWSER_FLAG_FILES=(
  chromium-flags.conf
  chrome-flags.conf
  brave-flags.conf
  brave-origin-flags.conf
  microsoft-edge-stable-flags.conf
)

# Profile roots that use the NativeMessagingHosts layout. Brave-Origin is
# included so its extension hosts work too.
BROWSER_DIRS=(
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

create_policy_dirs() {
  echo "==> Creating managed browser policy directories"
  for dir in "${MANAGED_POLICY_DIRS[@]}"; do
    sudo mkdir -p "$dir"
    sudo chmod a+rw "$dir"
  done
}

copy_browser_flags() {
  echo "==> Writing Chromium flags for each browser"
  mkdir -p "$HOME/.config"
  for file in "${BROWSER_FLAG_FILES[@]}"; do
    sed "s|{{ EXTENSIONS_DIR }}|$EXTENSIONS_DIR|g" "$FLAGS_TEMPLATE" >"$HOME/.config/$file"
  done
}

install_native_hosts() {
  echo "==> Installing native messaging hosts for the Copy URL and yt-dlp extensions"
  for host_name in com.omarchy.copy_url com.omarchy.ytdlp; do
    case $host_name in
    com.omarchy.copy_url) host_bin="browser-copy-url-host" ;;
    com.omarchy.ytdlp) host_bin="browser-ytdlp-host" ;;
    esac
    template="$HOSTS_SRC/$host_name.json"
    for dir in "${BROWSER_DIRS[@]}"; do
      mkdir -p "$dir/NativeMessagingHosts"
      sed "s|__HOST_PATH__|$DOTFILES_DIR/bin/$host_bin|g" "$template" >"$dir/NativeMessagingHosts/$host_name.json"
    done
  done
}

create_policy_dirs
copy_browser_flags
install_native_hosts
theme-browser