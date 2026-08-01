# dotk — dotfiles

Personal configuration files for Hyprland (uwsm-managed), Waybar, GTK, and related tools on Arch Linux.

## What's included

| Directory | Description |
|-----------|-------------|
| `hypr/` | Hyprland WM config (Lua DSL) — general, keybinds, window rules, hyprlock, hypridle, hyprpaper |
| `waybar/` | Status bar — Nord theme, steam widget |
| `uwsm/` | Universal Wayland Session Manager env vars |
| `power-menu/` | Nord-themed rofi power menu (suspend / reboot / shutdown / logout) |
| `fastfetch/` | System info display with custom ASCII art |
| `ohmyposh/` | Shell prompt theme (Nord) |
| `wallpapers/` | Wallpaper collection |
| `gtk-3.0/` & `gtk-4.0/` | GTK theme (Nordic-darker), Tela-circle-nord icons |
| `qt5ct/` & `qt6ct/` | Qt theme (Kvantum, same Nord palette) |
| `dunst/` | Notification daemon |
| `rofi/` | Application launcher |
| `alacritty/` | Terminal emulator |
| `fish/` | Shell config (sources Oh My Posh) |
| `btop/` | System monitor with Nord theme |
| `swayosd/` | On-screen display (volume/brightness) |

## Dependencies

- **WM**: Hyprland, uwsm
- **Bar**: waybar (with mpris support)
- **Theming**: Nordic-darker GTK theme, Tela-circle-nord icon theme, Kvantum
- **Fonts**: FiraCode Nerd Font, JetBrainsMono Nerd Font, RecMonoLinear Nerd Font
- **Shell**: fish, oh-my-posh
- **Utils**: fastfetch, dunst, rofi, alacritty, btop, swayosd, hyprlock, hypridle, hyprpaper, playerctl, pulseaudio (pipewire), blueman
- **Other**: power-profiles-daemon, swayosd, networkmanager

## Installation

```bash
# Clone the repo
git clone https://github.com/kallsssss/dotk.git ~/dotk

# Backup any existing config files
# Then copy dotk/config/* into ~/.config/
cp dotk/config/* ~/.config/
```

Or manually for individual configs:

```bash
cp ~/dotk/config/hypr ~/.config/hypr
cp ~/dotk/config/waybar ~/.config/waybar
# ... etc for each directory in config/
```

## Notes

- Hyprland config uses the `hl` Lua API (not plain `.conf`)
- Monitor is `eDP-1` at 1920×1200, keyboard layout `fi`
- `gtk-4.0/gtk.css` and `gtk-dark.css` are symlinks to the installed Nordic-darker theme
