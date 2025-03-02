# Starship prompt.
eval "$(starship init zsh)"

# Unset SSH_ASKPASS to avoid issues with ksshaskpass.
unset SSH_ASKPASS

# Enable syntax highlighting & autosuggestions.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Customize syntax highlighting styles to disable underlining globally.
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
for style in ${(k)ZSH_HIGHLIGHT_STYLES}; do
  ZSH_HIGHLIGHT_STYLES[$style]='nounderline'
done

# Additional custom styles.
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[command]='fg=#00bfff'  # Bright blue for commands.
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#00bfff'  # Bright blue for built-ins.
ZSH_HIGHLIGHT_STYLES[alias]='fg=#ffff00'    # Bright yellow for aliases.

# Customize auto-suggestions.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#aaaaaa,nounderline'  # Grey for suggestions.

# Aliases.
alias ls='ls -al'
alias ll='ls -al'
alias g='git'
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias cat='bat'

# Exports.
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export ANDROID_STUDIO_HOME=/opt/android-studio
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/development/flutter/bin:$HOME/development/flutter/bin/cache/dart-sdk/bin:$ANDROID_STUDIO_HOME/bin:$PATH"
