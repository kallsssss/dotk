# dotk — dotfiles

Personal configuration files for Hyprland (uwsm-managed), Waybar, GTK, and related tools on Arch Linux.

## What's included

| Directory | Description |
|-----------|-------------|
| `hypr/` | Hyprland WM config (Lua DSL), hyprlock, hypridle, hyprpaper |
| `waybar/` | Status bar — Nord theme, cava visualizer, steam widget |
| `uwsm/` | Universal Wayland Session Manager env vars |
| `fastfetch/` | System info display with custom ASCII art |
| `ohmyposh/` | Shell prompt theme (Nord) |
| `wallpapers/` | Wallpaper collection |
| `gtk-3.0/` & `gtk-4.0/` | GTK theme (Nordic-darker), Tela-circle-nord icons |
| `qt5ct/` & `qt6ct/` | Qt theme (Kvantum, same Nord palette) |
| `dunst/` | Notification daemon |
| `rofi/` | Application launcher |
| `alacritty/` | Terminal emulator |
| `fish/` | Shell config (sources Oh My Posh) |
| `fontconfig/` | Font rendering tweaks |
| `btop/` | System monitor + themes |
| `swayosd/` | On-screen display (volume/brightness) |
| `cava/` | Audio visualizer |
| `fuzzel/` | Application launcher (alternative) |

## Dependencies

- **WM**: Hyprland, uwsm
- **Bar**: waybar (with libcava, mpris support)
- **Theming**: Nordic-darker GTK theme, Tela-circle-nord icon theme, Kvantum
- **Fonts**: FiraCode Nerd Font, JetBrainsMono Nerd Font, RecMonoLinear Nerd Font
- **Shell**: fish, oh-my-posh
- **Utils**: fastfetch, dunst, rofi, alacritty, btop, swayosd, cava, fuzzel, hyprlock, hypridle, hyprpaper, playerctl, pulseaudio (pipewire), blueman
- **Other**: power-profiles-daemon, swayosd, networkmanager

## Installation

```bash
# Clone the repo
git clone https://github.com/kallsssss/dotk.git

# Stow or symlink each config directory
# Example for stow (recommended):
cd ~/dotk
stow -t ~ .
```

Or manually for individual configs:

```bash
ln -sf ~/dotk/.config/hypr ~/.config/hypr
ln -sf ~/dotk/.config/waybar ~/.config/waybar
# ... etc for each directory in .config/
```


## Notes

- Monitor is `eDP-1` at 1920×1200, keyboard layout `fi`
