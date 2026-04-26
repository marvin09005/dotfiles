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

## 🛠️ Instalación manual y dependencias

### Dependencias principales
Para que todas las configuraciones funcionen correctamente, asegúrate de tener instalados los siguientes programas (el script de instalación intentará instalarlos automáticamente si usas Arch Linux):

- **Window Manager:** `swayfx` o `sway`
- **Barra:** `waybar`
- **Lanzador:** `rofi` (o `rofi-lbonn-wayland-git`)
- **Terminal:** `kitty`
- **Notificaciones:** `mako` y `swaync`
- **Explorador:** `yazi`
- **AUR Helper:** `paru`
- **Otros:** `fastfetch`, `neovim`, `sddm`, `grub`.

### Pasos manuales
Si prefieres no usar el comando rápido, sigue estos pasos:

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/marvin09005/dotfiles.git ~/dotfiles
   ```
2. **Entrar al directorio:**
   ```bash
   cd ~/dotfiles
   ```
3. **Dar permisos de ejecución:**
   ```bash
   chmod +x install.sh capture.sh
   ```
4. **Ejecutar el instalador:**
   ```bash
   ./install.sh
   ```

---
*Nota: Para actualizar el repositorio con tus cambios locales actuales, ejecuta `./capture.sh` antes de hacer un commit.*
