#!/bin/bash

# Define variables.
DOTFILES_DIR="$HOME/dotfiles"
CARGO_BIN="$HOME/.cargo/bin"
FLUTTER_SDK_DIR="$HOME/development/flutter"
FLUTTER_TAR="$HOME/Downloads/flutter_linux_3.29.0-stable.tar.xz"
ANDROID_SDK="$HOME/Android/Sdk"
LOG_FILE="$HOME/install.log"

# Start logging.
exec > >(tee -a "$LOG_FILE") 2>&1
echo "========== Starting Installation: $(date) =========="

# Ensure we are in the dotfiles directory.
if [ ! -d "$DOTFILES_DIR" ]; then
	echo "Error: $DOTFILES_DIR does not exist. Please clone or create it first."
	exit 1
fi

cd "$DOTFILES_DIR" || {
	echo "Error: Failed to enter $DOTFILES_DIR. Exiting."
	exit 1
}

# Check Internet connectivity.
echo "Checking Internet connectivity..."
if ! ping -c 3 8.8.8.8 &>/dev/null; then
	echo "Error: No Internet connection. Please check your network and try again."
	exit 1
fi
echo "Internet is working."

# Ask for sudo password once and keep it cached.
echo "Caching sudo password..."
sudo -v
while sudo -v; do sleep 60; done 2>/dev/null &

# Update Fedora system.
echo "Updating DNF packages..."
if ! sudo dnf update -y; then
	echo "Error: DNF update failed."
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
	gtk3-devel || {
	echo "Error: DNF package installation failed."
	exit 1
}

# Install pipx if missing.
echo "Installing pipx..."
if ! command -v pipx &>/dev/null; then
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
	echo "pipx installed successfully."
else
	echo "pipx is already installed."
fi

# Ensure pipx is in PATH.
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.zshrc"

# Install Commitizen.
echo "Installing Commitizen..."
pipx install commitizen || echo "Commitizen installation skipped."

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
else
	rustup self update
fi
export PATH="$HOME/.cargo/bin:$PATH"

# Install Go-Swagger.
echo "Installing Go-Swagger..."
go install github.com/go-swagger/go-swagger/cmd/swagger@latest || echo "Go-Swagger installation skipped."

# Install Flutter SDK.
if [ ! -d "$FLUTTER_SDK_DIR" ]; then
	echo "Downloading Flutter SDK..."
	curl -o "$FLUTTER_TAR" -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz
	mkdir -p "$HOME/development"
	tar -xf "$FLUTTER_TAR" -C "$HOME/development/"
	rm "$FLUTTER_TAR"
fi

# Add Flutter to PATH.
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >>"$HOME/.zshrc"
echo 'export PATH="$HOME/development/flutter/bin/cache/dart-sdk/bin:$PATH"' >>"$HOME/.zshrc"
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/development/flutter/bin/cache/dart-sdk/bin:$PATH"

# Install Android Studio via Flatpak.
echo "Installing Android Studio..."
flatpak install -y flathub com.google.AndroidStudio || echo "Android Studio installation skipped."

# Install Android SDK.
SDKMANAGER="$ANDROID_SDK/cmdline-tools/latest/bin/sdkmanager"
if [ ! -f "$SDKMANAGER" ]; then
	echo "Installing Android SDK..."
	mkdir -p "$ANDROID_SDK"
	flatpak run com.google.AndroidStudio --install-sdk
	yes | "$ANDROID_SDK/cmdline-tools/bin/sdkmanager" --install "cmdline-tools;latest"
fi

# Accept Android SDK licenses.
echo "Accepting Android SDK licenses..."
yes | "$FLUTTER_SDK_DIR/bin/flutter" doctor --android-licenses

# Ensure Android Studio is detected.
ANDROID_STUDIO_PATH=$(flatpak info --show-location com.google.AndroidStudio)
if [ -d "$ANDROID_STUDIO_PATH" ]; then
	flutter config --android-studio-dir="$ANDROID_STUDIO_PATH"
fi

# Install Google Chrome via Flatpak.
echo "Installing Google Chrome..."
flatpak install -y flathub com.google.Chrome || echo "Google Chrome installation skipped."
flutter config --set CHROME_EXECUTABLE="/usr/bin/flatpak run com.google.Chrome"

# Install WezTerm via Flatpak.
echo "Installing WezTerm..."
flatpak install -y flathub org.wezfurlong.wezterm || echo "WezTerm installation skipped."

# Install Starship.
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Ensure Starship is initialized in Zsh.
echo 'eval "$(starship init zsh)"' >>"$HOME/.zshrc"

# Ensure Stow is installed.
if ! command -v stow &>/dev/null; then
	echo "Error: GNU Stow is not installed."
	exit 1
fi

# Stow dotfiles.
[ -d "$DOTFILES_DIR/zsh" ] && stow zsh
[ -d "$DOTFILES_DIR/nvim" ] && stow nvim
[ -d "$DOTFILES_DIR/tmux" ] && stow tmux
[ -d "$DOTFILES_DIR/starship" ] && stow starship
[ -d "$DOTFILES_DIR/wezterm" ] && stow wezterm

# Set Zsh as default shell.
sudo chsh -s "$(which zsh)" "$USER"

# Ensure PATH updates take effect.
source "$HOME/.zshrc"
source "$HOME/.bashrc"
source "$HOME/.profile"

# Run flutter doctor.
echo "Running flutter doctor..."
"$FLUTTER_SDK_DIR/bin/flutter" doctor

echo "========== Installation Completed: $(date) =========="
echo "✅ Please restart your system for changes to take effect."
