SHELL := /bin/bash
# -----------------------------
# Package files
# -----------------------------
BASE_PKGS := $(shell cat packages/basePkg)
AUR_PKGS := $(shell cat packages/aurPkg)
PACMAN := sudo pacman -S --needed --noconfirm
PARU := paru -S --needed --noconfirm --skipreview
# -----------------------------
# Stow targets
# -----------------------------
STOW_HOME := bash
STOW_CONFIG := backgrounds bash btop environment.d eza fastfetch ghostty hypr hyprland-preview-share-picker kitty mako nvim starship swayosd themes walker waybar waypaper yazi
CONFIG_HOME := $(HOME)/.config
# -----------------------------
# Default target
# -----------------------------
.PHONY: all
all: base aur stow
# -----------------------------
# Package install
# -----------------------------
.PHONY: base
base:
	$(PACMAN) $(BASE_PKGS)
.PHONY: paru
paru:
	@if ! command -v paru >/dev/null; then \
		echo "==> Installing paru"; \
		git clone https://aur.archlinux.org/paru.git /tmp/paru; \
		cd /tmp/paru && makepkg -si --noconfirm; \
	else \
		echo "==> paru already installed"; \
	fi
.PHONY: aur
aur: paru
	@for pkg in $(AUR_PKGS); do \
		echo "==> Installing AUR package: $$pkg"; \
		$(PARU) $$pkg || echo "==> Failed to install $$pkg, continuing to next package..."; \
	done
# -----------------------------
# Safe stow helpers
# -----------------------------
define safe_stow_home
	@if [ -e "$(HOME)/.$(1)rc" ] && [ ! -L "$(HOME)/.$(1)rc" ]; then \
		echo "==> Backing up .$(1)rc"; \
		mv "$(HOME)/.$(1)rc" "$(HOME)/.$(1)rc.pre-stow"; \
	fi; \
	stow $(1)
endef
define safe_stow_config
	@if [ -d "$(CONFIG_HOME)/$(1)" ] && [ ! -L "$(CONFIG_HOME)/$(1)" ]; then \
		echo "==> Backing up $(1) config"; \
		mv "$(CONFIG_HOME)/$(1)" "$(CONFIG_HOME)/$(1).pre-stow"; \
	fi; \
	stow $(1)
endef
# -----------------------------
# Stow
# -----------------------------
.PHONY: stow
stow:
	@for dir in $(STOW_HOME); do \
		echo "==> Stowing $$dir (HOME)"; \
		$(call safe_stow_home,$$dir); \
	done
	@for dir in $(STOW_CONFIG); do \
		echo "==> Stowing $$dir (CONFIG)"; \
		$(call safe_stow_config,$$dir); \
	done
