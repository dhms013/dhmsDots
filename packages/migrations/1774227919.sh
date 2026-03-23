echo -e "\033[38;2;0;204;119mMake new update in effects\033[0m"

restart_services() {
  systemctl --user disable waybar.services
  systemctl --user disable swayosd-server.services
  restart-services waybar
  restart-services swayosd-server
  hyprctl reload
}

remove_unused() {
  rm $HOME/.config/systemd/user/swayosd-server.service
}

restart_services
remove_unused
