# Starship.
eval "$(starship init zsh)"

# Enable syntax highlighting.
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Customize syntax highlighting styles to disable underlining globally.
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
for style in ${(k)ZSH_HIGHLIGHT_STYLES}; do
  ZSH_HIGHLIGHT_STYLES[$style]='nounderline'
done

# Additional custom styles.
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[command]='fg=#00bfff'  # Bright blue for commands.
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#00bfff'  # Bright blue for built-ins.
ZSH_HIGHLIGHT_STYLES[alias]='fg=#ffff00'     # Bright yellow for aliases.

# Customize auto-suggestions.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#aaaaaa,nounderline'  # Grey for suggestions.

# Aliases.
alias ls='ls -al'
alias ll='ls -al'
alias g='git'
