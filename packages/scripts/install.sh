#!/bin/bash

echo "==> Installing packages via yay"

for pkg in $PKGS; do
  echo "==> Installing: $pkg"
  $YAY "$pkg" || echo "==> Failed: $pkg"
done
