#!/bin/bash

# Define variables.
DOTFILES_DIR="$HOME/dotfiles"
CARGO_BIN="$HOME/.cargo/bin"

# Ensure we are in the dotfiles directory.
if [ ! -d "$DOTFILES_DIR" ]; then
	echo "Error: $DOTFILES_DIR does not exist. Please clone or create it first."
	exit 1
fi

cd "$DOTFILES_DIR" || {
	echo "Error: Failed to enter $DOTFILES_DIR. Exiting."
	exit 1
}

# Ask for sudo password once and keep it cached.
echo "Caching sudo password..."
sudo -v
while true; do
	sudo -v
	sleep 60
done &

# Update DNF.
echo "Updating DNF packages..."
sudo dnf update -y || true

# Install CLI tools.
echo "Installing CLI tools..."
sudo dnf install -y zsh \
	git \
	neovim \
	tmux \
	stow \
	go \
	dart \
	commitizen \
	curl \
	gnu-sed \
	go-swagger \
	zsh-syntax-highlighting \
	zsh-autosuggestions \
	node \
	ripgrep \
	make \
	gcc \
	flatpak || true

# Ensure Flatpak is set up.
if ! command -v flatpak &>/dev/null; then
	echo "Flatpak installation failed. Exiting..."
	exit 1
else
	echo "Flatpak is installed."
fi

# Enable Flathub if not already enabled.
if ! flatpak remote-list | grep -q flathub; then
	echo "Adding Flathub repository to Flatpak..."
	sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	echo "Flathub enabled successfully."
fi

# Ensure Git is configured.
if ! git config --global user.name &>/dev/null || ! git config --global user.email &>/dev/null; then
	echo "Git user configuration missing. Setting up defaults..."
	read -rp "Enter your Git username: " GIT_USER
	read -rp "Enter your Git email: " GIT_EMAIL
	git config --global user.name "$GIT_USER"
	git config --global user.email "$GIT_EMAIL"
	echo "Git global config set successfully."
else
	echo "Git user configuration already set."
fi

# Install Rust properly using rustup (not dnf).
if ! command -v rustup &>/dev/null; then
	echo "Rust is not installed. Do you want to install Rust using rustup? (y/N)"
	read -r INSTALL_RUST
	if [[ "$INSTALL_RUST" == "y" || "$INSTALL_RUST" == "Y" ]]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-install.sh
		echo "Please review rustup-install.sh before executing."
		read -rp "Press Enter to proceed with installation..."
		sh rustup-install.sh -y
		rm rustup-install.sh
		export PATH="$CARGO_BIN:$PATH"
		echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>"$HOME/.zshrc"
		rustup update
		echo "Rust installed successfully via rustup."
	else
		echo "Skipping Rust installation."
	fi
else
	echo "Rust is already installed. Updating..."
	rustup update
fi

# Install Starship using official script (with security confirmation).
if ! command -v starship &>/dev/null; then
	echo "Starship is not installed. Do you want to install it? (y/N)"
	read -r INSTALL_STARSHIP
	if [[ "$INSTALL_STARSHIP" == "y" || "$INSTALL_STARSHIP" == "Y" ]]; then
		curl -sS https://starship.rs/install.sh -o starship-install.sh
		echo "Please review starship-install.sh before executing."
		read -rp "Press Enter to proceed with installation..."
		sh starship-install.sh
		rm starship-install.sh
		echo "Starship installed successfully."
	else
		echo "Skipping Starship installation."
	fi
else
	echo "Starship is already installed."
fi

# Ensure Starship is initialized in Zsh.
if ! grep -q 'eval "$(starship init zsh)"' "$HOME/.zshrc"; then
	echo 'eval "$(starship init zsh)"' >>"$HOME/.zshrc"
	echo "Added Starship initialization to .zshrc."
fi

# Install oxi (Rust-based `sd`).
if ! command -v sd &>/dev/null; then
	echo "Installing oxi (Rust-based sd)..."
	cargo install sd
	echo "oxi (Rust-based sd) installed successfully."
else
	echo "oxi (Rust-based sd) is already installed."
fi

# Install fonts.
echo "Installing Fira Code Nerd Font..."
sudo dnf install -y font-fira-code-nerd-font || true

# Install GUI applications via Flatpak (now guaranteed to be installed).
echo "Installing GUI applications via Flatpak..."
flatpak install --noninteractive -y wezterm \
	flutter \
	docker \
	android-studio || true

# Create a backup of any current zsh configuration file, if it exists.
if [ -f "$HOME/.zshrc" ]; then
	cp "$HOME/.zshrc" "$HOME/.zshrc_bak"
	echo "Backup of .zshrc created as .zshrc_bak."
else
	echo "No existing .zshrc file to back up."
fi

# Stow only if directories exist.
echo "Setting up symlinks with stow..."
[ -d "$DOTFILES_DIR/zsh" ] && stow zsh
[ -d "$DOTFILES_DIR/nvim" ] && stow nvim
[ -d "$DOTFILES_DIR/tmux" ] && stow tmux
[ -d "$DOTFILES_DIR/starship" ] && stow starship
[ -d "$DOTFILES_DIR/wezterm" ] && stow wezterm
echo "...Done"

# Use zsh as default shell.
echo "Setting zsh as default shell..."
sudo chsh -s "$(which zsh)" "$USER"
echo "...Done"

# Exit successfully.
exit 0
