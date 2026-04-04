# dhmsDots

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=flat&logo=wayland&logoColor=black)
![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/License-Personal_Use-lightgrey?style=flat)

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux.
This is my personal setup — not a distro, not a framework, just my stuff.
It exists so I can reinstall Arch + Hyprland and get my daily-driver setup back with one command.

---

## Notes

- This repo is my personal backup, and it's aiming to be a keyboard-driven Hyprland setup.
- `$mainMod` is usually the Windows key, but I swap it with `ALT`. Read the note inside [keybindings.conf](./hypr/.config/hypr/keybindings.conf) for other swapped buttons, or simply edit [input.conf](./hypr/.config/hypr/input.conf)
- Contains a few themes from the [Omarchy community](https://learn.omacom.io/2/the-omarchy-manual/90/extra-themes) — easily install or update themes using [theme-install](./bin/theme-install)

> ⚠️ **IMPORTANT KEYBINDS**
> `SUPER + SHIFT + /` — Open keybinds info

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

## Preview

<details>
<summary>Click to view screenshots</summary>
<br>

<img width="1920" height="1080" alt="screenshot-2026-03-10_09-50-39" src="https://github.com/user-attachments/assets/e18a46b2-bfde-4b34-8527-47359faa9766" />
<br><br>
<img width="1920" height="1080" alt="screenshot-2026-03-10_09-51-24" src="https://github.com/user-attachments/assets/cafe8d52-5a2b-4cd1-9b1d-7f2a345a8066" />
<br><br>
<img width="1920" height="1080" alt="screenshot-2026-03-10_09-50-53" src="https://github.com/user-attachments/assets/7df85a20-969a-4372-8632-f8ce3c3b6b8b" />
<br><br>


https://github.com/user-attachments/assets/14dc00f8-093f-47c0-896d-b9022f809797



</details>

---

## About

This is my personal Hyprland setup — not a distro, not a framework, just my stuff.

- **Post-install** helper for Hyprland configs
- Installs my base packages from pacman & AUR
- Stows my dotfiles safely
- Restores my preferred defaults for Hyprland usage

This repo assumes **Arch Linux with Hyprland** is already installed.

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
- mako
- nvim
- rofi
- sddm theme
- starship
- swayosd
- themes
- uwsm (yes, I use uwsm because it's just easier 🤣)
- waybar
- yazi

---

## Installation

> ⚠️ **Heads up** — existing configs will be **replaced** by stow. Back them up before running the installer.

### 1. One-line command

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
