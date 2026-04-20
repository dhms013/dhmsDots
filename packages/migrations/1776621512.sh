echo "reset migration files"

STATE_DIR="$HOME/.local/state/dhms"

if [[ -d "$STATE_DIR" ]]; then
  for entry in "$STATE_DIR"/*; do
    [[ -e "$entry" ]] || continue
    rm -rf "$entry"
    echo "  [rm] $entry"
  done
else
  echo "  [skip] $STATE_DIR does not exist"
fi
