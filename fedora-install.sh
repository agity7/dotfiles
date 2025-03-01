#!/bin/bash

# =====================================================
# Dev Environment Setup Script for Fedora
# =====================================================
# This script is dedicated to setting up a development environment on Fedora
# for Go backend development and Flutter frontend development.
# It installs necessary CLI tools, programming languages, frameworks,
# and essential utilities to streamline development.
#
# =====================================================
# Post-Installation Steps
# =====================================================
# 1 - Make Caps Lock act as Control to facilitate Neovim keybindings:
#    - Install GNOME Tweaks using: sudo dnf install -y gnome-tweaks
#    - Open GNOME Tweaks and remap Caps Lock to Control.
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
# ✅ Verify the latest version of Android Studio at:
#    https://developer.android.com/studio/archive
# =====================================================

# Exit immediately if a command fails.
set -e

# ==================== VARIABLES ====================
DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$HOME/install.log"
FLUTTER_SDK_DIR="$HOME/development/flutter"
FLUTTER_TAR="$HOME/Downloads/flutter_linux_3.29.0-stable.tar.xz"
ANDROID_STUDIO_DIR="/opt/android-studio"
ANDROID_STUDIO_VERSION="2024.3.2.7"
ANDROID_STUDIO_TAR="android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz"
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/${ANDROID_STUDIO_TAR}"
FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz"
FLATPAK_REPO_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"
GO_SWAGGER_URL="github.com/go-swagger/go-swagger/cmd/swagger@latest"
FONT_DIR="$HOME/.local/share/fonts/FiraCode"
RUST_INSTALL_URL="https://sh.rustup.rs"
DROPBOX_URL="https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2024.04.17-1.fc39.x86_64.rpm"
LIBREWOLF_REPO_URL="https://repo.librewolf.net/librewolf.repo"
LIBREWOLF_REPO_PATH="/etc/yum.repos.d/librewolf.repo"
SUCCESS="[SUCCESS]"
FAILURE="[FAILURE]"

# ==================== LOGGING ====================
>"$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========== 🚀 Starting Installation: $(date) =========="

# ==================== FUNCTIONS ====================
install_librewolf() {
	if command -v librewolf &>/dev/null; then
		echo "$SUCCESS LibreWolf is already installed. Skipping installation."
		return
	fi

	echo "🦊 Installing LibreWolf..."
	curl -fsSL "$LIBREWOLF_REPO_URL" | sudo tee "$LIBREWOLF_REPO_PATH"
	sudo dnf install -y librewolf
	echo "$SUCCESS LibreWolf installation completed."
}

install_dnf_packages() {
	echo "📦 Installing CLI tools..."
	sudo dnf install -y \
		gnome-tweaks zsh git fzf bat neovim tmux stow golang zsh-syntax-highlighting \
		zsh-autosuggestions nodejs-npm ripgrep make gcc unzip gzip xz zip \
		wl-clipboard xclip mesa-libGLU libstdc++ bzip2-libs python3 python3-pip \
		python3-virtualenv flatpak clang cmake ninja-build gtk3-devel java-17-openjdk \
		google-chrome-stable
	echo "$SUCCESS CLI tools installation completed."
}

check_internet() {
	echo "🌐 Checking Internet connectivity..."
	if ! ping -c 3 8.8.8.8 &>/dev/null; then
		echo "$FAILURE No Internet connection. Exiting."
		exit 1
	fi
	echo "$SUCCESS Internet connection verified."
}

download_and_extract() {
	local url="$1"
	local output="$2"
	local dest="$3"

	echo "⬇️ Downloading $output..."
	wget -O "$output" "$url" || {
		echo "$FAILURE Failed to download $output"
		exit 1
	}
	echo "📦 Extracting $output..."
	sudo tar -xzf "$output" -C "$dest" || {
		echo "$FAILURE Failed to extract $output"
		exit 1
	}
	rm "$output"
	echo "$SUCCESS $output installation completed."
}

install_dropbox() {
	echo "📦 Installing Dropbox (CLI Only)..."
	if command -v dropbox &>/dev/null; then
		echo "$SUCCESS Dropbox is already installed. Skipping installation."
		return
	fi
	wget -O /tmp/nautilus-dropbox.rpm "$DROPBOX_URL"
	sudo dnf install -y /tmp/nautilus-dropbox.rpm
	rm /tmp/nautilus-dropbox.rpm
	dropbox autostart y
	echo "$SUCCESS Dropbox CLI installation completed. Use 'dropbox start' to launch it."
}

setup_dotfiles() {
	echo "🔧 Setting up dotfiles..."
	if command -v stow &>/dev/null; then
		for dir in zsh nvim tmux starship wezterm; do
			[ -d "$DOTFILES_DIR/$dir" ] && stow -d "$DOTFILES_DIR" -t "$HOME" "$dir"
		done
	fi
	echo "$SUCCESS Dotfiles setup completed."
}

install_rust() {
	echo "🦀 Installing Rust..."
	if ! command -v rustup &>/dev/null; then
		curl --proto '=https' --tlsv1.2 -sSf "$RUST_INSTALL_URL" | sh -s -- -y
		source "$HOME/.cargo/env"
	else
		rustup self update
	fi
	echo "$SUCCESS Rust installation completed."
}

install_pipx_commitizen() {
	echo "🐍 Installing pipx & Commitizen..."
	if ! command -v pipx &>/dev/null; then
		python3 -m pip install --user pipx
		python3 -m pipx ensurepath
	fi
	pipx install commitizen || echo "$FAILURE Commitizen installation skipped."
	echo "$SUCCESS Pipx & Commitizen installation completed."
}

setup_flatpak() {
	echo "📦 Setting up Flatpak..."
	if ! flatpak remote-list | grep -q flathub; then
		sudo flatpak remote-add --if-not-exists flathub "$FLATPAK_REPO_URL"
	fi
	echo "$SUCCESS Flatpak setup completed."
}

install_font() {
	echo "🔠 Installing Fira Code Nerd Font Mono..."
	mkdir -p "$FONT_DIR"
	cd "$FONT_DIR"
	wget -O FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
	unzip -o FiraCode.zip && rm FiraCode.zip
	fc-cache -fv
	echo "$SUCCESS Font installation completed."
}

install_flutter() {
	echo "🦋 Installing Flutter SDK..."
	if [ ! -d "$FLUTTER_SDK_DIR" ]; then
		download_and_extract "$FLUTTER_DOWNLOAD_URL" "$FLUTTER_TAR" "$HOME/development"
	fi
	echo "$SUCCESS Flutter installation completed."
}

install_android_studio() {
	echo "🤖 Installing Android Studio..."
	sudo rm -rf "$ANDROID_STUDIO_DIR"
	download_and_extract "$ANDROID_STUDIO_URL" "$ANDROID_STUDIO_TAR" "/opt"
	echo "$SUCCESS Android Studio installation completed."
}

# ==================== EXECUTION ====================
check_internet

# Cache sudo password.
sudo -v
while sudo -v; do sleep 60; done 2>/dev/null &

# System update & CLI tool installation.
echo "🔄 Updating Fedora system..."
sudo dnf update -y
install_dnf_packages

# Setup dotfiles.
setup_dotfiles

# Install LibreWolf.
install_librewolf

# Install Dropbox (CLI Only).
install_dropbox

# Install pipx & Commitizen.
install_pipx_commitizen

# Enable Flathub.
setup_flatpak

# Install Rust.
install_rust

# Install Fira Code Nerd Font Mono.
install_font

# Install Flutter SDK.
install_flutter

# Install Android Studio.
install_android_studio

# Install Go-Swagger.
echo "🦫 Installing Go-Swagger..."
go install "$GO_SWAGGER_URL" || echo "$FAILURE Go-Swagger installation skipped."
echo "$SUCCESS Go-Swagger installation completed."

# Run Flutter doctor.
echo "🦋 Running Flutter doctor..."
flutter doctor

echo "========== 🎉 Installation Completed: $(date) =========="
echo "$SUCCESS Please restart your system for changes to take effect."
