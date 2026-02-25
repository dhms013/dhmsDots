# dhmsDots

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux,

This repo is **not** a full distro, and not a framework.
It exists so I can reinstall Arch + Hyprland and get my daily-driver setup back
with one command.

If it helps you, feel free to steal it.
If it breaks on your machine, you fix it.

---

## Notes

- This repo is my personal backup
- No guarantees
- No support
- Of course you can use this with other distro with Hyprland. But you'll need to edit the setup.sh by yourself, or simply just copy-paste (or stow) the dotfiles 🤣
- $mainMod usually using windows key, but I swap it with `ALT` button. please read the note inside [keybindings.conf](./hypr/.config/hypr/keybindings.conf) for other swapped button, or simply edit the [input.conf](./hypr/.config/hypr/input.conf)
- If something breaks, you fix it yourself.

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

The [setup.sh](./setup.sh) installs packages that listed in [pkgList](./packages/pkgList)
This includes (but is not limited to):

- yay (edit for [paru](https://github.com/Morganamilo/paru) if you prefer that)
- stow
- neovim
- ghostty
- yazi
- walker and elephant providers
- nerd fonts
- media tools, utilities, and Hyprland extras

You can freely add or remove packages before or after run [setup.sh](./setup.sh)

---

## Dotfiles

This repo manages configs for:

- applications (.local/share/)
- bash
- btop
- elephant
- environment.d
- fastfetch
- ghostty
- hypr
- hyprland-preview-share-picker
- kitty
- mako
- nvim
- scripts (used in hypr and waybar)
- sddm theme
- starship
- swayosd
- systemd
- themes
- uwsm (yes. I use uwsm because it easier 🤣)
- walker
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
Install any distro/OS that you like (maybe you'll need to edit the setup.sh if you did)
---

### 2. Clone the repo

```bash
sudo pacman -S git base-devel
git clone https://github.com/dhms013/dhmsDots.git
cd dhmsDots
sh setup.sh
```

---

### 3. Or, run using 1 command

```bash
sudo pacman -S git ; git clone https://github.com/dhms013/dhmsDots.git ;  sh setup.sh
```

## Method 2

```
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
Because the [setup.sh](./setup.sh) is copy-paste with some adjustment from [Crucible](https://github.com/typecraft-dev/crucible/tree/main)
