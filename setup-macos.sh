#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

info() { printf '→ %s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || fail "This installer is only for macOS; Linux setup.sh is unchanged."
[[ "$DOTFILES_DIR" == "$HOME/dotfiles" ]] || fail "Clone this repository to ~/dotfiles first (current path: $DOTFILES_DIR)."

# Homebrew and Neovim native plugins require the macOS developer tools.
if ! xcode-select -p >/dev/null 2>&1; then
    info "Install Apple's Command Line Tools in the dialog, then rerun this script."
    xcode-select --install || true
    exit 1
fi

# Install Homebrew only when missing. Prefer native Apple Silicon Homebrew.
if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
    BREW=/usr/local/bin/brew
elif command -v brew >/dev/null 2>&1; then
    BREW="$(command -v brew)"
else
    info "Installing Homebrew (first run only)..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        BREW=/opt/homebrew/bin/brew
    elif [[ -x /usr/local/bin/brew ]]; then
        BREW=/usr/local/bin/brew
    else
        fail "Homebrew installation completed, but brew could not be found."
    fi
fi

eval "$("$BREW" shellenv bash)"

# Let Homebrew update its own metadata when needed (including macOS support).
# --no-upgrade prevents reruns from upgrading already installed packages.
# Do not invoke `brew upgrade`, `brew cleanup`, or force/reinstall options.
info "Installing missing macOS packages (existing versions preserved)..."
brew bundle --no-upgrade --file="$DOTFILES_DIR/Brewfile.macos"

# On a Mac, do not Stow `zsh` (it exports Fedora-only paths), or `safety`
# (its rm wrapper requires GNU rm options not present in macOS BSD rm).
# Dotfiles are the sole source of truth for these macOS configuration paths.
# Replace the managed destinations before Stow to avoid stale-file conflicts.
# Previously saved backups outside these paths are never touched.
info "Linking the shared Neovim, tmux, Starship and WezTerm configs..."

# The previous installer saved the WezTerm backup *inside* its config folder.
# Relocate those saved files before replacing the folder so they survive.
if [[ -d "$HOME/.config/wezterm" && ! -L "$HOME/.config/wezterm" ]]; then
    for saved in "$HOME/.config/wezterm/"*.before-fabriktor-dotfiles; do
        [[ -e "$saved" || -L "$saved" ]] || continue
        saved_dir="$(mktemp -d "$HOME/.config/wezterm-previous.XXXXXX")" || fail "Could not preserve previous WezTerm backup."
        mv "$saved" "$saved_dir/"
        info "Preserved earlier backup under $saved_dir"
    done
fi

# Scope removal to the five destinations owned by this macOS installer.
# In particular, do not remove ~/.config itself or plugin data directories.
rm -rf -- "$HOME/.zshrc" \
    "$HOME/.tmux.conf" \
    "$HOME/.config/nvim" \
    "$HOME/.config/starship.toml" \
    "$HOME/.config/wezterm"

stow -d "$DOTFILES_DIR" -t "$HOME" --no-folding zsh-macos nvim tmux starship wezterm

# tmux uses TPM in the existing shared .tmux.conf. Leave existing plugins
# alone and only create TPM itself if it is missing.
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -e "$TPM_DIR" && ! -L "$TPM_DIR" ]]; then
    info "Installing TPM for the existing tmux config..."
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
[[ -f "$TPM_DIR/tpm" ]] || fail "TPM directory exists but is incomplete: $TPM_DIR"

if [[ "${SHELL:-}" != */zsh ]]; then
    info "Your login shell is not Zsh. Run: chsh -s /bin/zsh"
fi

info "macOS dotfiles installed. Open a new WezTerm window to load Zsh."
info "Run: node -v && npm -v && nvim --version && tmux -V"
info "For iOS builds, verify Xcode with: xcodebuild -version && xcrun simctl list devices available"
