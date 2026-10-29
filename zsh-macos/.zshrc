# macOS wrapper around the shared, unchanged Linux Zsh configuration.
# setup-macos.sh installs this file through Stow.

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
fi

# Keep the original macOS paths/settings instead of the Linux-only values
# exported by zsh/.zshrc, while sharing its aliases, safety prompts and theme.
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

# node@24 is keg-only: expose the pinned Node LTS without modifying global
# Homebrew links or conflicting with another installed Node version.
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/opt/node@24/bin" ]]; then
    path=("$HOMEBREW_PREFIX/opt/node@24/bin" $path)
fi
path=("$HOME/.local/bin" "$HOME/.cargo/bin" "$NPM_GLOBAL_BIN" $path)
typeset -U path

# Homebrew installs these under its own prefix, unlike Fedora's /usr/share.
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    [[ -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [[ -r "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
