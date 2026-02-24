#!/bin/bash
# ─────────────────────────────────────────────────────────────────────────────
# theme.sh — Apply GTK/icon theme, symlink initial theme, link consumers
# ─────────────────────────────────────────────────────────────────────────────

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dhmsDots}"
INITIAL_THEME="dhms"

apply_gtk_theme() {
  echo "==> Applying GTK and icon theme"
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  gsettings set org.gnome.desktop.interface icon-theme "Yaru-olive-dark"
  sudo gtk-update-icon-cache /usr/share/icons/Yaru
}

set_initial_theme() {
  echo "==> Setting initial theme: ${INITIAL_THEME}"
  ln -snf ~/.config/themes/themeLists/${INITIAL_THEME} ~/.config/themes/current/theme
  ln -snf ~/.config/themes/current/theme/backgrounds/green-street.png ~/.config/themes/current/background
}

set_wallpaper() {
  echo "==> Setting wallpaper"
  awww-daemon &
  awww img ~/.config/themes/current/background
}

link_theme_consumers() {
  echo "==> Linking theme consumers"
  rm -rf ~/.config/btop/themes/current.theme
  rm -rf ~/.config/mako/config
  rm -rf ~/.config/nvim/lua/plugins/theme.lua

  ln -snf ~/.config/themes/current/theme/btop.theme ~/.config/btop/themes/current.theme
  ln -snf ~/.config/themes/current/theme/mako.ini ~/.config/mako/config
  ln -snf ~/.config/themes/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
}

apply_gtk_theme
set_initial_theme
set_wallpaper
link_theme_consumers
