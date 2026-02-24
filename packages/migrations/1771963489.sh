echo "remove unused applications"

if pkg-present dolphin; then
  pkgdrop dolphin
fi

if pkg-present htop; then
  pkgdrop htop
fi

if pkg-present vim; then
  pkgdrop vim
fi
