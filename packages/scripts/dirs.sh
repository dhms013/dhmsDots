#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# dirs.sh — Create required user directories
# ─────────────────────────────────────────────────────────────────────────────

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots/"
SCREENRECORDS_DIR="$HOME/Videos/Screenrecords/"

create_dirs() {
  echo "==> Creating XDG user directories"
  xdg-user-dirs-update

  echo "==> Creating custom directories"
  mkdir -p "$SCREENSHOTS_DIR"
  mkdir -p "$SCREENRECORDS_DIR"
}

create_dirs
