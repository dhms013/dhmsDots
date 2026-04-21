# dhmsDots

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=flat&logo=wayland&logoColor=black)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux.
This is my personal setup — not a distro, just my stuff.
It exists so I can reinstall Arch + Hyprland and get my daily-driver setup back with one command.

---

## Table of Contents

1. [About](#about)
2. [Preview](#preview)
3. [Default Apps](#default-apps)
4. [Dependencies](#dependencies)
5. [Dotfiles](#dotfiles)
6. [Installation](#installation)
7. [Special Thanks](#special-thanks)

---

## About

Based on [OMARCHY](https://omarchy.org/), my first linux setup, although it has been customized to suit my needs

- **Post-install** helper for Hyprland configs
- Installs my base packages from pacman & AUR
- Stows my dotfiles safely
- Restores my preferred defaults for Hyprland usage
- This repo is aiming to be a keyboard-driven Hyprland setup.
- `$mainMod` is usually the Windows key, but I swap it with `ALT`. Check the config in [input.conf](./hypr/.config/hypr/input.conf)
- Contains a few themes from the [Omarchy community](https://learn.omacom.io/2/the-omarchy-manual/90/extra-themes) — easily install or update themes using `theme-install`

> ⚠️ **IMPORTANT KEYBINDS**
> `SUPER + SHIFT + /` — Open keybinds info

This repo assumes **Arch Linux with Hyprland** is already installed.

---

## Preview

<details>
<summary>Click to view screenshots</summary>
<br>

<img width="1920" height="1080" alt="preview" src="https://github.com/user-attachments/assets/158a3b77-8733-4df3-9eb5-98300f4b5401" />

<br><br>

https://github.com/user-attachments/assets/7210c511-f99a-42ee-83b0-89442642568a

https://github.com/user-attachments/assets/2ee8aac8-847f-4e4d-8561-1a992c2de104

</details>

---

## Default Apps

My Hyprland config uses the following defaults:

| Purpose      | App          |
|--------------|--------------|
| Terminal     | ghostty      |
| Editor       | nvim         |
| File manager | yazi         |
| Browser      | Zen Browser  |
| AUR Helper   | [Paru](https://github.com/morganamilo/paru)         |

These apps are referenced directly in Hyprland keybinds.

---

## Dependencies

- Hyprland (basic setup) installed
- Bash — I never use zsh or fish
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
- nvim
- quickshell (based on [anomshell](https://github.com/atif-1402/anomshell/tree/main))
- sddm theme
- starship
- themes
- uwsm (yes, I use uwsm because it's just easier 🤣)
- yazi

---

## Installation

> ⚠️ **Heads up** — existing configs will be **replaced** by stow. Back them up before running the installer.

### 1. One-line command

1. Install Arch + Hyprland
2. Run this command
```bash
curl -fsSL https://raw.githubusercontent.com/dhms013/dhmsDots/main/install.sh | bash
```

---

### 2. Manual

1. Install Arch + Hyprland
2. Clone the repo
```bash
git clone --depth=1 https://github.com/dhms013/dhmsDots.git $HOME/.dhmsDots
```
3. Run the installer
```bash
cd .dhmsDots
sh install.sh
```

This will:
- Install all listed packages
- Stow dotfiles

**Reboot after.** Recommended to make sure all configs are applied properly.

---

## Special Thanks

1. [Omarchy](https://omarchy.org/) — my first Linux setup, provided so much inspiration for this repo
2. [Typecraft Dev](https://github.com/typecraft-dev) — [install.sh](./install.sh) is adapted from [Crucible](https://github.com/typecraft-dev/crucible/tree/main)
3. [anomshell](https://github.com/atif-1402/anomshell/tree/main) — for the beautifull yet simple quickshell

---

> *Made for personal use. Feel free to take whatever's useful.*
