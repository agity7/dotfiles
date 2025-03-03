#!/bin/bash

source "$(dirname "$0")/vars.sh"

ensure_directory_exists() {
	local dir="$1"
	echo "📂 Ensuring the directory $dir exists..."
	mkdir -p "$dir" || {
		echo "$FAILURE Failed to create directory $dir"
		exit 1
	}
}

install_go_swagger() {
	echo "🦫 Installing Go-Swagger..."
	go install "$GO_SWAGGER_URL" || {
		echo "$FAILURE Go-Swagger installation skipped."
		exit 1
	}
	echo "$SUCCESS Go-Swagger installation completed."
}

run_flutter_doctor() {
	echo "🦋 Running Flutter doctor..."
	flutter doctor || {
		echo "$FAILURE Flutter doctor failed. Please check your Flutter installation."
		exit 1
	}
	echo "$SUCCESS Flutter doctor completed successfully. If Android SDK tools are missing, install them from Android Studio."
}

set_zsh_default() {
	echo "⚙️ Setting Zsh as default shell..."
	if ! command -v zsh &>/dev/null; then
		echo "$FAILURE Zsh is not installed. Please install Zsh first."
		exit 1
	fi
	sudo chsh -s "$(which zsh)" "$USER" || {
		echo "$FAILURE Failed to set Zsh as default shell"
		exit 1
	}
	echo "$SUCCESS Zsh is now the default shell."
	if [ "$SHELL" != "$(which zsh)" ]; then
		echo "The current terminal session is still using $SHELL."
		echo "You need to log out from your session and log back in for the change to take effect."
		echo "Then, run this script again."
		exit 1
	fi
	echo "$SUCCESS You are now using Zsh in this terminal session."
}

install_starship() {
	echo "⚙️ Installing Starship..."
	if command -v starship &>/dev/null; then
		echo "Starship is already installed. Skipping installation."
	else
		echo "⚙️ Installing Starship..."
		curl -sS https://starship.rs/install.sh | sh -s -- -y || {
			echo "$FAILURE Starship installation failed."
			exit 1
		}
		echo "$SUCCESS Starship installation completed."
	fi
}

install_wezterm() {
	echo "⚙️ Installing WezTerm via Flatpak..."
	if ! command -v flatpak &>/dev/null; then
		echo "Flatpak is not installed. Installing Flatpak..."
		sudo dnf install -y flatpak || {
			echo "$FAILURE Failed to install Flatpak"
			exit 1
		}
	fi
	echo "⬇️ Installing WezTerm via Flatpak from Flathub..."
	flatpak install -y flathub org.wezfurlong.wezterm || {
		echo "$FAILURE WezTerm installation skipped."
		exit 1
	}
	echo "$SUCCESS WezTerm installation completed via Flatpak."
}

install_docker() {
	echo "🐳 Installing Docker Desktop..."
	if command -v docker &>/dev/null; then
		echo "$SUCCESS Docker is already installed. Skipping installation."
		return
	fi
	echo "🔧 Setting up Docker repository..."
	sudo dnf -y install dnf-plugins-core
	sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	echo "$SUCCESS Docker repository added."
	echo "⬇️ Downloading Docker Desktop..."
	wget -O "$DOCKER_DESKTOP_RPM" "$DOCKER_DESKTOP_RPM_URL"
	echo "📦 Installing Docker Desktop..."
	sudo dnf install -y "$DOCKER_DESKTOP_RPM"
	rm -f "$DOCKER_DESKTOP_RPM"
	systemctl --user disable docker-desktop
	echo "$SUCCESS Docker Desktop installation completed."
}

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
	echo "📦 Installing required packages from dnf-packages.txt..."
	PACKAGE_FILE="$(dirname "$0")/dnf-packages.txt"
	if [ ! -f "$PACKAGE_FILE" ]; then
		echo "$FAILURE Package list file ($PACKAGE_FILE) not found!"
		exit 1
	fi
	while IFS= read -r package || [ -n "$package" ]; do
		echo "⬇️ Installing: $package"
		sudo dnf install -y "$package"
	done <"$PACKAGE_FILE"
	echo "$SUCCESS All packages installed successfully."
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
	echo "📦 Attempting to extract $output..."
	sudo tar -xJf "$output" -C "$dest" && {
		echo "$SUCCESS $output extracted successfully (using .xz)."
		rm "$output"
		return 0
	}
	sudo tar -xzf "$output" -C "$dest" && {
		echo "$SUCCESS $output extracted successfully (using .gz)."
		rm "$output"
		return 0
	}
	echo "$FAILURE Failed to extract $output"
	exit 1
}

install_dropbox() {
	echo "📦 Installing Dropbox..."
	if command -v dropbox &>/dev/null; then
		echo "$SUCCESS Dropbox is already installed. Skipping installation."
		return
	fi
	wget -O /tmp/nautilus-dropbox.rpm "$DROPBOX_URL"
	sudo dnf install -y /tmp/nautilus-dropbox.rpm
	rm /tmp/nautilus-dropbox.rpm
	dropbox autostart y
	echo "$SUCCESS Dropbox installation completed. Use 'dropbox start' to launch it."
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
	if command -v flutter >/dev/null 2>&1; then
		echo "Flutter is already installed."
	else
		ensure_directory_exists "$DEV_DIR"
		echo "⚙️ Flutter SDK not found, downloading and installing..."
		download_and_extract "$FLUTTER_DOWNLOAD_URL" "$FLUTTER_TAR" "$DEV_DIR"
	fi
	echo "$SUCCESS Flutter installation completed."
}

install_android_studio() {
	echo "🤖 Checking Android Studio installation..."
	if [ -d "$ANDROID_STUDIO_DIR" ] && [ -x "$ANDROID_STUDIO_DIR/bin/studio.sh" ]; then
		echo "$SUCCESS Android Studio is already installed in $ANDROID_STUDIO_DIR. Skipping installation."
		return
	fi
	echo "⬇️ Downloading and installing Android Studio..."
	sudo rm -rf "$ANDROID_STUDIO_DIR"
	download_and_extract "$ANDROID_STUDIO_URL" "$ANDROID_STUDIO_TAR" "/opt"
	EXTRACTED_DIR=$(find /opt -maxdepth 1 -type d -name "android-studio*" | head -n 1)
	if [ -d "$EXTRACTED_DIR" ] && [ "$EXTRACTED_DIR" != "$ANDROID_STUDIO_DIR" ]; then
		echo "🔄 Moving Android Studio to $ANDROID_STUDIO_DIR..."
		sudo mv "$EXTRACTED_DIR" "$ANDROID_STUDIO_DIR"
	fi
	sudo ln -sf "$ANDROID_STUDIO_DIR/bin/studio.sh" /usr/local/bin/studio
	echo "$SUCCESS Android Studio installation completed."
	echo "🚀 Launching Android Studio..."
	"$ANDROID_STUDIO_DIR/bin/studio.sh"
}

fix_amdgpu_on_fedora() {
	echo "🎮 Fixing AMD Radeon GPU (AMDGPU) on Fedora..."
	if grep -q "nomodeset" /etc/default/grub; then
		echo "⚙️ Removing 'nomodeset' to enable AMDGPU..."
		sudo sed -i 's/nomodeset//g' /etc/default/grub
		sudo grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null ||
			sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
	fi
	echo "📦 Installing AMDGPU drivers..."
	sudo dnf install -y \
		mesa-dri-drivers mesa-vulkan-drivers xorg-x11-drv-amdgpu \
		mesa-va-drivers mesa-vdpau-drivers
	echo "$SUCCESS AMDGPU Fix Applied."
}

echo "$SUCCESS Functions loaded from functions.sh"
