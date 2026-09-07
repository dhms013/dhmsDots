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
4. [Virtual Machines](#virtual-machines)
5. [Dependencies](#dependencies)
6. [Dotfiles](#dotfiles)
7. [Installation](#installation)
8. [Special Thanks](#special-thanks)

---

## About

Based on [Omarchy](https://omarchy.org/), my first linux setup, although it has been customized to suit my needs

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
<img width="1920" height="1080" alt="theme-dhms" src="https://github.com/user-attachments/assets/ea589257-2bbf-46f1-b1d8-e2e219d8a7de" />
<br>
<img width="1920" height="1080" alt="theme-tokyo-night" src="https://github.com/user-attachments/assets/6b91be1e-3b48-4f6e-8306-749f3359651a" />
<br>
<img width="1920" height="1080" alt="theme-osaka-jade" src="https://github.com/user-attachments/assets/5a97150e-ce4a-44a9-8b44-ac52ed1b15eb" />
<br>
<img width="1920" height="1080" alt="theme-catppuccin" src="https://github.com/user-attachments/assets/85da755e-be67-42e9-9248-327c0d8ca4df" />
<br>
</details>

<details>
<summary>Backgrounds selector</summary>

https://github.com/user-attachments/assets/cebc5e71-5bb4-4d33-ae37-b55f1a9cb6b2

</details>

<details>
<summary>Themes selector</summary>

https://github.com/user-attachments/assets/f42e008c-e6d3-4096-b669-aa020dcfa951

</details>

---

## Default Apps

My Hyprland config uses the following defaults:

| Purpose      | App          |
|--------------|--------------|
| Terminal     | ghostty      |
| Editor       | nvim         |
| File manager | yazi         |
| Browser      | brave-origin |
| AUR Helper   | [Paru](https://github.com/morganamilo/paru)         |

These apps are referenced directly in Hyprland keybinds.

---

## Virtual Machines

Run OS VMs in Docker using the dockur family. Docker is enabled on demand when
you install a VM and is never a required package (remove it again when the last
VM goes away).

- **Windows 11** — `dockurr/windows`, hands-free install, connect over RDP.
- **Arch / Fedora / Ubuntu** — `qemux/qemu`, interactive install through a web
  viewer; Ubuntu asks desktop vs server first.

Install from the shell menu (`Setup > Install > VM`) or:

```bash
dhms-vm install windows   # or arch / fedora / ubuntu
dhms-vm status            # list every VM
dhms-vm launch windows    # connect (RDP / web viewer)
dhms-vm stop fedora       # shut down
dhms-vm remove ubuntu     # delete (offers to remove Docker on the last VM)
```

Requires `/dev/kvm` and at least ~10 GB free in addition to the disk you
allocate. Guest disks live in `~/.<os>-vm`; shared folders default to `~/<OS>`.
The guest can only reach those paths — nothing else on the host.

---

## Dependencies

- Hyprland installed (basic setup)
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
- shell — the dhms desktop shell (Quickshell, adapted from [Omarchy](https://omarchy.org/)) — [docs](./shell/.config/shell/README.md)
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
cd $HOME/.dhmsDots
bash install.sh
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
