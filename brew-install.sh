#!/bin/bash

# Ensure we are in the dotfiles directory.
cd ~/.dotfiles || exit

# Check for Homebrew.
if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew.
brew update

# Install CLI tools.
brew install zsh \
	git \
	neovim \
	tmux \
	stow \
	go@1.23 \
	dart \
	commitizen \
	curl \
	gnu-sed \
	go-swagger \
	zsh-syntax-highlighting \
	zsh-autosuggestions \
	starship \
	node \
	ripgrep \
	rust

# Install oxi (Rust-based `sd`).
if ! command -v sd &>/dev/null; then
	echo "Installing oxi (Rust-based sd)..."
	cargo install sd
	echo "oxi (Rust-based sd) installed successfully."
else
	echo "oxi (Rust-based sd) is already installed."
fi

# Install fonts.
brew install font-fira-code-nerd-font

# Install GUI applications.
brew install --cask wezterm \
	flutter \
	rectangle \
	docker \
	android-studio

# Create a backup of any current zsh configuration file, if it exists.
if [ -f "$HOME/.zshrc" ]; then
	cp "$HOME/.zshrc" "$HOME/.zshrc_bak"
	echo "Backup of .zshrc created as .zshrc_bak."
else
	echo "No existing .zshrc file to back up."
fi

# Stow.
echo "Setting up symlinks with stow..."
stow zsh
stow nvim
stow tmux
stow starship
stow wezterm
echo "...Done"

# Add zsh to valid login shells.
echo "Adding zsh to valid login shells..."
if ! grep -Fxq "$(command -v zsh)" /etc/shells; then
	command -v zsh | sudo tee -a /etc/shells
fi
echo "...Done"

# Use zsh as default shell.
echo "Setting zsh as default shell..."
sudo chsh -s "$(which zsh)" "$USER"
echo "...Done"

# Exit successfully.
exit 0
