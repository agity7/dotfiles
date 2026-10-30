#!/usr/bin/env bash
set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
info() { printf '→ %s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
[[ "$(uname -s)" == "Darwin" ]] || fail "This installer is only for macOS; Linux setup.sh is unchanged."
[[ "$DOTFILES_DIR" == "$HOME/dotfiles" ]] || fail "Clone this repository to ~/dotfiles first (current path: $DOTFILES_DIR)."
if ! xcode-select -p >/dev/null 2>&1; then
    info "Install Apple's Command Line Tools in the dialog, then rerun this script."
    xcode-select --install || true
    exit 1
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
    BREW=/usr/local/bin/brew
elif command -v brew >/dev/null 2>&1; then
    BREW="$(command -v brew)"
else
    info "Installing Homebrew (first run only)..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
        BREW=/opt/homebrew/bin/brew
    elif [[ -x /usr/local/bin/brew ]]; then
        BREW=/usr/local/bin/brew
    else
        fail "Homebrew installation completed, but brew could not be found."
    fi
fi
eval "$("$BREW" shellenv bash)"
info "Installing/upgrading macOS packages (non-interactive)..."
HOMEBREW_NO_ASK=1 brew bundle install --upgrade --file="$DOTFILES_DIR/Brewfile.macos"
info "Linking the shared Neovim, tmux, Starship and WezTerm configs..."
if [[ -d "$HOME/.config/wezterm" && ! -L "$HOME/.config/wezterm" ]]; then
    for saved in "$HOME/.config/wezterm/"*.before-fabriktor-dotfiles; do
        [[ -e "$saved" || -L "$saved" ]] || continue
        saved_dir="$(mktemp -d "$HOME/.config/wezterm-previous.XXXXXX")" || fail "Could not preserve previous WezTerm backup."
        mv "$saved" "$saved_dir/"
        info "Preserved earlier backup under $saved_dir"
    done
fi
rm -rf -- "$HOME/.zshrc" \
    "$HOME/.tmux.conf" \
    "$HOME/.config/nvim" \
    "$HOME/.config/starship.toml" \
    "$HOME/.config/wezterm"
TMUX_XDG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
if [[ -L "$TMUX_XDG_DIR" ]]; then
    rm -f -- "$TMUX_XDG_DIR"
else
    rm -f -- "$TMUX_XDG_DIR/tmux.conf"
fi
stow -d "$DOTFILES_DIR" -t "$HOME" --no-folding zsh-macos nvim tmux-macos starship wezterm
NVIM_BIN="$("$BREW" --prefix neovim)/bin/nvim"
[[ -x "$NVIM_BIN" ]] || fail "Homebrew Neovim was not installed: $NVIM_BIN"
NODE24_BIN="$("$BREW" --prefix node@24)/bin"
GO_BIN="$("$BREW" --prefix go)/bin"
[[ -x "$NODE24_BIN/node" && -x "$NODE24_BIN/npm" ]] || fail "Homebrew Node 24/npm were not installed: $NODE24_BIN"
[[ -x "$GO_BIN/go" ]] || fail "Homebrew Go was not installed: $GO_BIN"
export PATH="$GO_BIN:$NODE24_BIN:$PATH"
"$NVIM_BIN" --headless --clean \
    "+lua if vim.fn.has('nvim-0.12') == 0 then vim.api.nvim_err_writeln('Neovim 0.12+ is required'); vim.cmd('cquit 1') end" \
    +qa || fail "Neovim 0.12+ is required for the shared Treesitter configuration."
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
SHARED_LOCKFILE="$DOTFILES_DIR/nvim/.config/nvim/lazy-lock.json"
[[ -f "$SHARED_LOCKFILE" ]] || fail "Missing shared Neovim plugin lockfile: $SHARED_LOCKFILE"
info "Rebuilding macOS Neovim plugins, parsers and language servers from a clean state..."
rm -rf -- "$NVIM_DATA_DIR" "$NVIM_STATE_DIR" "$NVIM_CACHE_DIR"
mkdir -p "$NVIM_DATA_DIR"
export FABRIKTOR_NVIM_LOCKFILE="$NVIM_DATA_DIR/fabriktor-lazy-lock.json"
cp "$SHARED_LOCKFILE" "$FABRIKTOR_NVIM_LOCKFILE"
"$NVIM_BIN" --headless -u "$DOTFILES_DIR/macos/nvim-bootstrap.lua" \
    "+Lazy! install" +qa || fail "Fresh Neovim plugin installation failed."
cp "$SHARED_LOCKFILE" "$FABRIKTOR_NVIM_LOCKFILE"
"$NVIM_BIN" --headless -u "$DOTFILES_DIR/macos/nvim-bootstrap.lua" \
    "+Lazy! restore" +qa || fail "Neovim plugin lockfile restoration failed."
info "Installing and verifying macOS Neovim language tools (blocking)..."
if ! "$NVIM_BIN" --headless -u "$DOTFILES_DIR/macos/nvim-bootstrap.lua" \
    "+luafile $DOTFILES_DIR/macos/nvim-provision.lua" +qa; then
    MASON_LOG="$NVIM_STATE_DIR/mason.log"
    if [[ -f "$MASON_LOG" ]]; then
        info "Recent Mason diagnostics ($MASON_LOG):"
        tail -n 60 "$MASON_LOG" >&2
    fi
    fail "Neovim language tools did not install successfully."
fi
unset FABRIKTOR_NVIM_LOCKFILE
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
