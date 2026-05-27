# Philippe Bazinet's Dotfiles

## Overview

Fedora-focused dotfiles and setup scripts for a reproducible development environment.

## Stack

| Category  | Tools                                             |
| --------- | ------------------------------------------------- |
| Core      | WezTerm, Neovim, Starship, tmux, zsh, Stow, Aider |
| Languages | Go                                                |
| Utilities | Git, curl, Commitizen, GNU sed, go-swagger        |
| GUI       | Flutter, Docker, Android Studio                   |
| Fonts     | Fira Code Nerd Font                               |

## Installation

Clone the repository into `~/dotfiles`, then run:

```bash
chmod +x setup.sh && ./setup.sh
```

## Environment

The setup creates a global environment file at:

```text
~/.env
```

This file stores private API keys and local secrets used by development tools.
It is private and must not be committed.

## Aider

Aider reads its configuration from the dotfiles-managed config file and loads API keys from:

```text
~/.env
```

The setup syncs Fabriktor conventions to:

```text
~/.aider/CONVENTIONS.md
```

The Aider config reads this conventions file automatically.

## Scripts

| File               | Purpose                                      |
| ------------------ | -------------------------------------------- |
| `setup.sh`         | Main installation entrypoint.                |
| `functions.sh`     | Installation functions.                      |
| `vars.sh`          | Shared variables, paths, versions, and URLs. |
| `dnf-packages.txt` | Fedora packages installed through `dnf`.     |

## AMDGPU Verification

Run:

```sh
glxinfo | grep "OpenGL renderer string"
```
