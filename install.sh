#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "🚀 Iniciando instalación completa de Dotfiles..."

# --- 1. Instalación de Paquetes ---
echo "📦 Instalando dependencias del sistema..."

# Instalar yay si no existe
if ! command -v yay &> /dev/null; then
    echo "Instalando yay (AUR helper)..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
fi

# Instalar paquetes de pacman
if [ -f "$DOTFILES_DIR/pkg_list.txt" ]; then
    echo "Instalando paquetes de los repositorios oficiales..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkg_list.txt"
fi

# Instalar paquetes de AUR
if [ -f "$DOTFILES_DIR/aur_list.txt" ]; then
    echo "Instalando paquetes de AUR..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/aur_list.txt"
fi

# --- 2. Despliegue de Configuraciones ---
echo "📂 Desplegando archivos de configuración..."

deploy_copy() {
    mkdir -p "$(dirname "$2")"
    cp -rf "$1" "$2"
}

# Carpetas en .config
for conf in "$DOTFILES_DIR/config/"*; do
    [ -e "$conf" ] && deploy_copy "$conf" "$CONFIG_DIR/$(basename "$conf")"
done

# Archivos en Home
for file in "$DOTFILES_DIR/home/".*; do
    [ -e "$file" ] && deploy_copy "$file" "$HOME/$(basename "$file")"
done

# --- 3. Temas, Iconos y Fuentes ---
echo "🎨 Instalando Temas, Iconos y Fuentes..."
mkdir -p "$HOME/.local/share/themes" "$HOME/.local/share/icons" "$HOME/.local/share/fonts"

[ -d "$DOTFILES_DIR/themes" ] && cp -rf "$DOTFILES_DIR/themes/"* "$HOME/.local/share/themes/" 2>/dev/null
[ -d "$DOTFILES_DIR/icons" ] && cp -rf "$DOTFILES_DIR/icons/"* "$HOME/.local/share/icons/" 2>/dev/null
[ -d "$DOTFILES_DIR/fonts" ] && cp -rf "$DOTFILES_DIR/fonts/"* "$HOME/.local/share/fonts/" 2>/dev/null

# Refrescar caché de fuentes
fc-cache -fv

echo "✅ ¡Instalación completada! Reinicia tu sesión para ver todos los cambios."
