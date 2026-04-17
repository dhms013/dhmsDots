#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# dirs.sh — Create required user directories
# ─────────────────────────────────────────────────────────────────────────────

DOWNLOADS_DIR="$HOME/Downloads/"
DOCUMENTS_DIR="$HOME/Documents/"
WORK_DIR="$HOME/Work/"
SCREENSHOTS_DIR="$HOME/Pictures/Screenshots/"
SCREENRECORDS_DIR="$HOME/Videos/Screenrecords/"

create_dirs() {
  echo "==> Creating user directories"
  mkdir -p "$DOWNLOADS_DIR"
  mkdir -p "$DOCUMENTS_DIR"
  mkdir -p "$WORK_DIR"
  mkdir -p "$SCREENSHOTS_DIR"
  mkdir -p "$SCREENRECORDS_DIR"
}

create_dirs
