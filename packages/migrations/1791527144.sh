echo "Migrate from hyprlock to the in-shell lock plugin"

# shellcheck shell=bash

# Helium is now the default browser (AUR: helium-browser-bin). Boxes that
# predate the switch may not have it, nor the password stack its browserpass
# extension needs: gopass (vault), browserpass (browser <-> gopass bridge),
# pass-import (brave/browser CSV/JSON stores -> gopass). The brave-origin
# profile is intentionally KEPT as the data source for the manual migration
# in task.md.

export PATH="$HOME/.dhmsDots/bin:$PATH"

echo "==> Ensuring Helium browser is installed"
if pkg-missing helium-browser-bin; then
  pkgadd helium-browser-bin
fi

echo "==> Installing password stack: gopass, browserpass, pass-import"
if pkg-missing gopass browserpass pass-import; then
  pkgadd gopass browserpass pass-import
fi

echo "==> Provisioning Helium flags + native messaging hosts (parity with other browsers)"
if command -v helium-browser >/dev/null 2>&1; then
  bash "$HOME/.dhmsDots/packages/scripts/browsers.sh"
fi

