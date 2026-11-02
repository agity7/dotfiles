case "$OSTYPE" in
    darwin*) source "$HOME/dotfiles/zsh-platform/macos.zsh" ;;
    *) source "$HOME/dotfiles/zsh-platform/linux.zsh" ;;
esac
fabriktor_platform_init
unsetopt RM_STAR_SILENT
setopt RM_STAR_WAIT
eval "$(starship init zsh)"
unset SSH_ASKPASS
[[ -r "$FABRIKTOR_ZSH_SYNTAX_PATH" ]] && source "$FABRIKTOR_ZSH_SYNTAX_PATH"
[[ -r "$FABRIKTOR_ZSH_AUTOSUGGESTIONS_PATH" ]] && source "$FABRIKTOR_ZSH_AUTOSUGGESTIONS_PATH"
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
for k in ${(k)ZSH_HIGHLIGHT_STYLES}; do
    ZSH_HIGHLIGHT_STYLES[$k]="nounderline"
done
ZSH_HIGHLIGHT_STYLES[default]="none"
ZSH_HIGHLIGHT_STYLES[command]="fg=#00bfff"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=#00bfff"
ZSH_HIGHLIGHT_STYLES[alias]="fg=#ffff00"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#aaaaaa,nounderline"
alias ls="ls -al"
alias ll="ls -al"
alias g="git"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
export DEV_DIR="$HOME/.dev"
fabriktor_platform_paths
