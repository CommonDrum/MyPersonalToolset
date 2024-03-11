#!/bin/bash

if ! command -v cargo &> /dev/null
then
    echo "Cargo not found, installing Rust and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    source "$HOME/.cargo/env"
else
    echo "Cargo is already installed."
fi

echo "Installing zoxide..."
cargo install zoxide

echo "Installing starship..."
cargo install starship

SHELL_NAME=$(basename "$SHELL")

if [ "$SHELL_NAME" = "zsh" ]; then
    echo 'Adding starship init to .zshrc...'
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
elif [ "$SHELL_NAME" = "bash" ]; then
    echo 'Adding starship init to .bashrc...'
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
else
    echo "Unsupported shell. Manual configuration required."
fi

echo "Installing FiraCode Nerd Font..."
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
curl -L $FONT_URL -o "$FONT_DIR/FiraCode.zip"
unzip "$FONT_DIR/FiraCode.zip" -d "$FONT_DIR"
fc-cache -fv
rm "$FONT_DIR/FiraCode.zip"

echo "Installing Alacritty..."
cargo install alacritty

ALACRITTY_CONFIG_URL="https://raw.githubusercontent.com/CommonDrum/MyPersonalToolset/main/alacritty.yml" 
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
mkdir -p "$ALACRITTY_CONFIG_DIR"
curl -L $ALACRITTY_CONFIG_URL -o "$ALACRITTY_CONFIG_DIR/alacritty.yml"