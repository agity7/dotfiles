#!/bin/bash

# ==================== VARIABLES ====================
GO_VERSION="1.24.2"
SWAGGER_VERSION="v0.30.0"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/install.log"
DEV_DIR="$HOME/.dev"
FLUTTER_TAR="$HOME/Downloads/flutter_linux_3.29.0-stable.tar.xz"
ANDROID_STUDIO_DIR="/opt/android-studio"
ANDROID_STUDIO_VERSION="2024.3.2.7"
ANDROID_STUDIO_TAR="android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz"
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/${ANDROID_STUDIO_TAR}"
ANDROID_SDK_ROOT="$HOME/Android/Sdk"
FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz"
FLATPAK_REPO_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"
GO_SWAGGER_URL="github.com/go-swagger/go-swagger/cmd/swagger@${SWAGGER_VERSION}"
FONT_DIR="$HOME/.local/share/fonts/FiraCode"
RUST_INSTALL_URL="https://sh.rustup.rs"
DROPBOX_URL="https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2024.04.17-1.fc39.x86_64.rpm"
LIBREWOLF_REPO_URL="https://repo.librewolf.net/librewolf.repo"
LIBREWOLF_REPO_PATH="/etc/yum.repos.d/librewolf.repo"
DOCKER_DESKTOP_RPM_URL="https://desktop.docker.com/linux/main/amd64/docker-desktop-x86_64.rpm"
DOCKER_DESKTOP_RPM="/tmp/docker-desktop-x86_64.rpm"
DNF_UPDATE_EXCLUDES=(
	"nautilus-dropbox"
)
SUCCESS="[SUCCESS]"
FAILURE="[FAILURE]"

echo "$SUCCESS Variables loaded from vars.sh"
