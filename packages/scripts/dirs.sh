#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# dirs.sh — Create required user directories
# ─────────────────────────────────────────────────────────────────────────────

SWAYOSD_DIR="$HOME/.config/systemd/user/"
SCREENSHOTS_DIR="$HOME/Pictures/Screenshots/"
SCREENRECORDS_DIR="$HOME/Videos/Screenrecords/"

create_dirs() {
  echo "==> Creating XDG user directories"
  xdg-user-dirs-update

  echo "==> Creating custom directories"
  mkdir -p "$SWAYOSD_DIR"
  mkdir -p "$SCREENSHOTS_DIR"
  mkdir -p "$SCREENRECORDS_DIR"
}

create_dirs
