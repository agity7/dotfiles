#!/bin/bash

# Ensure we are in the dotfiles directory.
cd ~/.dotfiles || exit

# Check for Homebrew.
if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew.
brew update

# Install desired packages.
brew install zsh \ 
git \
	neovim \
	tmux \
	stow \
	go@1.21 \
	dart \
	commitizen \
	curl \
	git \
	gnu-sed \
	go-swagger \
	iterm2 \
	rectangle \
	font-fira-code-nerd-font \
	docker \
	android-studio

# Install Oh-my-zsh.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone PowerLevel10k.
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Delete the default .zshrc file to allow stow to create the symlink.
rm -rf $HOME/.zshrc

# Stow.
echo "Setting up symlinks with stow..."
stow iterm2
stow zsh
stow nvim
stow tmux
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
