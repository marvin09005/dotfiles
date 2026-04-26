#!/bin/bash

# Directorio de destino
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "📥 Recolectando configuraciones actuales..."

# Crear carpetas si no existen
mkdir -p "$DOTFILES_DIR/config"
mkdir -p "$DOTFILES_DIR/home"

# Lista de carpetas en .config para respaldar
configs=(
    "sway"
    "waybar"
    "rofi"
    "kitty"
    "mako"
    "swaync"
    "swaylock"
    "swayidle"
    "nwg-look"
    "fastfetch"
    "yazi"
    "zsh"
)

for conf in "${configs[@]}"; do
    if [ -d "$CONFIG_DIR/$conf" ]; then
        echo "Respaldando carpeta: $conf"
        cp -rf "$CONFIG_DIR/$conf" "$DOTFILES_DIR/config/"
    fi
done

# Archivos específicos
if [ -f "$CONFIG_DIR/colors.css" ]; then
    cp -f "$CONFIG_DIR/colors.css" "$DOTFILES_DIR/config/"
fi

# Archivos del home
home_files=(
    ".zshrc"
    ".bashrc"
    ".gitconfig"
    ".Xresources"
)

for file in "${home_files[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "Respaldando archivo: $file"
        cp -f "$HOME/$file" "$DOTFILES_DIR/home/"
    fi
done

echo "✨ Proceso terminado. Tus archivos están listos en $DOTFILES_DIR"
