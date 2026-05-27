eval "$(starship init zsh)"
unset SSH_ASKPASS
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
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
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export ANDROID_STUDIO_HOME="/opt/android-studio"
export PATH="$DEV_DIR/go/bin:$HOME/.local/bin:$HOME/bin:$DEV_DIR/flutter/bin:$DEV_DIR/flutter/bin/cache/dart-sdk/bin:$ANDROID_STUDIO_HOME/bin:$HOME/.cargo/bin:$PATH"
