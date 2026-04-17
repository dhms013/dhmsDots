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
PKGS=(mako swayosd waybar rofi rofi-calc rofi-emoji)
PRESENT=()

for pkg in "${PKGS[@]}"; do
  if pkg-present "$pkg"; then
    PRESENT+=("$pkg")
  fi
done

# ─── 4-6. Kill, drop, and clean up present packages ──────────────────────────
if [[ ${#PRESENT[@]} -gt 0 ]]; then

  # 4. Kill running processes
  for pkg in "${PRESENT[@]}"; do
    process="$pkg"
    [[ "$pkg" == "swayosd" ]] && process="swayosd-server"
    pkill -x "$process" 2>/dev/null || true
  done

  # 5. Drop all present packages in one call
  pkgdrop "${PRESENT[@]}"

  # 6. Remove configs
  for dir in mako swayosd rofi waybar; do
    [[ -d "$HOME/.config/$dir" ]] && rm -rf "$HOME/.config/$dir"
  done
fi
