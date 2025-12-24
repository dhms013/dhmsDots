SHELL := /bin/bash

# -----------------------------
# Package files
# -----------------------------
BASE_PKGS := $(shell cat packages/basePkg)
AUR_PKGS  := $(shell cat packages/aurPkg)

PACMAN := sudo pacman -S --needed --noconfirm
PARU   := paru -S --needed --noconfirm

# -----------------------------
# Stow targets
# -----------------------------
STOW_HOME   := bash
STOW_CONFIG := eza fastfetch ghostty hypr kitty nvim starship walker yazi

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
		echo "==> Installing paru-bin"; \
		git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin; \
		cd /tmp/paru-bin && makepkg -si --noconfirm; \
	else \
		echo "==> paru already installed"; \
	fi

.PHONY: aur
aur: paru
	$(PARU) $(AUR_PKGS)

# -----------------------------
# Safe stow helpers
# -----------------------------
define safe_stow_home
	@if [ -e "$(HOME)/.$(1)rc" ] && [ ! -L "$(HOME)/.$(1)rc" ]; then \
		echo "==> Backing up .$(1)rc"; \
		mv "$(HOME)/.$(1)rc" "$(HOME)/.$(1)rc.pre-stow"; \
	fi
	stow $(1)
endef

define safe_stow_config
	@if [ -d "$(CONFIG_HOME)/$(1)" ] && [ ! -L "$(CONFIG_HOME)/$(1)" ]; then \
		echo "==> Backing up $(1) config"; \
		mv "$(CONFIG_HOME)/$(1)" "$(CONFIG_HOME)/$(1).pre-stow"; \
	fi
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

