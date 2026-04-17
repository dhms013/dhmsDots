echo "Use quickshell as default"

DOTS_DIR="$HOME/.dhmsDots"

# ─── 1. Install quickshell if missing ────────────────────────────────────────
if pkg-missing quickshell; then
  pkgadd quickshell
fi

# ─── 2. Stow quickshell ──────────────────────────────────────────────────────
cd "$DOTS_DIR"
stow quickshell
cd - >/dev/null

# ─── 3. Find which packages are actually present ─────────────────────────────
PKGS=(mako swayosd-git waybar rofi rofi-calc rofi-emoji)
PRESENT=()

for pkg in "${PKGS[@]}"; do
  if pkg-present "$pkg"; then
    PRESENT+=("$pkg")
  fi
done

# ─── 4-5. Kill, drop, and clean up present packages ──────────────────────────
if [[ ${#PRESENT[@]} -gt 0 ]]; then

  # 4. Drop all present packages in one call
  pkgdrop "${PRESENT[@]}"

  # 5. Remove configs
  for dir in mako swayosd rofi waybar; do
    [[ -d "$HOME/.config/$dir" ]] && rm -rf "$HOME/.config/$dir"
  done
fi

uwsm-app quickshell &
