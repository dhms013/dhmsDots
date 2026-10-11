echo "Register foot's xdg-terminal-exec argument flags for floating-terminal"

# shellcheck shell=bash

export PATH="$HOME/.dhmsDots/bin:$PATH"

# The foot stow package now ships ~/.local/share/applications/foot.desktop with
# the X-TerminalArg* keys xdg-terminal-exec needs to pass --app-id and --title.
# Re-stow the package (idempotent) so that file gets linked on machines where
# foot was stowed before the override existed.
stow_foot() {
  stow -d "$HOME/.dhmsDots" -t "$HOME" foot
}

refresh_desktop_database() {
  update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
}

stow_foot
refresh_desktop_database
