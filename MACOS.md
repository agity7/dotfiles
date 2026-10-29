# Fabriktor macOS development setup

This is an **additive** macOS setup. The existing Linux `setup.sh`,
`functions.sh`, `vars.sh`, package list and Stow packages remain unchanged.

## Install

Use the same dedicated dotfiles location as Linux, outside Dropbox:

```sh
git clone git@github.com:agity7/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup-macos.sh
```

Already cloned? Just run `./setup-macos.sh` from that clone.
The script can be run repeatedly. Homebrew may update its own metadata when
needed, but installs only missing items without upgrading existing packages;
Stow reuses symlinks; the installer does not
preserve unmanaged configurations at the five paths it owns. On every run,
`~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim`, `~/.config/starship.toml` and
`~/.config/wezterm` are replaced with Stow-managed versions. Linux settings,
unrelated macOS configurations and existing backups outside those paths are
not touched. Previous WezTerm backups stored inside its configuration folder
are moved to a separate directory before that folder is replaced.

## What is shared

- `nvim/`: **exactly** the Linux Neovim configuration, keymaps and plugins.
- `tmux/`: the existing tmux configuration, with TPM installed if missing.
- `starship/`, `wezterm/`: the same prompt, font, colors and terminal layout.
- `zsh/.zshrc`: macOS reads the existing Zsh aliases and common styling through
  `zsh-macos/.zshrc`, then adjusts paths and plugin locations for Homebrew.

The Linux-only `safety/` commands are intentionally **not** installed on macOS:
its `rm` wrapper relies on GNU options incompatible with Apple's `rm`.

## Installed tooling

`Brewfile.macos` manages Neovim, WezTerm, FiraCode Nerd Font, Git, tmux,
Starship, Stow, ripgrep, fd, fzf, sd, tree-sitter CLI, Python, Go,
Commitizen, CocoaPods, and **Node 24** (including npm). The full Xcode
application and an iOS Simulator runtime must be installed separately from
Apple; the Command Line Tools alone are not sufficient for Capacitor iOS
builds.

After opening a new WezTerm window:

```sh
node -v
npm -v
nvim
```

To get the tmux plugins declared in the existing `.tmux.conf`, enter tmux and
press `Ctrl-S` then `Shift-I` to run TPM's installer. This step is needed only
when the plugins haven't been installed yet.

Individual Svelte/Capacitor projects can live in `~/Documents/` and should be
cloned independently with Git. Use `npm ci` inside each fresh clone.

## Later maintenance

Run `./setup-macos.sh` again after adding Brewfile dependencies or new Stow
configs. It does **not** force-update existing packages or reinstall tools.
If you want newer versions, upgrade deliberately through Homebrew.
