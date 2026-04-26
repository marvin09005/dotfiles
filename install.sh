#!/bin/bash

# Directorio donde están tus dotfiles (donde se ejecute el script)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "🚀 Iniciando la instalación de configuraciones..."

# Función para copiar de forma segura
deploy_config() {
    local src=$1
    local dest=$2

    echo "Copiando $src -> $dest"
    
    # Crear directorio destino si no existe
    mkdir -p "$(dirname "$dest")"
    
    # Copiar recursivamente
    cp -rf "$src" "$dest"
}

# --- Copiar carpetas de .config ---
# Añade o quita nombres de carpetas según necesites
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
    if [ -d "$DOTFILES_DIR/config/$conf" ]; then
        deploy_config "$DOTFILES_DIR/config/$conf" "$CONFIG_DIR/$conf"
    fi
done

# --- Archivos sueltos en .config ---
if [ -f "$DOTFILES_DIR/config/colors.css" ]; then
    deploy_config "$DOTFILES_DIR/config/colors.css" "$CONFIG_DIR/colors.css"
fi

# --- Archivos en el Home (raíz) ---
home_files=(
    ".zshrc"
    ".bashrc"
    ".gitconfig"
    ".Xresources"
)

for file in "${home_files[@]}"; do
    if [ -f "$DOTFILES_DIR/home/$file" ]; then
        deploy_config "$DOTFILES_DIR/home/$file" "$HOME/$file"
    fi
done

echo "✅ ¡Instalación completada! Todas las configuraciones se han movido a su lugar."
