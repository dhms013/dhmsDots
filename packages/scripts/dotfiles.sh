echo "==> Stowing dotfiles"

rm -rf ~/.bashrc
rm -rf ~/.config/hypr
rm -rf ~/.config/kitty

stow --adopt bash btop elephant fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim scripts starship swayosd themes walker waybar

cp -R ./applications/ ~/.local/share/
cp -R ./config/* ~/.config/
chmod -R 775 ~/.config/scripts/

source ~/.bashrc
