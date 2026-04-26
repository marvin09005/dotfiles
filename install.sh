#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles_old_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Iniciando instalación completa de Dotfiles..."

# --- 1. Instalación de Paquetes ---
echo "📦 Instalando dependencias del sistema..."

if ! command -v yay &> /dev/null; then
    echo "Instalando yay (AUR helper)..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
fi

[ -f "$DOTFILES_DIR/pkg_list.txt" ] && sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkg_list.txt"
[ -f "$DOTFILES_DIR/aur_list.txt" ] && yay -S --needed --noconfirm - < "$DOTFILES_DIR/aur_list.txt"

# --- 2. Función de Seguridad (Backup) ---
deploy_copy() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ]; then
        echo "Respaldo: moviendo $dest a $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR/$(dirname "$dest" | sed "s|$HOME/||")"
        mv "$dest" "$BACKUP_DIR/$(echo "$dest" | sed "s|$HOME/||")"
    fi

    mkdir -p "$(dirname "$dest")"
    cp -rf "$src" "$dest"
}

echo "📂 Desplegando archivos de configuración (con respaldo en $BACKUP_DIR)..."
mkdir -p "$BACKUP_DIR"

# Carpetas en .config
for conf in "$DOTFILES_DIR/config/"*; do
    [ -e "$conf" ] && deploy_copy "$conf" "$CONFIG_DIR/$(basename "$conf")"
done

# Archivos en Home
for file in "$DOTFILES_DIR/home/".*; do
    if [[ "$(basename "$file")" != "." && "$(basename "$file")" != ".." ]]; then
        deploy_copy "$file" "$HOME/$(basename "$file")"
    fi
done

# Scripts personales
if [ -d "$DOTFILES_DIR/bin" ]; then
    echo "Sincronizando scripts en ~/.local/bin..."
    mkdir -p "$HOME/.local/bin"
    cp -rf "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"
fi

# Wallpapers
if [ -d "$DOTFILES_DIR/wallpapers" ]; then
    echo "Instalando Wallpapers..."
    mkdir -p "$HOME/Imágenes/Wallpapers"
    cp -rf "$DOTFILES_DIR/wallpapers/"* "$HOME/Imágenes/Wallpapers/"
fi

# --- 3. Temas, Iconos y Fuentes ---
echo "🎨 Instalando Temas, Iconos y Fuentes..."
mkdir -p "$HOME/.local/share/themes" "$HOME/.local/share/icons" "$HOME/.local/share/fonts"

[ -d "$DOTFILES_DIR/themes" ] && cp -rf "$DOTFILES_DIR/themes/"* "$HOME/.local/share/themes/" 2>/dev/null
[ -d "$DOTFILES_DIR/icons" ] && cp -rf "$DOTFILES_DIR/icons/"* "$HOME/.local/share/icons/" 2>/dev/null
[ -d "$DOTFILES_DIR/fonts" ] && cp -rf "$DOTFILES_DIR/fonts/"* "$HOME/.local/share/fonts/" 2>/dev/null

fc-cache -fv

echo "✅ ¡Instalación completada! Los archivos originales se guardaron en $BACKUP_DIR"
