#!/bin/bash
source "$(dirname "$0")/vars.sh"
log() {
	printf '[%s] %s\n' "$1" "$2"
}
info() {
	log "INFO" "$1"
}
ok() {
	log "OK" "$1"
}
warn() {
	log "WARN" "$1"
}
die() {
	log "FAIL" "$1"
	exit 1
}
dnf_update_system() {
	info "Updating Fedora system"
	local args=()
	local ex
	info "DNF update excludes: ${DNF_UPDATE_EXCLUDES[*]}"
	if [ "${#DNF_UPDATE_EXCLUDES[@]}" -gt 0 ]; then
		for ex in "${DNF_UPDATE_EXCLUDES[@]}"; do
			[ -n "$ex" ] && args+=("--exclude=$ex")
		done
	fi
	sudo dnf update -y "${args[@]}" || die "Fedora update failed"
	ok "Fedora update completed"
}
ensure_directory_exists() {
	local dir="$1"
	[ -n "$dir" ] || die "Missing directory path"
	info "Ensuring directory exists: $dir"
	mkdir -p "$dir" || die "Failed to create directory: $dir"
}
cleanup_dotfile_conflicts() {
	local f
	for f in .zshrc .zprofile .zlogin .zlogout; do
		if [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
			info "Removing unmanaged dotfile: $f"
			rm -f "$HOME/$f" || die "Failed to remove dotfile: $f"
		fi
	done
}
install_go() {
	info "Installing Go $GO_VERSION to $DEV_DIR/go"
	ensure_directory_exists "$DEV_DIR"
	curl -LO "https://go.dev/dl/$GO_TARBALL" || die "Failed to download Go archive: $GO_TARBALL"
	rm -rf "$DEV_DIR/go" "$DEV_DIR/go-$GO_VERSION"
	tar -C "$DEV_DIR" -xzf "$GO_TARBALL" || die "Failed to extract Go archive: $GO_TARBALL"
	mv "$DEV_DIR/go" "$DEV_DIR/go-$GO_VERSION" || die "Failed to move Go directory"
	ln -sfn "$DEV_DIR/go-$GO_VERSION" "$DEV_DIR/go" || die "Failed to link Go directory"
	rm "$GO_TARBALL"
	"$DEV_DIR/go/bin/go" env -w GOTOOLCHAIN=auto
	"$DEV_DIR/go/bin/go" env -w GOPROXY=direct
	export PATH="$DEV_DIR/go/bin:$PATH"
	ok "Go $GO_VERSION installed"
}
install_go_swagger() {
	info "Installing Go Swagger"
	GOSUMDB=off go install "$GO_SWAGGER_URL" || die "Go Swagger installation failed"
	ok "Go Swagger installed"
}
run_flutter_doctor() {
	info "Running Flutter doctor"
	flutter doctor || die "Flutter doctor failed"
	ok "Flutter doctor completed"
}
set_zsh_default() {
	info "Setting Zsh as default shell"
	command -v zsh &>/dev/null || die "Zsh is not installed"
	sudo chsh -s "$(which zsh)" "$USER" || die "Failed to set Zsh as default shell"
	ok "Zsh is now the default shell"
	if [ "$SHELL" != "$(which zsh)" ]; then
		warn "Current terminal session is still using $SHELL"
		warn "Log out and log back in, then run this script again"
		exit 1
	fi
	ok "Current terminal session is using Zsh"
}
install_starship() {
	info "Installing Starship"
	if command -v starship &>/dev/null; then
		ok "Starship already installed"
		return
	fi
	curl -sS https://starship.rs/install.sh | sh -s -- -y || die "Starship installation failed"
	ok "Starship installed"
}
install_wezterm() {
	info "Installing WezTerm"
	if ! command -v flatpak &>/dev/null; then
		info "Installing Flatpak"
		sudo dnf install -y flatpak || die "Failed to install Flatpak"
	fi
	flatpak install -y flathub org.wezfurlong.wezterm || die "WezTerm installation failed"
	ok "WezTerm installed"
}
install_docker() {
	info "Installing Docker Desktop"
	if command -v docker &>/dev/null; then
		ok "Docker already installed"
		return
	fi
	info "Setting up Docker repository"
	sudo dnf -y install dnf-plugins-core || die "Failed to install DNF plugins core"
	sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || die "Failed to add Docker repository"
	info "Downloading Docker Desktop"
	ensure_directory_exists "$(dirname "$DOCKER_DESKTOP_RPM")"
	wget -O "$DOCKER_DESKTOP_RPM" "$DOCKER_DESKTOP_RPM_URL" || die "Failed to download Docker Desktop"
	info "Installing Docker Desktop"
	sudo dnf install -y "$DOCKER_DESKTOP_RPM" || die "Failed to install Docker Desktop"
	rm -f "$DOCKER_DESKTOP_RPM"
	systemctl --user disable docker-desktop || true
	ok "Docker Desktop installed"
}
install_librewolf() {
	info "Installing LibreWolf"
	if command -v librewolf &>/dev/null; then
		ok "LibreWolf already installed"
		return
	fi
	curl -fsSL "$LIBREWOLF_REPO_URL" | sudo tee "$LIBREWOLF_REPO_PATH" >/dev/null || die "Failed to add LibreWolf repository"
	sudo dnf install -y librewolf || die "Failed to install LibreWolf"
	ok "LibreWolf installed"
}
install_dnf_packages() {
	info "Installing DNF packages"
	local file
	local pkg
	file="$(dirname "$0")/dnf-packages.txt"
	[ -f "$file" ] || die "Package list not found: $file"
	while IFS= read -r pkg || [ -n "$pkg" ]; do
		[ -z "$pkg" ] && continue
		info "Installing package: $pkg"
		sudo dnf install -y "$pkg" || die "Failed to install package: $pkg"
	done <"$file"
	ok "DNF packages installed"
}
check_internet() {
	info "Checking internet connectivity"
	ping -c 3 8.8.8.8 &>/dev/null || die "No internet connection"
	ok "Internet connection verified"
}
download_and_extract() {
	local url="$1"
	local output="$2"
	local dest="$3"
	[ -n "$dest" ] || die "Missing destination directory"
	ensure_directory_exists "$dest"
	info "Downloading archive: $output"
	wget -O "$output" "$url" || die "Failed to download archive: $output"
	info "Extracting archive: $output"
	sudo tar -xJf "$output" -C "$dest" && {
		rm "$output"
		ok "Archive extracted with xz: $output"
		return 0
	}
	sudo tar -xzf "$output" -C "$dest" && {
		rm "$output"
		ok "Archive extracted with gzip: $output"
		return 0
	}
	die "Failed to extract archive: $output"
}
install_dropbox() {
	info "Installing Dropbox"
	if command -v dropbox &>/dev/null; then
		ok "Dropbox already installed"
		return
	fi
	wget -O /tmp/nautilus-dropbox.rpm "$DROPBOX_URL" || die "Failed to download Dropbox"
	sudo dnf install -y /tmp/nautilus-dropbox.rpm || die "Failed to install Dropbox"
	rm /tmp/nautilus-dropbox.rpm
	dropbox autostart y || true
	ok "Dropbox installed"
}
setup_dotfiles() {
	info "Setting up dotfiles"
	[ -d "$DOTFILES_DIR" ] || die "Dotfiles directory not found: $DOTFILES_DIR"
	cleanup_dotfile_conflicts
	if command -v stow &>/dev/null; then
		for dir in zsh nvim tmux starship wezterm aider; do
			[ -d "$DOTFILES_DIR/$dir" ] && stow -d "$DOTFILES_DIR" -t "$HOME" "$dir"
		done
	fi
	ok "Dotfiles setup completed"
}
install_rust() {
	info "Installing Rust"
	if ! command -v rustup &>/dev/null; then
		curl --proto '=https' --tlsv1.2 -sSf "$RUST_INSTALL_URL" | sh -s -- -y || die "Rust installation failed"
		source "$HOME/.cargo/env"
	else
		rustup self update || die "Rust update failed"
	fi
	ok "Rust installed"
}
install_sd() {
	info "Installing sd"
	if command -v sd &>/dev/null; then
		ok "sd already installed"
		return
	fi
	cargo install sd || die "Failed to install sd"
	ok "sd installed"
}
install_pipx_commitizen() {
	info "Installing pipx and Commitizen"
	if ! command -v pipx &>/dev/null; then
		python3 -m pip install --user pipx || die "Failed to install pipx"
		python3 -m pipx ensurepath || true
	fi
	pipx install commitizen || warn "Commitizen installation skipped"
	ok "pipx and Commitizen setup completed"
}
setup_flatpak() {
	info "Setting up Flatpak"
	if ! flatpak remote-list | grep -q flathub; then
		sudo flatpak remote-add --if-not-exists flathub "$FLATPAK_REPO_URL" || die "Failed to add Flathub remote"
	fi
	ok "Flatpak setup completed"
}
install_font() {
	info "Installing Fira Code Nerd Font Mono"
	ensure_directory_exists "$FONT_DIR"
	(
		cd "$FONT_DIR" || die "Failed to cd to font directory: $FONT_DIR"
		wget -O FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" || die "Failed to download Fira Code Nerd Font"
		unzip -o FiraCode.zip || die "Failed to unzip Fira Code Nerd Font"
		rm FiraCode.zip
		fc-cache -fv || die "Failed to refresh font cache"
	)
	ok "Font installed"
}
install_flutter() {
	info "Installing Flutter SDK"
	if command -v flutter >/dev/null 2>&1; then
		ok "Flutter already installed"
		return
	fi
	ensure_directory_exists "$DEV_DIR"
	download_and_extract "$FLUTTER_DOWNLOAD_URL" "$FLUTTER_TAR" "$DEV_DIR"
	ok "Flutter installed"
}
install_android_studio() {
	info "Installing Android Studio"
	if [ -d "$ANDROID_STUDIO_DIR" ] && [ -x "$ANDROID_STUDIO_DIR/bin/studio.sh" ]; then
		ok "Android Studio already installed"
		return
	fi
	sudo rm -rf "$ANDROID_STUDIO_DIR"
	download_and_extract "$ANDROID_STUDIO_URL" "$ANDROID_STUDIO_TAR" "/opt"
	local dir
	dir=$(find /opt -maxdepth 1 -type d -name "android-studio*" | head -n 1)
	if [ -d "$dir" ] && [ "$dir" != "$ANDROID_STUDIO_DIR" ]; then
		sudo mv "$dir" "$ANDROID_STUDIO_DIR" || die "Failed to move Android Studio directory"
	fi
	sudo ln -sf "$ANDROID_STUDIO_DIR/bin/studio.sh" /usr/local/bin/studio || die "Failed to link Android Studio binary"
	ok "Android Studio installed"
	"$ANDROID_STUDIO_DIR/bin/studio.sh"
}
fix_amdgpu_on_fedora() {
	info "Applying AMDGPU Fedora fix"
	if grep -q "nomodeset" /etc/default/grub; then
		info "Removing nomodeset from GRUB"
		sudo sed -i 's/nomodeset//g' /etc/default/grub
		sudo grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null ||
			sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg ||
			die "Failed to regenerate GRUB config"
	fi
	sudo dnf install -y \
		mesa-dri-drivers mesa-vulkan-drivers xorg-x11-drv-amdgpu \
		mesa-va-drivers mesa-vdpau-drivers || die "Failed to install AMDGPU packages"
	ok "AMDGPU Fedora fix applied"
}
install_uv() {
	info "Installing uv"
	if command -v uv &>/dev/null; then
		ok "uv already installed"
		return
	fi
	if sudo dnf install -y uv; then
		ok "uv installed with dnf"
		return
	fi
	python3 -m pip install --user uv || die "Failed to install uv"
	ok "uv installed with pip"
}
install_aider() {
	info "Installing Aider"
	install_uv
	uv python install 3.12 || die "Failed to install Python 3.12 with uv"
	uv tool install --force --python 3.12 --with pip "$AIDER_PKG" || die "Aider installation failed"
	uv tool update-shell || true
	if ! command -v aider &>/dev/null && [ ! -x "$AIDER_BIN" ]; then
		die "Aider was installed but is not available in PATH. Add $HOME/.local/bin to PATH or restart your shell"
	fi
	ok "Aider installed"
}
install_aider_convention_scraper() {
	info "Installing aider-convention-scraper"
	ensure_directory_exists "$(dirname "$AIDER_CONVENTION_SCRAPER")"
	curl -fsSL "$AIDER_CONVENTION_SCRAPER_URL" -o "$AIDER_CONVENTION_SCRAPER" || die "Failed to download aider-convention-scraper"
	chmod +x "$AIDER_CONVENTION_SCRAPER" || die "Failed to chmod aider-convention-scraper"
	ok "aider-convention-scraper installed"
}
setup_aider_env() {
	info "Setting up Aider env"
	if [ ! -f "$AIDER_ENV" ]; then
		cat >"$AIDER_ENV" <<'EOF'
AIDER_OPENAI_API_KEY=""
OPENAI_API_KEY=""
EOF
		chmod 600 "$AIDER_ENV"
		ok "Aider env file created at $AIDER_ENV"
		info "Add your OpenAI API key to $AIDER_ENV"
		return
	fi
	chmod 600 "$AIDER_ENV"
	ok "Aider env file already exists"
}
sync_aider_conventions() {
	info "Syncing Aider conventions"
	ensure_directory_exists "$AIDER_DIR"
	curl -fsSL "$AIDER_CONVENTIONS_URL" -o "$AIDER_CONVENTIONS" || die "Failed to sync Aider conventions"
	ok "Aider conventions synced"
}
ok "Functions loaded from functions.sh"
