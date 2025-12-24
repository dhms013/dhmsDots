# dhmsDots

Personal Hyprland **supplement** and post-install bootstrap for Arch Linux.

This repo is **not** a full distro, not a framework, and not trying to be smart.
It exists so I can reinstall Arch + Hyprland and get my daily-driver setup back
with one command.

If it helps you, feel free to steal it.
If it breaks on your machine, you fix it.

---

## What this repo is

- A **post-archinstall** helper
- Installs my base packages (pacman + AUR)
- Stows my dotfiles safely
- Restores my preferred defaults for Hyprland usage

This repo assumes:
- You already installed **Arch Linux** (or other your beloved distro)
- You selected **Hyprland** during `archinstall` (or manually if you're not using `archinstall` script)

Nothing more, nothing less.

---

## Default apps used in keybinds

My Hyprland config assumes these defaults:

| Purpose        | App       |
|---------------|-----------|
| Terminal       | ghostty   |
| Editor         | nvim      |
| File manager   | yazi      |

These apps are referenced directly in Hyprland keybinds.

You can change them anytime by editing the Hyprland config after stowing.

---

## Mandatory dependency

- **Hyprland**

This repo does not install Hyprland for you.
Install it first using `archinstall` (or manually if you're not using `archinstall` script).

---

## Packages installed

The Makefile installs packages in two layers:

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
- hyprlock, hyprpaper, hypridle
- media tools, utilities, and Hyprland extras

You can freely add or remove packages later.

---

## Dotfiles managed here

This repo manages configs for:

- bash (home directory)
- hypr
- ghostty
- kitty
- nvim
- yazi
- walker
- fastfetch
- eza
- starship

Existing configs are not deleted.
They are renamed before stow runs.

---

## How to use

### 1. Install Arch + Hyprland

Use `archinstall` and keep it minimal.

---

### 2. Clone the repo

```bash
git clone https://github.com/yourname/dhmsDots.git
cd dhmsDots
```

---

### 3. Run everything

```bash
make all
```

This will:
- Install base packages
- Install AUR packages
- Check existing configs
- Stow dotfiles safely

Log out and log back in if needed.

---

## Notes

- This repo is my personal backup
- No guarantees
- No support

If something breaks, you fix it yourself.

---

## License

Do whatever you want with this repo.
Just don’t blame me if it breaks your system.
