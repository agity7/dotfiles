#!/bin/bash

# Define variables.
DOTFILES_DIR="$HOME/dotfiles"
CARGO_BIN="$HOME/.cargo/bin"
FLUTTER_SDK_DIR="$HOME/development/flutter"
FLUTTER_TAR="$HOME/Downloads/flutter_linux_3.29.0-stable.tar.xz"
ANDROID_SDK="$HOME/Android/Sdk"
CMDLINE_TOOLS="$ANDROID_SDK/cmdline-tools/latest/bin"
LOG_FILE="$HOME/install.log"

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
	nodejs npm \
	ripgrep \
	make \
	gcc \
	unzip \
	xz \
	zip \
	mesa-libGLU \
	libstdc++ \
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
	sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# Install Rust using rustup.
echo "Installing Rust..."
if ! command -v rustup &>/dev/null; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.zshrc"
	source "$HOME/.zshrc"
else
	rustup self update
fi

# Install Go-Swagger.
echo "Installing Go-Swagger..."
go install github.com/go-swagger/go-swagger/cmd/swagger@latest || echo "⚠️ Go-Swagger installation skipped."

# Install Flutter SDK.
if [ ! -d "$FLUTTER_SDK_DIR" ]; then
	echo "Downloading Flutter SDK..."
	curl -o "$FLUTTER_TAR" -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz
	mkdir -p "$HOME/development"
	tar -xf "$FLUTTER_TAR" -C "$HOME/development/"
	rm "$FLUTTER_TAR"
fi

# Add Flutter & Dart to PATH.
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >>"$HOME/.zshrc"
echo 'export PATH="$HOME/development/flutter/bin/cache/dart-sdk/bin:$PATH"' >>"$HOME/.zshrc"
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/development/flutter/bin/cache/dart-sdk/bin:$PATH"

# Install Android Studio via Flatpak.
echo "Installing Android Studio..."
flatpak install -y flathub com.google.AndroidStudio || echo "⚠️ Android Studio installation skipped."

# Install Android SDK command-line tools.
if [ ! -f "$CMDLINE_TOOLS/sdkmanager" ]; then
	echo "Installing Android SDK command-line tools..."
	yes | flatpak run com.google.AndroidStudio --install-sdk
	yes | "$CMDLINE_TOOLS/sdkmanager" --install "cmdline-tools;latest"
fi

# Ensure Android Studio is detected.
ANDROID_STUDIO_PATH=$(flatpak info --show-location com.google.AndroidStudio)
if [ -d "$ANDROID_STUDIO_PATH" ]; then
	flutter config --android-studio-dir="$ANDROID_STUDIO_PATH"
fi

# Accept Android SDK licenses.
yes | "$CMDLINE_TOOLS/sdkmanager" --licenses

# Install Google Chrome via DNF.
echo "Installing Google Chrome..."
sudo dnf install -y google-chrome-stable || echo "⚠️ Google Chrome installation skipped."

# Ensure Chrome is detected by Flutter.
CHROME_PATH=$(which google-chrome)
flutter config --enable-web
flutter config --set CHROME_EXECUTABLE="$CHROME_PATH"

# Install WezTerm via Flatpak.
echo "Installing WezTerm..."
flatpak install -y flathub org.wezfurlong.wezterm || echo "⚠️ WezTerm installation skipped."

# Install Starship.
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y || echo "⚠️ Starship installation skipped."
echo 'eval "$(starship init zsh)"' >>"$HOME/.zshrc"

# Ensure Stow is installed and apply dotfiles.
if command -v stow &>/dev/null; then
	[ -d "$DOTFILES_DIR/zsh" ] && stow -d "$DOTFILES_DIR" -t "$HOME" zsh
	[ -d "$DOTFILES_DIR/nvim" ] && stow -d "$DOTFILES_DIR" -t "$HOME" nvim
	[ -d "$DOTFILES_DIR/tmux" ] && stow -d "$DOTFILES_DIR" -t "$HOME" tmux
	[ -d "$DOTFILES_DIR/starship" ] && stow -d "$DOTFILES_DIR" -t "$HOME" starship
	[ -d "$DOTFILES_DIR/wezterm" ] && stow -d "$DOTFILES_DIR" -t "$HOME" wezterm
fi

# Set Zsh as default shell.
sudo chsh -s "$(which zsh)" "$USER"

# Run Flutter doctor.
echo "Running flutter doctor..."
flutter doctor

echo "========== Installation Completed: $(date) =========="
echo "✅ Please restart your system for changes to take effect."
