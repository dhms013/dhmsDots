#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# dirs.sh — Create required user directories
# ─────────────────────────────────────────────────────────────────────────────

create_dirs() {
  echo "==> Creating user directories"
  mkdir -p ~/.config/themes/current/
  mkdir -p ~/Pictures/Screenshots
  mkdir -p ~/Videos/Screenrecords
}

create_dirs
