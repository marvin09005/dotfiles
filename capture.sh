#!/bin/bash

# Directorio de destino
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "📥 Recolectando configuraciones actuales..."

# Crear carpetas base
mkdir -p "$DOTFILES_DIR/config"
mkdir -p "$DOTFILES_DIR/home"
mkdir -p "$DOTFILES_DIR/themes"
mkdir -p "$DOTFILES_DIR/icons"
mkdir -p "$DOTFILES_DIR/fonts"

# --- 1. Carpetas en .config ---
configs=(
    "sway" "waybar" "rofi" "kitty" "mako" "swaync" "swaylock" 
    "swayidle" "nwg-look" "fastfetch" "yazi" "zsh" "Kvantum" 
    "qt5ct" "qt6ct"
)

for conf in "${configs[@]}"; do
    if [ -d "$CONFIG_DIR/$conf" ]; then
        echo "Respaldando carpeta config: $conf"
        cp -rf "$CONFIG_DIR/$conf" "$DOTFILES_DIR/config/"
    fi
done

# --- 2. Archivos sueltos ---
[ -f "$CONFIG_DIR/colors.css" ] && cp -f "$CONFIG_DIR/colors.css" "$DOTFILES_DIR/config/"

# --- 3. Home files ---
home_files=(".zshrc" ".bashrc" ".gitconfig" ".Xresources" ".gtkrc-2.0")
for file in "${home_files[@]}"; do
    if [ -f "$HOME/$file" ]; then
        echo "Respaldando archivo home: $file"
        cp -f "$HOME/$file" "$DOTFILES_DIR/home/"
    fi
done

# --- 4. Temas, Iconos y Fuentes ---
echo "Respaldando Temas, Iconos y Fuentes..."
[ -d "$HOME/.local/share/themes" ] && cp -rf "$HOME/.local/share/themes/"* "$DOTFILES_DIR/themes/" 2>/dev/null
[ -d "$HOME/.local/share/icons" ] && cp -rf "$HOME/.local/share/icons/"* "$DOTFILES_DIR/icons/" 2>/dev/null
[ -d "$HOME/.local/share/fonts" ] && cp -rf "$HOME/.local/share/fonts/"* "$DOTFILES_DIR/fonts/" 2>/dev/null

# --- 5. Lista de Paquetes ---
echo "Generando lista de paquetes instalados..."
pacman -Qq > "$DOTFILES_DIR/pkg_list.txt"
yay -Qqm > "$DOTFILES_DIR/aur_list.txt"

echo "✨ Proceso terminado. Todo está respaldado en $DOTFILES_DIR"
