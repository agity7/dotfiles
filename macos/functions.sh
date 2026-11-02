info() {
    printf '→ %s\n' "$*"
}
fail() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}
verify_macos() {
    [[ "$(uname -s)" == "Darwin" ]] || fail "This installer is only for macOS; Linux setup.sh is unchanged."
}
verify_dotfiles_directory() {
    [[ "$DOTFILES_DIR" == "$HOME/dotfiles" ]] || fail "Clone this repository to ~/dotfiles first (current path: $DOTFILES_DIR)."
}
ensure_command_line_tools() {
    if ! xcode-select -p >/dev/null 2>&1; then
        info "Install Apple's Command Line Tools in the dialog, then rerun this script."
        xcode-select --install || true
        exit 1
    fi
}
find_homebrew() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        BREW=/opt/homebrew/bin/brew
    elif [[ -x /usr/local/bin/brew ]]; then
        BREW=/usr/local/bin/brew
    elif command -v brew >/dev/null 2>&1; then
        BREW="$(command -v brew)"
    else
        return 1
    fi
}
ensure_homebrew() {
    if ! find_homebrew; then
        info "Installing Homebrew (first run only)..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        find_homebrew || fail "Homebrew installation completed, but brew could not be found."
    fi
    eval "$("$BREW" shellenv bash)"
}
install_brew_packages() {
    info "Installing/upgrading macOS packages (non-interactive)..."
    HOMEBREW_NO_ASK=1 brew bundle install --upgrade --file="$BREWFILE"
}
setup_macos_dotfiles() {
    info "Linking the shared Neovim, tmux, Starship and WezTerm configs..."
    if [[ -d "$HOME/.config/wezterm" && ! -L "$HOME/.config/wezterm" ]]; then
        local saved saved_dir
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
    if [[ -L "$TMUX_XDG_DIR" ]]; then
        rm -f -- "$TMUX_XDG_DIR"
    else
        rm -f -- "$TMUX_XDG_DIR/tmux.conf"
    fi
    stow -d "$DOTFILES_DIR" -t "$HOME" --no-folding zsh nvim tmux starship wezterm
}
prepare_macos_toolchain() {
    NVIM_BIN="$("$BREW" --prefix neovim)/bin/nvim"
    [[ -x "$NVIM_BIN" ]] || fail "Homebrew Neovim was not installed: $NVIM_BIN"
    NODE24_BIN="$("$BREW" --prefix node@24)/bin"
    GO_BIN="$("$BREW" --prefix go)/bin"
    [[ -x "$NODE24_BIN/node" && -x "$NODE24_BIN/npm" ]] || fail "Homebrew Node 24/npm were not installed: $NODE24_BIN"
    [[ -x "$GO_BIN/go" ]] || fail "Homebrew Go was not installed: $GO_BIN"
    export PATH="$GO_BIN:$NODE24_BIN:$PATH"
}
verify_neovim_version() {
    "$NVIM_BIN" --headless --clean \
        "+lua if vim.fn.has('nvim-0.12') == 0 then vim.api.nvim_err_writeln('Neovim 0.12+ is required'); vim.cmd('cquit 1') end" \
        +qa || fail "Neovim 0.12+ is required for the shared Treesitter configuration."
}
rebuild_macos_neovim() {
    [[ -f "$SHARED_LOCKFILE" ]] || fail "Missing shared Neovim plugin lockfile: $SHARED_LOCKFILE"
    info "Rebuilding macOS Neovim plugins, parsers and language servers from a clean state..."
    rm -rf -- "$NVIM_DATA_DIR" "$NVIM_STATE_DIR" "$NVIM_CACHE_DIR"
    mkdir -p "$NVIM_DATA_DIR"
    export FABRIKTOR_NVIM_LOCKFILE="$NVIM_DATA_DIR/fabriktor-lazy-lock.json"
    cp "$SHARED_LOCKFILE" "$FABRIKTOR_NVIM_LOCKFILE"
    "$NVIM_BIN" --headless -u "$NVIM_BOOTSTRAP" \
        "+Lazy! install" +qa || fail "Fresh Neovim plugin installation failed."
    cp "$SHARED_LOCKFILE" "$FABRIKTOR_NVIM_LOCKFILE"
    "$NVIM_BIN" --headless -u "$NVIM_BOOTSTRAP" \
        "+Lazy! restore" +qa || fail "Neovim plugin lockfile restoration failed."
    info "Installing and verifying macOS Neovim language tools (blocking)..."
    if ! "$NVIM_BIN" --headless -u "$NVIM_BOOTSTRAP" \
        "+luafile $NVIM_PROVISION" +qa; then
        local mason_log="$NVIM_STATE_DIR/mason.log"
        if [[ -f "$mason_log" ]]; then
            info "Recent Mason diagnostics ($mason_log):"
            tail -n 60 "$mason_log" >&2
        fi
        fail "Neovim language tools did not install successfully."
    fi
    unset FABRIKTOR_NVIM_LOCKFILE
}
install_tmux_plugin_manager() {
    if [[ ! -e "$TPM_DIR" && ! -L "$TPM_DIR" ]]; then
        info "Installing TPM for the existing tmux config..."
        mkdir -p "$(dirname "$TPM_DIR")"
        git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
    [[ -f "$TPM_DIR/tpm" ]] || fail "TPM directory exists but is incomplete: $TPM_DIR"
}
check_default_shell() {
    if [[ "${SHELL:-}" != */zsh ]]; then
        info "Your login shell is not Zsh. Run: chsh -s /bin/zsh"
    fi
}
