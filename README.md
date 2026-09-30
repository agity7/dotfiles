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

## Destructive-command safeguards

The `safety` Stow package installs `~/bin/rm` and `~/bin/sudo`. Because `~/bin`
is before the system command directories in the configured `PATH`, the guard
applies to normal commands launched from WezTerm, tmux, Neovim terminals, and
other terminals using the configured shell.

The guard hard-blocks recursive deletion of the home directory, critical user
directories such as Dropbox/dotfiles/SSH configuration, system roots, mounted
filesystem roots, and the current working directory or any of its ancestors.
It also rejects `--no-preserve-root` and always invokes GNU `rm` with
`--preserve-root=all`.

The `sudo` wrapper preflights ordinary `sudo rm ...` commands through the same
policy before invoking the real `/usr/bin/sudo`. It also blocks common raw-disk
destruction commands (`mkfs*`, `wipefs`, `blkdiscard`, partition editors, and
`dd` writes to `/dev/*`). Zsh additionally enables its `rm *` / `rm path/*`
confirmation and ten-second wait.

This is an accident-prevention layer, not a security boundary: an intentional
command that directly calls `/usr/bin/rm`, runs a root shell, or otherwise
bypasses `PATH` can still bypass it.
