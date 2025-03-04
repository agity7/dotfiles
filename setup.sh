#!/bin/bash

source "$(dirname "$0")/vars.sh"
source "$(dirname "$0")/functions.sh"
set -e

# =====================================================
# Dev Environment & Proprietary Fixes Setup Script for Fedora 41
# =====================================================
# This script is designed to set up a development environment
# on Linux distributions using DNF and Flatpak, such as Fedora.
#
# It is intended to be run multiple times and is highly flexible.
# Functions can be easily commented/uncommented to install,
# update, or bypass specific configurations, making it adaptable
# for evolving setups and repeated runs.
#
# =====================================================
# Post-Installation Steps
# =====================================================
# 1 - Make Caps Lock act as Control to facilitate Neovim keybindings.
#
# 2 - Create and configure SSH keys for GitLab and GitHub:
#    - Generate a new SSH key: ssh-keygen -t ed25519 -C "your_email@example.com"
#    - Start the SSH agent: eval "$(ssh-agent -s)"
#    - Add the SSH key: ssh-add ~/.ssh/id_ed25519
#    - Copy the SSH key to clipboard: cat ~/.ssh/id_ed25519.pub | xclip -sel clip
#    - Add the key to GitHub and GitLab via their web interfaces.
#
# =====================================================
# Manual Verification Before Running the Script
# =====================================================
# 1 - Verify the latest version of Android Studio at:
#    https://developer.android.com/studio/archive
# =====================================================

# ==================== INITIALIZATION ====================
>"$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "========== 🚀 Starting Installation: $(date) =========="
check_internet
sudo -v
while sudo -v; do sleep 800; done 2>/dev/null &
echo "🔄 Updating Fedora system..."
sudo dnf update -y

# ==================== EXECUTION ====================
install_dnf_packages
set_zsh_default
setup_dotfiles
# install_librewolf
install_docker
install_dropbox
install_pipx_commitizen
setup_flatpak
install_rust
install_font
install_starship
install_wezterm
install_go_swagger
install_flutter
install_android_studio
run_flutter_doctor
# fix_amdgpu_on_fedora

echo "$SUCCESS Please restart your system for changes to take effect."
echo "========== 🎉 Installation Completed: $(date) =========="
