echo "Replacing current starship with new dynamic color"

if [ -e "$HOME/.config/starship.toml" ] || [ -L "$HOME/.config/starship.toml" ]; then
  rm "$HOME/.config/starship.toml"
fi

THEME_NAME=$(cat "$HOME/.config/themes/current/theme.name")
theme-set "$THEME_NAME"

ln -s "$HOME/.config/themes/current/theme/starship.toml" "$HOME/.config/starship.toml"
