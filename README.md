# dhmsDots

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux,

This repo is **not** a full distro, not a framework, and not trying to be smart.
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
- $mainMod usually using windows key, but please read the note inside hypr/.config/hypr/keybindings.conf
- If something breaks, you fix it yourself.

---

## What this repo is

- A **post-install** helper for Hyprland configs
- Installs my base packages (pacman + AUR)
- Stows my dotfiles safely
- Restores my preferred defaults for Hyprland usage

This repo assumes:
- **Arch Linux** already installed (or other your beloved distro based on arch)
- **Hyprland** already installed (if you choose other Desktop environment, you still able to steal some dotfiles from here)

Nothing more, nothing less.

---

## Default apps used in keybinds

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

## Mandatory dependency

- **Depend on what you need from this repo**

This repo does not install Hyprland for you.
Install it first `by yourself` 🙃

---

## Packages installed

The **setup.sh** installs packages in two layers:

- **pacman** for official repos
- **paru** for AUR packages

This includes (but is not limited to):

- paru (edit for `yay` if you prefer that)
- stow
- neovim
- ghostty
- yazi
- walker-bin and elephant providers
- nerd fonts (including Japanese fonts)
- media tools, utilities, and Hyprland extras

You can freely add or remove packages later.

---

## Dotfiles managed here

This repo manages configs for:

- background
- bash
- btop
- environment.d
- eza
- fastfetch
- ghostty
- hypr
- hyprland-preview-share-picker
- kitty
- mako
- nvim
- scripts (used in hypr and waybar)
- starship
- themes (backup)
- walker
- waybar
- waypaper
- yazi

Existing configs are not deleted.
They are renamed before stow runs.

---

## How to use

### 1. Install your distro + Hyprland

1. Option 1 
Use archinstall (or follow [arch wiki](https://wiki.archlinux.org/title/Installation_guide)) and keep it minimal.

2. Option 2
Install any distro/OS that you like (of course you need to edit the setup.sh if you did)
---

### 2. Clone the repo

```bash
git clone https://github.com/yourname/dhmsDots.git
cd dhmsDots
```

---

### 3. Run everything

```bash
./setup.sh
```

This will:
- Install base packages
- Install AUR packages
- Check existing configs
- Stow dotfiles safely

Log out and log back in if needed.

---

## Thanks to :
1. [Omarchy](https://github.com/basecamp/omarchy/tree/master?tab=readme-ov-file#)
My first linux that provide so many inspiration for me to make this repo
2. [Typecraft Dev](https://github.com/typecraft-dev)
Because the [setup.sh](./setup.sh) is copy-paste with some adjustment from [Crucible](https://github.com/typecraft-dev/crucible/tree/main)
