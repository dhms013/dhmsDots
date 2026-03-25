#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# install.sh — dhmsDots installer entry point
# Clones/updates the repo, then runs each modular script in order.
#
# Usage (remote bootstrap):
#   curl -fsSL https://raw.githubusercontent.com/dhms013/dhmsDots/main/install.sh | bash
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO="dhms013/dhmsDots"
BRANCH="main"
export DOTFILES_DIR="$HOME/.dhmsDots"
SCRIPTS_DIR="$DOTFILES_DIR/packages/scripts"

# ── 1. Bootstrap: clone or update the repo ───────────────────────────────────
bootstrap_repo() {
  if [ -d "$DOTFILES_DIR" ]; then
    echo "==> Updating existing dotfiles repo"
    git -C "$DOTFILES_DIR" pull
  else
    echo "==> Cloning dhmsDots"
    git clone --depth=1 "https://github.com/$REPO.git" "$DOTFILES_DIR"
  fi
}

# ── 2. Sudo keepalive (runs in background for duration of script) ─────────────
sudo_keepalive() {
  echo "==> This script requires sudo. Please enter your password:"
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

# ── 3. Source a module script ─────────────────────────────────────────────────
run_module() {
  local script="$SCRIPTS_DIR/$1"
  if [ -f "$script" ]; then
    bash "$script"
  else
    echo "==> Warning: module not found: $script"
  fi
}

# ── 4. Countdown reboot ───────────────────────────────────────────────────────
reboot_countdown() {
  echo ""
  echo "╔════════════════════════════════════════════╗"
  echo "║  Setup complete! Rebooting to start        ║"
  echo "║  Hyprland with your new configuration.     ║"
  echo "╚════════════════════════════════════════════╝"
  echo ""

  gum spin --spinner "globe" --title "Rebooting in" --show-output -- \
    bash -c '
      for i in 5 4 3 2 1; do
        echo -n "$i... "
        sleep 1
      done
      echo "0"
    '

  echo ""
  echo "Rebooting now..."
  systemctl reboot
}

# ── Main ──────────────────────────────────────────────────────────────────────

sudo_keepalive

# Pre-flight: ensure git is available before cloning
if ! command -v git >/dev/null; then
  echo "==> git not found, installing..."
  sudo pacman -S --needed --noconfirm git
fi

bootstrap_repo
cd "$DOTFILES_DIR"

run_module logo.sh
run_module resolver.sh

sudo usermod -aG input "${USER}"

run_module install.sh
run_module dotfiles.sh
run_module services.sh
run_module theme.sh
run_module dirs.sh
run_module defaults.sh
run_module sddm.sh
run_module uninstall.sh

reboot_countdown
