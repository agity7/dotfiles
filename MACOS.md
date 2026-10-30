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
The script can be run repeatedly. Homebrew installs missing Brewfile packages,
upgrades outdated ones and skips those already current without prompting for
Homebrew confirmation. Stow recreates symlinks; the installer does not
preserve unmanaged configurations at the five paths it owns. On every run,
`~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim`, `~/.config/starship.toml` and
`~/.config/wezterm` are replaced with Stow-managed versions. Linux settings,
unrelated macOS configurations and existing backups outside those paths are
not touched. Any legacy macOS XDG tmux configuration is cleared so the
Stow-managed `~/.tmux.conf` remains authoritative. Previous WezTerm backups
stored inside its configuration folder
are moved to a separate directory before that folder is replaced.

## What is shared

- `nvim/`: **exactly** the Linux Neovim configuration, keymaps and plugins.
- `tmux/`: shared keybindings and plugins; `tmux-macos/` sources it and restores
  the native green tmux status bar shown on Linux (no powerline segments).
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

### Fresh Neovim installation

Every `./setup-macos.sh` run also clears the **Mac's** Neovim runtime
(`~/.local/share/nvim`, `~/.local/state/nvim`, and `~/.cache/nvim` by default),
then installs plugins and restores the exact versions in the shared
`nvim/.config/nvim/lazy-lock.json`. The installer then installs and verifies
Mason-managed tools and Treesitter parsers **before exiting Neovim**, rather
than leaving background installations running on first editor startup.
The macOS bootstrap exposes Homebrew's Node 24 to Mason during installation.
Local editor history, undo data, and caches in those directories are removed.

The installer uses a separate temporary macOS lockfile: it never writes to
the shared Neovim configuration or changes Linux's plugin versions. Rerunning
the installer intentionally repeats the clean installation; no prompts are
required for Homebrew or the plugin bootstrap.

After opening a new WezTerm window:

```sh
node -v
npm -v
nvim
```

If tmux is already running after setup, reload the new config once:

```sh
tmux source-file ~/.tmux.conf
```

The config does not change your existing Linux tmux setup.

To get the tmux plugins declared in the existing `.tmux.conf`, enter tmux and
press `Ctrl-S` then `Shift-I` to run TPM's installer. This step is needed only
when the plugins haven't been installed yet.

Individual Svelte/Capacitor projects can live in `~/Documents/` and should be
cloned independently with Git. Use `npm ci` inside each fresh clone.

## Later maintenance

Run `./setup-macos.sh` again after adding Brewfile dependencies or new Stow
configs. It automatically upgrades outdated Brewfile packages, without
reinstalling those already current. macOS permissions, Apple dialogs, or
administrator authentication may still require manual intervention.
