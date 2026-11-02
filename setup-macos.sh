#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos/vars.sh"
source "$(dirname "${BASH_SOURCE[0]}")/macos/functions.sh"
verify_macos
verify_dotfiles_directory
ensure_command_line_tools
ensure_homebrew
install_brew_packages
setup_macos_dotfiles
prepare_macos_toolchain
verify_neovim_version
rebuild_macos_neovim
install_tmux_plugin_manager
check_default_shell
info "macOS dotfiles installed. Open a new WezTerm window to load Zsh."
info "Run: node -v && npm -v && nvim --version && tmux -V"
info "For iOS builds, verify Xcode with: xcodebuild -version && xcrun simctl list devices available"
