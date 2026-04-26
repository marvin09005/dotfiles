#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "📥 Recolectando configuraciones actuales..."

# Crear carpetas base
mkdir -p "$DOTFILES_DIR/config" "$DOTFILES_DIR/home" "$DOTFILES_DIR/themes"
mkdir -p "$DOTFILES_DIR/icons" "$DOTFILES_DIR/fonts" "$DOTFILES_DIR/bin"
mkdir -p "$DOTFILES_DIR/wallpapers" "$DOTFILES_DIR/system/sddm"
mkdir -p "$DOTFILES_DIR/system/grub" "$DOTFILES_DIR/system/snapper"

# --- 1. Carpetas en .config ---
configs=("sway" "waybar" "rofi" "kitty" "mako" "swaync" "swaylock" "swayidle" "nwg-look" "fastfetch" "yazi" "zsh" "Kvantum" "qt5ct" "qt6ct" "nvim")
for conf in "${configs[@]}"; do
    [ -d "$CONFIG_DIR/$conf" ] && cp -rf "$CONFIG_DIR/$conf" "$DOTFILES_DIR/config/"
done

# --- 2. Archivos sueltos, Scripts y Wallpapers ---
[ -f "$CONFIG_DIR/colors.css" ] && cp -f "$CONFIG_DIR/colors.css" "$DOTFILES_DIR/config/"
[ -d "$HOME/.local/bin" ] && cp -rf "$HOME/.local/bin/"* "$DOTFILES_DIR/bin/" 2>/dev/null
[ -d "$HOME/Imágenes/Wallpapers" ] && cp -rf "$HOME/Imágenes/Wallpapers/"* "$DOTFILES_DIR/wallpapers/" 2>/dev/null

# --- 3. Home files ---
home_files=(".zshrc" ".bashrc" ".gitconfig" ".Xresources" ".gtkrc-2.0")
for file in "${home_files[@]}"; do
    [ -f "$HOME/$file" ] && cp -f "$HOME/$file" "$DOTFILES_DIR/home/"
done

# --- 4. Temas, Iconos y Fuentes (Locales) ---
echo "Respaldando Temas, Iconos y Fuentes..."
[ -d "$HOME/.local/share/themes" ] && cp -rf "$HOME/.local/share/themes/"* "$DOTFILES_DIR/themes/" 2>/dev/null
[ -d "$HOME/.local/share/icons" ] && cp -rf "$HOME/.local/share/icons/"* "$DOTFILES_DIR/icons/" 2>/dev/null
[ -d "$HOME/.local/share/fonts" ] && cp -rf "$HOME/.local/share/fonts/"* "$DOTFILES_DIR/fonts/" 2>/dev/null

# --- 5. SYSTEM: SDDM, GRUB y Snapper ---
echo "Respaldando configuraciones de sistema (SDDM, GRUB, Snapper)..."

# SDDM
[ -f "/etc/sddm.conf" ] && cp -f "/etc/sddm.conf" "$DOTFILES_DIR/system/sddm/"
[ -d "/etc/sddm.conf.d" ] && cp -rf "/etc/sddm.conf.d" "$DOTFILES_DIR/system/sddm/"
# Backup del tema activo de SDDM
SDDM_THEME=$(grep "^Current=" /etc/sddm.conf | cut -d'=' -f2)
[ -n "$SDDM_THEME" ] && [ -d "/usr/share/sddm/themes/$SDDM_THEME" ] && cp -rf "/usr/share/sddm/themes/$SDDM_THEME" "$DOTFILES_DIR/system/sddm/"

# GRUB
[ -f "/etc/default/grub" ] && cp -f "/etc/default/grub" "$DOTFILES_DIR/system/grub/"
GRUB_THEME_PATH=$(grep "^GRUB_THEME=" /etc/default/grub | cut -d'"' -f2)
if [ -n "$GRUB_THEME_PATH" ] && [ -f "$GRUB_THEME_PATH" ]; then
    GRUB_THEME_DIR=$(dirname "$GRUB_THEME_PATH")
    cp -rf "$GRUB_THEME_DIR" "$DOTFILES_DIR/system/grub/"
fi

# Snapper
[ -d "/etc/snapper/configs" ] && cp -rf "/etc/snapper/configs/." "$DOTFILES_DIR/system/snapper/"

# --- 6. Lista de Paquetes ---
echo "Generando lista de paquetes..."
pacman -Qq > "$DOTFILES_DIR/pkg_list.txt"
yay -Qqm > "$DOTFILES_DIR/aur_list.txt"

echo "✨ Proceso terminado en $DOTFILES_DIR"
