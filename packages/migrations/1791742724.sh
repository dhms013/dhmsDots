echo "Add foot terminal and config"

# shellcheck shell=bash

export PATH="$HOME/.dhmsDots/bin:$PATH"

backup_if_exists() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    # Timestamped: a rerun must never overwrite the backup of the original.
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    echo "==> Backing up: $target → ${target}.bak.$ts"
    mv "$target" "${target}.bak.$ts"
  fi
}

install_terminal_packages() {
  if pkg-missing foot; then
    pkgadd foot
  fi
}

stow_foot() {
  local stow_dir="$HOME/.dhmsDots"
  local package="foot"
  local target="$HOME/.config/foot"
  local link="$stow_dir/$package/.config/foot"

  # stow folds the tree, so a successful stow is a symlink to the package dir.
  # Compare canonical paths: stow writes a *relative* link, so a plain
  # readlink would never equal the absolute $link and we'd back up + restow on
  # every run.
  if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$link")" ]; then
    echo "==> foot is already stowed from .dhmsDots — skipping"
    return
  fi

  backup_if_exists "$target"
  stow -d "$stow_dir" -t "$HOME" "$package"
}

set_default_terminal() {
  local target="$HOME/.config/xdg-terminals.list"
  mkdir -p "$HOME/.config"
  [ -e "$target" ] || : >"$target"

  # Edit the list in place (no file swap): comment out every active entry, then
  # append foot.desktop. Blank lines and existing comments are preserved, and a
  # previous active foot line is dropped so reruns stay idempotent.
  local tmp
  tmp="$(mktemp)"
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ -z "${line//[[:space:]]/}" || "$line" == '#'* ]]; then
      printf '%s\n' "$line" # keep blank lines and existing comments
    elif [[ "${line//[[:space:]]/}" == "foot.desktop" ]]; then
      : # drop an existing active foot (re-added last)
    else
      printf '# %s\n' "$line" # comment out the old default terminal(s)
    fi
  done <"$target" >"$tmp"
  printf 'foot.desktop\n' >>"$tmp"
  mv "$tmp" "$target"
}

install_terminal_packages
stow_foot
set_default_terminal
