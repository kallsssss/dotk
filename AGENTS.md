# AGENTS.md

Dotfiles for Hyprland (uwsm-managed), Waybar, GTK, and related tools on Arch Linux. Public GitHub repo — treat everything committed as public.

## Structure

- `config/` — copies of `~/.config/` dirs. This is the shareable mirror, NOT the source of truth. Never edit live configs in `~/.config` to "test" changes; edit here, or copy from live config only when the user asks.
- `install.sh` — the installer. Installs deps, backs up, copies `config/*` to `~/.config`, swaps monitor/interface, chmod +x scripts.
- `README.md` — documents included dirs, deps, install steps.

## Hard rules

- **Never commit personal info.** No `/home/kaarl`, usernames, IPs, MAC addresses, hostnames, DuckDNS domains, or server ports. These get reintroduced when copying live configs — always scan (`rg '/home/kaarl'`, IP/MAC patterns, `custom/server`) before committing.
- `eDP-1` and `1920x1200@60` are placeholders — `install.sh` replaces them at install time. Keep them in the repo.
- Preserve exec bits on `config/waybar/scripts/` and `config/power-menu/`.
- `config/gtk-4.0/gtk.css` / `gtk-dark.css` are symlinks to the installed Nordic-darker theme — keep them as symlinks.

## Testing install.sh

Never run it against the real `~/.config`. Use a sandbox home:

```bash
env -u XDG_CONFIG_HOME HOME=/tmp/opencode/dotk-test/home \
  bash install.sh --skip-deps -y
```

`--skip-deps` avoids system changes; `--monitor`/`--mode` flags test the swap logic.

## Conventions

- Bash script: `set -euo pipefail`, `read -rp` prompts, `[Y/n]` defaults to yes, `-y`/`--yes` non-interactive flag.
- Hyprland config uses the `hl` Lua API (`.lua` files under `config/hypr/`, not `.conf`).
