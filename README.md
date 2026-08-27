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
<img width="1920" height="1080" alt="preview" src="https://github.com/user-attachments/assets/db4835d8-ef14-4376-9fdb-4b38d3afe2e2" />
<br>
<img width="1920" height="1080" alt="preview-catppuccin" src="https://github.com/user-attachments/assets/24397d4f-d804-482f-9c02-459718a1f714" />
<br>
<img width="1920" height="1080" alt="preview-osaka-jade" src="https://github.com/user-attachments/assets/bb8ba3ca-5d9c-4d4a-8b1b-407c7450b44d" />
<br>
<img width="1920" height="1080" alt="preview-tokyo-night" src="https://github.com/user-attachments/assets/4567c7db-7167-44c8-99d2-21f49d3a345b" />
</details>

<details>
<summary>Backgrounds selector</summary>
  
https://github.com/user-attachments/assets/122c3001-4fe8-466e-85e9-27548a7927d3
</details>

<details>
<summary>Themes selector</summary>
  
https://github.com/user-attachments/assets/bbe62cdf-5e51-4d6b-bb2d-cb333bb11e09

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
- quickshell (based on [Omarchy](https://omarchy.org/))
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

---

> *Made for personal use. Feel free to take whatever's useful.*
