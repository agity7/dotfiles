#!/bin/bash

source "$(dirname "$0")/vars.sh"

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
	echo "📦 Installing CLI tools..."
	sudo dnf install -y \
		gnome-tweaks gnome-terminal zsh git fzf bat neovim tmux stow golang zsh-syntax-highlighting \
		zsh-autosuggestions nodejs-npm ripgrep make gcc unzip gzip xz zip \
		wl-clipboard xclip mesa-libGLU libstdc++ bzip2-libs python3 python3-pip \
		python3-virtualenv python3-argcomplete flatpak clang cmake ninja-build gtk3-devel java-17-openjdk \
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
	if [ ! -d "$FLUTTER_SDK_DIR" ]; then
		download_and_extract "$FLUTTER_DOWNLOAD_URL" "$FLUTTER_TAR" "$HOME/development"
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
