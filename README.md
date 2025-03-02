# Philippe Bazinet's Dot Files 🔨

## Overview 📒

- Configures development environments with essential dotfiles.
- Includes a setup scripts for quick installation.

## Tools & Packages 🔧

- **Core:** WezTerm, Neovim, Starship, tmux, zsh, Stow, and more...
- **Languages:** Go, Dart, and more...
- **Utilities:** git, curl, commitizen, gnu-sed, go-swagger, and more...
- **GUI Apps:** WezTerm, Flutter, Docker, Android Studio, and more...
- **Fonts:** Fira Code Nerd Font

## Installation 📜

Clone into `~/dotfiles`, then run:

```bash
chmod +x fedora-install.sh && ./{DISTRO}-install.sh
```

## Scripts 📝

| File                  | Purpose                                                                        |
| --------------------- | ------------------------------------------------------------------------------ |
| `{DISTRO}-install.sh` | Main setup scripts. Load `vars.sh` and `functions.sh` to perform installation. |
| `functions.sh`        | Contains all installation functions (Docker, Flutter, AMD GPU fixes, etc.).    |
| `vars.sh`             | Stores global variables (download URLs, repo paths, file locations).           |
| `dnf-packages.txt`    | List of all packages to be installed via `dnf`.                                |
