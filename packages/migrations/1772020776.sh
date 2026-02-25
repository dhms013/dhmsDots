echo "==> Installing missing Neovim-related tools"

needed=()

for pkg in fd luarocks nautilus tree-sitter-cli; do
  if pkg-missing "$pkg"; then
    needed+=("$pkg")
  fi
done

if ((${#needed[@]} > 0)); then
  echo "Installing: ${needed[*]}"
  pkgadd "${needed[@]}"
else
  echo "All packages already installed"
fi
