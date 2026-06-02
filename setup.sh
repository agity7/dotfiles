#!/bin/bash
source "$(dirname "$0")/vars.sh"
source "$(dirname "$0")/functions.sh"
set -e
>"$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
info "Starting installation: $(date)"
check_internet
ensure_directory_exists "$DEV_DIR"
sudo -v
while sudo -v; do sleep 800; done 2>/dev/null &
dnf_update_system
install_dnf_packages
install_npm_global_packages
setup_dotfiles
setup_env_file
# install_librewolf
install_docker
install_dropbox
install_pipx_commitizen
setup_flatpak
install_rust
install_sd
install_aider
sync_aider_conventions
install_aider_convention_scraper
install_font
install_starship
install_wezterm
install_go
# install_go_swagger
# install_flutter
# install_android_studio
# run_flutter_doctor
fix_amdgpu_on_fedora
set_zsh_default
ok "Please restart your system for changes to take effect"
ok "Installation completed: $(date)"
