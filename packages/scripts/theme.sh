#!/bin/bash

echo "==> Applying GTK and icon theme"

gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-olive-dark"

sudo gtk-update-icon-cache /usr/share/icons/Yaru

echo "==> Setting initial theme"

ln -snf ~/.config/themes/themeLists/dhms ~/.config/themes/current/theme
ln -snf ~/.config/themes/current/theme/backgrounds/1.png ~/.config/themes/current/background

echo "==> setting up background"
awww-daemon &
awww img ~/.config/themes/current/background

echo "==> Linking theme consumers"

rm -rf ~/.config/btop/themes/current.theme
rm -rf ~/.config/mako/config
rm -rf ~/.config/nvim/lua/plugins/theme.lua

ln -snf ~/.config/themes/current/theme/btop.theme ~/.config/btop/themes/current.theme
ln -snf ~/.config/themes/current/theme/mako.ini ~/.config/mako/config
ln -snf ~/.config/themes/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
