echo "Add Omarchy's repo"

setup_pacman() {
  echo "==> Configuring pacman"
  sudo mv /etc/pacman.conf /etc/pacman.conf.bak
  sudo cp -r "$HOME/.dhmsDots/packages/pacman/pacman.conf" /etc/pacman.conf
  echo "Server = https://mirror.omarchy.org/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist
}

setup_pacman
keyrings
yay -Syyu --noconfirm --cleanafter
