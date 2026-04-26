#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles_old_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Iniciando instalación completa de Dotfiles (con paru)..."

# --- 1. Paquetes ---
if ! command -v paru &> /dev/null; then
    echo "Instalando paru (AUR helper)..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
fi

[ -f "$DOTFILES_DIR/pkg_list.txt" ] && sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkg_list.txt"
[ -f "$DOTFILES_DIR/aur_list.txt" ] && paru -S --needed --noconfirm - < "$DOTFILES_DIR/aur_list.txt"

# --- 2. Función de Seguridad ---
deploy_copy() {
    local src=$1 dest=$2
    if [ -e "$dest" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$dest" | sed "s|$HOME/||")"
        mv "$dest" "$BACKUP_DIR/$(echo "$dest" | sed "s|$HOME/||")" 2>/dev/null
    fi
    mkdir -p "$(dirname "$dest")"
    cp -rf "$src" "$dest"
}

echo "📂 Desplegando archivos..."
mkdir -p "$BACKUP_DIR"
for conf in "$DOTFILES_DIR/config/"*; do [ -e "$conf" ] && deploy_copy "$conf" "$CONFIG_DIR/$(basename "$conf")"; done
for file in "$DOTFILES_DIR/home/".*; do 
    [[ "$(basename "$file")" != "." && "$(basename "$file")" != ".." ]] && deploy_copy "$file" "$HOME/$(basename "$file")"
done
[ -d "$DOTFILES_DIR/bin" ] && cp -rf "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"
[ -d "$DOTFILES_DIR/wallpapers" ] && cp -rf "$DOTFILES_DIR/wallpapers/"* "$HOME/Imágenes/Wallpapers/"

# --- 3. Temas, Iconos y Fuentes ---
mkdir -p "$HOME/.local/share/themes" "$HOME/.local/share/icons" "$HOME/.local/share/fonts"
[ -d "$DOTFILES_DIR/themes" ] && cp -rf "$DOTFILES_DIR/themes/"* "$HOME/.local/share/themes/" 2>/dev/null
[ -d "$DOTFILES_DIR/icons" ] && cp -rf "$DOTFILES_DIR/icons/"* "$HOME/.local/share/icons/" 2>/dev/null
[ -d "$DOTFILES_DIR/fonts" ] && cp -rf "$DOTFILES_DIR/fonts/"* "$HOME/.local/share/fonts/" 2>/dev/null
fc-cache -fv

# --- 4. SYSTEM: SDDM, GRUB, Snapper (Requiere sudo) ---
echo "⚙️ Aplicando configuraciones de sistema (SDDM, GRUB, Snapper)..."

# SDDM
if [ -d "$DOTFILES_DIR/system/sddm" ]; then
    sudo cp -f "$DOTFILES_DIR/system/sddm/sddm.conf" /etc/ 2>/dev/null
    [ -d "$DOTFILES_DIR/system/sddm/sddm.conf.d" ] && sudo cp -rf "$DOTFILES_DIR/system/sddm/sddm.conf.d" /etc/
    for theme in "$DOTFILES_DIR/system/sddm/"*; do
        [ -d "$theme" ] && [ "$(basename "$theme")" != "sddm.conf.d" ] && sudo cp -rf "$theme" /usr/share/sddm/themes/
    done
fi

# GRUB
if [ -d "$DOTFILES_DIR/system/grub" ]; then
    sudo cp -f "$DOTFILES_DIR/system/grub/grub" /etc/default/grub 2>/dev/null
    for theme in "$DOTFILES_DIR/system/grub/"*; do
        [ -d "$theme" ] && sudo cp -rf "$theme" /usr/share/grub/themes/ 2>/dev/null
    done
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# Snapper
if [ -d "$DOTFILES_DIR/system/snapper" ]; then
    sudo mkdir -p /etc/snapper/configs
    sudo cp -rf "$DOTFILES_DIR/system/snapper/." /etc/snapper/configs/
fi

echo "✅ ¡Instalación completada! Revisa $BACKUP_DIR para tus archivos originales."
