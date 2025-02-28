#!/bin/bash

# To access Android Studio download links, visit:
# https://developer.android.com/studio/archive

# Define variables.
DOTFILES_DIR="$HOME/dotfiles"
CARGO_BIN="$HOME/.cargo/bin"
FLUTTER_SDK_DIR="$HOME/development/flutter"
FLUTTER_TAR="$HOME/Downloads/flutter_linux_3.29.0-stable.tar.xz"
ANDROID_SDK="$HOME/Android/Sdk"
CMDLINE_TOOLS="$ANDROID_SDK/cmdline-tools/latest/bin"
LOG_FILE="$HOME/install.log"
JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
ANDROID_STUDIO_DIR="/opt/android-studio"
ANDROID_STUDIO_VERSION="2024.3.2.7"
ANDROID_STUDIO_TAR="android-studio-${ANDROID_STUDIO_VERSION}-linux.tar.gz"
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VERSION}/${ANDROID_STUDIO_TAR}"
FLUTTER_DOWNLOAD_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz"
RUST_INSTALL_URL="https://sh.rustup.rs"
FLATPAK_REPO_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"
GO_SWAGGER_URL="github.com/go-swagger/go-swagger/cmd/swagger@latest"

# Clear previous log file.
>"$LOG_FILE"

# Start logging.
exec > >(tee -a "$LOG_FILE") 2>&1
echo "========== Starting Installation: $(date) =========="

# Ensure required directories exist
mkdir -p "$ANDROID_SDK/cmdline-tools"

# Check Internet connectivity.
echo "Checking Internet connectivity..."
if ! ping -c 3 8.8.8.8 &>/dev/null; then
	echo "❌ Error: No Internet connection. Exiting."
	exit 1
fi
echo "✅ Internet connection verified."

# Ask for sudo password once and keep it cached.
echo "Caching sudo password..."
sudo -v
while sudo -v; do sleep 60; done 2>/dev/null &

# Update Fedora system.
echo "Updating Fedora system..."
if ! sudo dnf update -y; then
	echo "❌ Error: DNF update failed."
	exit 1
fi

# Install CLI tools.
echo "Installing CLI tools..."
sudo dnf install -y zsh \
	git \
	neovim \
	tmux \
	stow \
	golang \
	zsh-syntax-highlighting \
	zsh-autosuggestions \
	nodejs-npm \
	ripgrep \
	make \
	gcc \
	unzip \
	gzip \
	xz \
	zip \
	mesa-libGLU \
	libstdc++ \
	lib3270-devel \
	bzip2-libs \
	python3 \
	python3-pip \
	python3-virtualenv \
	flatpak \
	fira-code-fonts \
	clang \
	cmake \
	ninja-build \
	gtk3-devel \
	java-17-openjdk \
	google-chrome-stable || {
	echo "❌ Error: DNF package installation failed."
	exit 1
}

# Backup .zshrc before making any modifications.
if [ -f "$HOME/.zshrc" ]; then
	cp "$HOME/.zshrc" "$HOME/.zshrc_bak"
	echo "Backup of .zshrc created as .zshrc_bak."
else
	echo "No existing .zshrc file to back up."
fi

# Ensure Stow is installed and apply dotfiles BEFORE modifying .zshrc.
if command -v stow &>/dev/null; then
	for dir in zsh nvim tmux starship wezterm; do
		[ -d "$DOTFILES_DIR/$dir" ] && stow -d "$DOTFILES_DIR" -t "$HOME" "$dir"
	done
fi

# Set JAVA_HOME.
echo "export JAVA_HOME=$JAVA_HOME" >>"$HOME/.zshrc"
export JAVA_HOME="$JAVA_HOME"

# Install pipx if missing.
echo "Installing pipx..."
if ! command -v pipx &>/dev/null; then
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
	echo "✅ pipx installed."
else
	echo "✅ pipx is already installed."
fi

# Ensure pipx is in PATH.
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.zshrc"

# Install Commitizen.
echo "Installing Commitizen..."
pipx install commitizen || echo "⚠️ Commitizen installation skipped."

# Enable Flathub.
if ! flatpak remote-list | grep -q flathub; then
	echo "Adding Flathub repository to Flatpak..."
	sudo flatpak remote-add --if-not-exists flathub "$FLATPAK_REPO_URL"
fi

# Install Rust using rustup.
echo "Installing Rust..."
if ! command -v rustup &>/dev/null; then
	curl --proto '=https' --tlsv1.2 -sSf "$RUST_INSTALL_URL" | sh -s -- -y
	echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.zshrc"
	source "$HOME/.zshrc"
else
	rustup self update
fi

# Install Go-Swagger.
echo "Installing Go-Swagger..."
go install "$GO_SWAGGER_URL" || echo "⚠️ Go-Swagger installation skipped."

# Install Flutter SDK.
if [ ! -d "$FLUTTER_SDK_DIR" ]; then
	echo "Downloading Flutter SDK..."
	curl -o "$FLUTTER_TAR" -L "$FLUTTER_DOWNLOAD_URL"
	mkdir -p "$HOME/development"
	tar -xf "$FLUTTER_TAR" -C "$HOME/development/"
	rm "$FLUTTER_TAR"
fi

# Add Flutter & Dart to PATH.
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >>"$HOME/.zshrc"
echo 'export PATH="$HOME/development/flutter/bin/cache/dart-sdk/bin:$PATH"' >>"$HOME/.zshrc"
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/development/flutter/bin/cache/dart-sdk/bin:$PATH"

# Remove any previous Android Studio installation.
echo "Removing old Android Studio installation..."
sudo rm -rf /opt/android-studio

# Download Android Studio.
echo "Downloading Android Studio..."
wget -O "$ANDROID_STUDIO_TAR" "$ANDROID_STUDIO_URL"

# Extract Android Studio.
echo "Extracting Android Studio..."
sudo tar -xzf "$ANDROID_STUDIO_TAR" -C /opt/
rm "$ANDROID_STUDIO_TAR"

# Verify the extraction.
if [ ! -f "/opt/android-studio/bin/studio.sh" ]; then
	echo "❌ Error: Android Studio installation failed. studio.sh not found."
	exit 1
fi

# Set Android Studio environment variables.
echo "export ANDROID_STUDIO_HOME=$ANDROID_STUDIO_DIR" >>"$HOME/.zshrc"
echo "export PATH=\$ANDROID_STUDIO_HOME/bin:\$PATH" >>"$HOME/.zshrc"
export ANDROID_STUDIO_HOME="$ANDROID_STUDIO_DIR"
export PATH="$ANDROID_STUDIO_HOME/bin:$PATH"

# Launch Android Studio to complete setup.
echo "Launching Android Studio for initial setup..."
/opt/android-studio/bin/studio.sh

# Wait for user to close Android Studio before continuing.
echo "Waiting for Android Studio to close..."
while pgrep -f studio.sh >/dev/null; do
	sleep 2
done

# Ensure Android Studio is detected.
flutter config --android-studio-dir="$ANDROID_STUDIO_DIR"

# Run Flutter doctor.
echo "Running flutter doctor..."
flutter doctor

echo "========== Installation Completed: $(date) =========="
echo "✅ Please restart your system for changes to take effect."
