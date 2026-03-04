# dhmsDots

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux,

This repo is **not** a full distro, and not a framework.
It exists so I can reinstall Arch + Hyprland and get my daily-driver setup back
with one command.

If it helps you, feel free to steal it.
If it breaks on your machine, you fix it.

---

## Notes

- This repo is my personal backup, and it's a keyboard driven hyprland setup.
- No guarantees, no support
- Of course you can use this with other distro with Hyprland. But you'll need to edit the setup.sh by yourself, or simply just copy-paste (or stow) the dotfiles 🤣
- $mainMod usually using windows key, but I swap it with `ALT` button. please read the note inside [keybindings.conf](./hypr/.config/hypr/keybindings.conf) for other swapped button, or simply edit the [input.conf](./hypr/.config/hypr/input.conf)
- If something breaks, you fix it yourself.
- Contain a few themes from [Omarchy community](https://learn.omacom.io/2/the-omarchy-manual/90/extra-themes), and you can easily install or update theme from there using [theme-install](./scripts/.config/scripts/theme-install) and [theme-update](./scripts/.config/scripts/theme-update)

> [!IMPORTANT KEYBINDS]
- $mainMod SHIFT + slash = Keybinds info

---

## Table of Contents :
1. [About](#about)
2. [Default Apps](#default-apps)
3. [Dependencies](#dependencies)
4. [Installed Packages](#installed-packages)
5. [Dotfiles](#dotfiles)
6. [Installation](#installation)
6. [Special Thanks](#special-thanks)

---

## About

- A **post-install** helper for Hyprland configs
- Installs my base packages from pacman & AUR
- Stows my dotfiles safely
- Restores my preferred defaults for Hyprland usage

This repo assumes:
- **Arch Linux** already installed (or other your beloved distro based on arch)
- **Hyprland** already installed (if you choose other Desktop environment, you still able to steal some dotfiles from here)

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

You can change them anytime by editing the Hyprland config after stowing.

---

## Dependencies

- Hyprland (basic setup) Installed
- Bash (I never use zsh or fish)
- Internet connection~

---

## Installed Packages

The [install.sh](./install.sh) installs packages that listed in [pkgList](./packages/pkgList)
This includes (but is not limited to):

- yay (edit for [paru](https://github.com/Morganamilo/paru) if you prefer that)
- stow
- neovim
- ghostty
- yazi
- walker and elephant providers
- nerd fonts
- media tools, utilities, and Hyprland extras

---

## Dotfiles

This repo manages configs for:

- applications (.local/share/)
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
- scripts (used in hypr and waybar)
- sddm theme
- starship
- swayosd
- systemd
- themes
- uwsm (yes. I use uwsm because it easier 🤣)
- waybar
- yazi

Existing configs will be replaced.
Backup them before stow runs.

---

## Installation

## Method 1
### 1. Install your distro + Hyprland

1. Option 1
Use archinstall

2. Option 2
Install manually by following [arch wiki](https://wiki.archlinux.org/title/Installation_guide) or some youtuber

3. Option 3
Install any distro/OS that you like (maybe you'll need to edit the [install.sh](./install.sh) if you did)
---

### 2. Clone the repo

```bash
curl -fsSL https://raw.githubusercontent.com/dhms013/dhmsDots/main/install.sh | bash
```

This will:
- Install all listed packages
- Stow dotfiles

Reboot. Recommended to make sure all the services is running

--- 

## Special Thanks
1. [Omarchy](https://omarchy.org/)
My first linux that provide so many inspiration for me to make this repo
2. [Typecraft Dev](https://github.com/typecraft-dev)
Because the [install.sh](./install.sh) is copy-paste with some adjustment from [Crucible](https://github.com/typecraft-dev/crucible/tree/main)
