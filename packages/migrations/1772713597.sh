echo "Add forgotten whatsapp-linux-desktop"

if pkg-missing whatsapp-linux-desktop-bin; then
  pkgadd whatsapp-linux-desktop-bin
fi
