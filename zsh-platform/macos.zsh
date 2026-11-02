fabriktor_platform_init() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv zsh)"
    fi
    export NPM_GLOBAL_BIN="$HOME/.local/npm/bin"
    FABRIKTOR_ZSH_SYNTAX_PATH="${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh}"
    FABRIKTOR_ZSH_AUTOSUGGESTIONS_PATH="${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh}"
}
fabriktor_platform_paths() {
    if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/opt/node@24/bin" ]]; then
        path=("$HOMEBREW_PREFIX/opt/node@24/bin" $path)
    fi
    path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$NPM_GLOBAL_BIN" $path)
    typeset -U path
}
