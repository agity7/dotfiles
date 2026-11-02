fabriktor_platform_init() {
    FABRIKTOR_ZSH_SYNTAX_PATH="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    FABRIKTOR_ZSH_AUTOSUGGESTIONS_PATH="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
}
fabriktor_platform_paths() {
    export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
    export ANDROID_STUDIO_HOME="/opt/android-studio"
    export PATH="$HOME/bin:$DEV_DIR/go/bin:$NPM_GLOBAL_BIN:$HOME/.local/bin:$DEV_DIR/flutter/bin:$DEV_DIR/flutter/bin/cache/dart-sdk/bin:$ANDROID_STUDIO_HOME/bin:$HOME/.cargo/bin:$PATH"
}
