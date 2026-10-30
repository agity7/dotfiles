if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
fi
_fabriktor_macos_path="$PATH"
_fabriktor_macos_java_home="${JAVA_HOME-}"
_fabriktor_macos_android_home="${ANDROID_STUDIO_HOME-}"
export NPM_GLOBAL_BIN="$HOME/.local/npm/bin"
source "$HOME/dotfiles/zsh/.zshrc"
export PATH="$_fabriktor_macos_path"
if [[ -n "$_fabriktor_macos_java_home" ]]; then
    export JAVA_HOME="$_fabriktor_macos_java_home"
else
    unset JAVA_HOME
fi
if [[ -n "$_fabriktor_macos_android_home" ]]; then
    export ANDROID_STUDIO_HOME="$_fabriktor_macos_android_home"
else
    unset ANDROID_STUDIO_HOME
fi
unset _fabriktor_macos_path _fabriktor_macos_java_home _fabriktor_macos_android_home
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/opt/node@24/bin" ]]; then
    path=("$HOMEBREW_PREFIX/opt/node@24/bin" $path)
fi
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$NPM_GLOBAL_BIN" $path)
typeset -U path
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    [[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
