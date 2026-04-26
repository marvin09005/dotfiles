# Mis Dotfiles 🚀

Repositorio de configuraciones para mi sistema Linux (Sway, Waybar, Rofi, etc.).

## ⚡ Instalación Rápida (One-liner)

Si quieres instalar todo con un solo comando:

```bash
git clone https://github.com/marvin09005/dotfiles.git ~/dotfiles && cd ~/dotfiles && chmod +x install.sh capture.sh && ./install.sh
```

## Estructura
- `config/`: Archivos que van dentro de `~/.config/`
- `home/`: Archivos que van directamente en el `$HOME`
- `bin/`: Scripts personales en `~/.local/bin/`
- `wallpapers/`: Colección de fondos de pantalla.
- `system/`: Configuraciones de sistema (SDDM, GRUB, Snapper).
- `capture.sh`: Script para actualizar este repositorio con los archivos actuales del sistema.
- `install.sh`: Script para instalar estas configuraciones en un sistema nuevo.

## Cómo usar

### 1. Guardar cambios (Actualizar el repo)
Si haces cambios en tu sistema y quieres guardarlos aquí:
```bash
./capture.sh
```

### 2. Instalar en un sistema nuevo
```bash
git clone <url-de-tu-repo> ~/dotfiles
cd ~/dotfiles
chmod +x install.sh capture.sh
./install.sh
```
