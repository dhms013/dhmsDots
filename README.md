# dhmsDots

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux.
It exists so I can reinstall Arch + Hyprland and get my daily-driver setup back
with one command.

---

## Notes

- This repo is my personal backup, and it's aiming to be a keyboard driven hyprland setup.
- $mainMod usually using windows key, but I swap it with `ALT` button. please read the note inside [keybindings.conf](./hypr/.config/hypr/keybindings.conf) for other swapped button, or simply edit the [input.conf](./hypr/.config/hypr/input.conf)
- Contain a few themes from [Omarchy community](https://learn.omacom.io/2/the-omarchy-manual/90/extra-themes), and you can easily install or update theme from there using [theme-install](./scripts/.config/scripts/theme-install) and [theme-update](./scripts/.config/scripts/theme-update)

> [IMPORTANT KEYBINDS]
- SUPER SHIFT + slash = Keybinds info

---

## Table of Contents :
1. [About](#about)
2. [Preview](#preview)
3. [Default Apps](#default-apps)
4. [Dependencies](#dependencies)
5. [Dotfiles](#dotfiles)
6. [Installation](#installation)
7. [Special Thanks](#special-thanks)

---

## Preview


---

## About

- A **post-install** helper for Hyprland configs
- Installs my base packages from pacman & AUR
- Stows my dotfiles safely
- Restores my preferred defaults for Hyprland usage

This repo assumes:
- **Arch Linux with Hyprland** is installed

---

## Default Apps

My Hyprland config uses the following defaults:

| Purpose       | App       |
|---------------|-----------|
| Terminal      | ghostty      |
| Editor        | nvim         |
| File manager  | yazi         |
| Browser       | Zen Browser  |

These apps are referenced directly in Hyprland keybinds.

---

## Dependencies

- Hyprland (basic setup) Installed
- Bash (I never use zsh or fish)
- Internet connection~

---

## Dotfiles

This repo manages configs for:

- bash
- btop
- fastfetch
- ghostty
- hypr
- hyprland-preview-share-picker
- kitty
- mako
- nvim
- rofi
- sddm theme
- starship
- swayosd
- themes
- uwsm (yes. I use uwsm because it's easier 🤣)
- waybar
- yazi

Existing configs will be replaced.
Backup them before stow runs.

---

## Installation

### 1. Manual

1. Install arch + hyprland
2. Clone the repo
```
git clone --depth=1 https://github.com/dhms013/dhmsDots.git $HOME/.dhmsDots
```
3. run installation
```
cd .dhmsDots
sh install.sh
```

---

### 2. One line command

```bash
curl -fsSL https://raw.githubusercontent.com/dhms013/dhmsDots/main/install.sh | bash
```

This will:
- Install all listed packages
- Stow dotfiles

Reboot. Recommended to make sure all the configs is applied

--- 

## Special Thanks
1. [Omarchy](https://omarchy.org/)
My first linux that provide so many inspiration for me to make this repo
2. [Typecraft Dev](https://github.com/typecraft-dev)
Because the [install.sh](./install.sh) is copy-paste with some adjustment from [Crucible](https://github.com/typecraft-dev/crucible/tree/main)
