# Mis Dotfiles 🚀

Repositorio de configuraciones para mi sistema Linux (Sway, Waybar, Rofi, etc.).

## Estructura
- `config/`: Archivos que van dentro de `~/.config/`
- `home/`: Archivos que van directamente en el `$HOME`
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
