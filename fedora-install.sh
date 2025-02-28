#!/bin/bash

# Define variables.
DOTFILES_DIR="$HOME/dotfiles"
CARGO_BIN="$HOME/.cargo/bin"
FLUTTER_SDK_DIR="$HOME/development/flutter"
FLUTTER_TAR="$HOME/Downloads/flutter_linux_3.29.0-stable.tar.xz"
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

# Update DNF.
echo "Updating DNF packages..."
if ! sudo dnf update -y; then
	echo "Error: DNF update failed."
	exit 1
fi

# Install CLI tools.
echo "Installing CLI tools..."
if ! sudo dnf install -y zsh \
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
	lib3270-devel.i686 \
	bzip2-libs \
	python3 \
	python3-pip \
	python3-virtualenv \
	flatpak; then
	echo "Error: DNF package installation failed."
	exit 1
fi

# Install pipx manually (since it's not in DNF).
echo "Installing pipx..."
if ! command -v pipx &>/dev/null; then
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
	echo "pipx installed successfully."
else
	echo "pipx is already installed."
fi

# Ensure pipx is in PATH.
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
	echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.zshrc"
	export PATH="$HOME/.local/bin:$PATH"
fi

# Install Commitizen.
echo "Installing Commitizen..."
if ! command -v cz &>/dev/null; then
	pipx install commitizen
	echo "Commitizen installed successfully."
else
	echo "Commitizen is already installed."
fi

# Ensure Flatpak is set up.
if ! command -v flatpak &>/dev/null; then
	echo "Error: Flatpak installation failed. Exiting..."
	exit 1
fi

# Enable Flathub if not already enabled.
if ! flatpak remote-list | grep -q flathub; then
	echo "Adding Flathub repository to Flatpak..."
	sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# Install Rust properly using rustup (not dnf).
if ! command -v rustup &>/dev/null; then
	echo "Installing Rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-install.sh
	chmod +x rustup-install.sh
	./rustup-install.sh -y
	rm rustup-install.sh
	export PATH="$CARGO_BIN:$PATH"
	echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.zshrc"
	rustup update
	echo "Rust installed successfully."
else
	echo "Rust is already installed. Updating..."
	rustup update
fi

# Install Go-Swagger.
echo "Installing Go-Swagger..."
if ! command -v swagger &>/dev/null; then
	sudo dnf install -y yum-utils
	sudo rpm --import 'https://dl.cloudsmith.io/public/go-swagger/go-swagger/gpg.2F8CB673971B5C9E.key'
	curl -1sLf 'https://dl.cloudsmith.io/public/go-swagger/go-swagger/config.rpm.txt?distro=fedora&codename=any-version' >/tmp/go-swagger-go-swagger.repo
	sudo dnf config-manager --add-repo '/tmp/go-swagger-go-swagger.repo'
	sudo dnf install -y swagger
	echo "Go-Swagger installed successfully."
else
	echo "Go-Swagger is already installed."
fi

# Install Flutter.
if [ ! -d "$FLUTTER_SDK_DIR" ]; then
	echo "Downloading Flutter SDK..."
	curl -o "$FLUTTER_TAR" -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.0-stable.tar.xz
	mkdir -p "$HOME/development"
	tar -xf "$FLUTTER_TAR" -C "$HOME/development/"
	rm "$FLUTTER_TAR"
	echo "Flutter SDK installed successfully."
else
	echo "Flutter is already installed."
fi

# Add Flutter to PATH.
if ! grep -q 'export PATH="$HOME/development/flutter/bin:$PATH"' "$HOME/.zshrc"; then
	echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >>"$HOME/.zshrc"
	export PATH="$HOME/development/flutter/bin:$PATH"
fi

# Install Android Studio.
echo "Installing Android Studio..."
if ! flatpak list | grep -q "Android Studio"; then
	flatpak install -y flathub com.google.AndroidStudio
else
	echo "Android Studio is already installed."
fi

# Verify Flutter installation.
echo "Running flutter doctor..."
flutter doctor

# Accept Android SDK licenses.
echo "Accepting Android SDK licenses..."
flutter doctor --android-licenses

# Install Starship.
if ! command -v starship &>/dev/null; then
	curl -sS https://starship.rs/install.sh -o starship-install.sh
	chmod +x starship-install.sh
	./starship-install.sh
	rm starship-install.sh
fi

# Ensure Starship is initialized in Zsh.
if ! grep -q 'eval "$(starship init zsh)"' "$HOME/.zshrc"; then
	echo 'eval "$(starship init zsh)"' >>"$HOME/.zshrc"
fi

# Install oxi (Rust-based `sd`).
if ! command -v sd &>/dev/null; then
	cargo install sd
fi

# Install fonts.
sudo dnf install -y font-fira-code-nerd-font || true

# Install GUI applications via Flatpak (without Docker).
echo "Installing GUI applications via Flatpak..."
if ! flatpak install --noninteractive -y wezterm; then
	echo "Error: Flatpak application installation failed."
	exit 1
fi

# Ensure Stow is installed.
if ! command -v stow &>/dev/null; then
	echo "Error: GNU Stow is not installed."
	exit 1
fi

# Stow only if directories exist.
[ -d "$DOTFILES_DIR/zsh" ] && stow zsh
[ -d "$DOTFILES_DIR/nvim" ] && stow nvim
[ -d "$DOTFILES_DIR/tmux" ] && stow tmux
[ -d "$DOTFILES_DIR/starship" ] && stow starship
[ -d "$DOTFILES_DIR/wezterm" ] && stow wezterm

# Set Zsh as default shell.
sudo chsh -s "$(which zsh)" "$USER"

echo "========== Installation Completed: $(date) =========="

# Prompt user to restart the system.
echo "Installation is complete! Restart your system for all changes to take effect."
read -rp "Would you like to restart now? (y/N): " RESTART_CONFIRM
if [[ "$RESTART_CONFIRM" == "y" || "$RESTART_CONFIRM" == "Y" ]]; then
	echo "Restarting system..."
	sudo reboot
else
	echo "Restart skipped. Please restart your system manually later."
fi

exit 0
