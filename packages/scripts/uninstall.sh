#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# uninstall.sh — Remove unused or conflicting packages
# ─────────────────────────────────────────────────────────────────────────────

UNUSED_PKGS=(
  htop    # replaced by btop
  vim     # replaced by nvim
  dolphin # replaced by yazi and nautilus
  dunst   # replaced with quickshell
)

uninstall_unused() {
  echo "==> Removing unused packages"
  for pkg in "${UNUSED_PKGS[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      echo "==> Uninstalling: $pkg"
      sudo pacman -Rns --noconfirm "$pkg" || echo "==> Warning: failed to remove $pkg, continuing..."
    else
      echo "==> Skipping: $pkg (not installed)"
    fi
  done
}

uninstall_unused
