#!/usr/bin/env bash
set -euo pipefail

C_RESET='\033[0m'; C_BOLD='\033[1m'; C_CYAN='\033[36m'; C_GREEN='\033[32m'; C_YELLOW='\033[33m'; C_RED='\033[31m'
info() { printf "${C_CYAN}::${C_RESET} %s\n" "$*"; }
ok()   { printf "${C_GREEN}  ok${C_RESET} %s\n" "$*"; }
warn() { printf "${C_YELLOW}  !${C_RESET} %s\n" "$*"; }
die()  { printf "${C_RED}error:${C_RESET} %s\n" "$*" >&2; exit 1; }

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}"

ASSUME_YES=0
SKIP_DEPS=0
NO_BACKUP=0
MONITOR=""
MODE=""

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Installs the dotk dotfiles into $DEST.

Options:
  -y, --yes          Assume yes for all prompts
  --skip-deps        Skip system dependency installation
  --no-backup        Overwrite existing configs without backing them up
  --monitor NAME     Use NAME as the monitor instead of auto-detecting (e.g. HDMI-A-1)
  --mode WxH@R       Use resolution instead of auto-detecting (e.g. 2560x1440@144)
  -h, --help         Show this help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes) ASSUME_YES=1 ;;
        --skip-deps) SKIP_DEPS=1 ;;
        --no-backup) NO_BACKUP=1 ;;
        --monitor) MONITOR="${2:?--monitor requires an argument}"; shift ;;
        --mode) MODE="${2:?--mode requires an argument}"; shift ;;
        -h|--help) usage; exit 0 ;;
        *) die "unknown option: $1" ;;
    esac
    shift
done

confirm() {
    [[ $ASSUME_YES -eq 1 ]] && return 0
    local ans
    read -rp "$1 [Y/n] " ans
    case "$ans" in ""|y|Y|yes|YES) return 0 ;; *) return 1 ;; esac
}

install_deps() {
    local pm=""
    command -v pacman >/dev/null 2>&1 && pm="pacman"
    if [[ -z "$pm" ]]; then
        warn "no pacman found — skipping dependency installation"
        warn "install the packages listed in the README manually"
        return 0
    fi

    local pacman_deps=(
        hyprland uwsm waybar hyprlock hypridle hyprpaper
        xdg-desktop-portal-hyprland hyprpolkitagent
        dunst rofi alacritty fish oh-my-posh fastfetch btop swayosd
        playerctl grim slurp swappy pavucontrol
        pipewire pipewire-pulse wireplumber blueman
        networkmanager power-profiles-daemon
        qt5ct qt6ct kvantum thunar firefox
        kservice plasma-workspace plasma-nm
        ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
    )
    local aur_deps=(nordic-theme tela-circle-icon-theme ttf-recursive-nerd)
    local aur=""

    command -v paru >/dev/null 2>&1 && aur="paru"
    command -v yay >/dev/null 2>&1 && aur="${aur:-yay}"

    info "installing packages (sudo required)"
    sudo -v
    sudo pacman -S --needed --noconfirm "${pacman_deps[@]}"

    if [[ -n "$aur" ]]; then
        if confirm "Install AUR theming packages ($aur: ${aur_deps[*]})?"; then
            "$aur" -S --needed --noconfirm "${aur_deps[@]}"
        fi
    else
        warn "no AUR helper found (paru/yay) — skip theming: ${aur_deps[*]}"
    fi
}

detect_monitor() {
    MONITOR=""
    MODE=""
    local out info

    if command -v hyprctl >/dev/null 2>&1 && out="$(hyprctl monitors -j 2>/dev/null || true)" && [[ -n "$out" ]]; then
        if info="$(printf '%s' "$out" | python3 -c '
import json, sys
try:
    mons = json.load(sys.stdin)
except Exception:
    sys.exit(1)
if not mons:
    sys.exit(1)
m = next((x for x in mons if x.get("focused")), mons[0])
r = int(round(m.get("refreshRate") or 0))
if r > 0:
    print("%s %dx%d@%d" % (m["name"], m["width"], m["height"], r))
else:
    print("%s %dx%d" % (m["name"], m["width"], m["height"]))
' 2>/dev/null || true)" && [[ -n "$info" ]]; then
            MONITOR="${info%% *}"
            MODE="${info#* }"
            return 0
        fi
    fi

    if command -v wlr-randr >/dev/null 2>&1 && out="$(wlr-randr 2>/dev/null || true)" && [[ -n "$out" ]]; then
        MONITOR="$(awk '/\(connected\)/ {print $1; exit}' <<<"$out" || true)"
        MODE="$(grep -oE '[0-9]+x[0-9]+@[0-9]+' <<<"$out" | head -1 || true)"
        [[ -n "$MONITOR" ]] && return 0
    fi

    return 1
}

preflight() {
    local bad=0
    info "preflight checks"
    for f in hypr/hyprland.lua hypr/hyprlock.conf hypr/hyprpaper.conf \
             hypr/keybind.lua hypr/general.lua waybar/config.jsonc \
             waybar/style.css power-menu/power_menu.sh; do
        if [[ -f "$SRC/$f" ]]; then
            ok "found $f"
        else
            warn "missing $f"
            bad=1
        fi
    done
    return "$bad"
}

install_configs() {
    mkdir -p "$DEST"

    if [[ $NO_BACKUP -eq 0 ]]; then
        local conflicts=() name
        for d in "$SRC"/*; do
            [[ -d "$d" ]] || continue
            name="$(basename "$d")"
            [[ -e "$DEST/$name" ]] && conflicts+=("$name")
        done

        if [[ ${#conflicts[@]} -gt 0 ]]; then
            if confirm "Back up existing configs (${conflicts[*]}) to *.bak first?"; then
                local ts
                ts="$(date +%Y%m%d-%H%M%S)"
                for name in "${conflicts[@]}"; do
                    mv "$DEST/$name" "$DEST/$name.bak-$ts"
                    ok "backed up $DEST/$name -> $name.bak-$ts"
                done
            else
                warn "overwriting existing configs without backup"
            fi
        fi
    fi

    cp -a "$SRC"/. "$DEST"/
    ok "copied configs to $DEST"
}

apply_monitor() {
    local mon="$1" mode="$2"

    if [[ -n "$mon" && "$mon" != "eDP-1" ]]; then
        if grep -q 'eDP-1' "$DEST/hypr/hyprlock.conf" "$DEST/hypr/hyprpaper.conf" 2>/dev/null; then
            sed -i "s/eDP-1/$mon/g" "$DEST/hypr/hyprlock.conf" "$DEST/hypr/hyprpaper.conf"
            ok "monitor: replaced eDP-1 with $mon in hyprlock/hyprpaper"
        else
            ok "monitor: eDP-1 not present, nothing to replace"
        fi
    fi

    if [[ -n "$mode" && "$mode" != "1920x1200@60" ]]; then
        sed -i "s/1920x1200@60/$mode/g" "$DEST/hypr/hyprland.lua"
        ok "resolution: set $mode in hyprland.lua"
    fi
}

apply_interface() {
    local iface
    iface="$(ip -o route get 1.1.1.1 2>/dev/null || true)"
    iface="$(sed -n 's/.*dev \([^ ]*\).*/\1/p' <<<"$iface")"
    [[ -n "$iface" ]] || return 0

    if [[ "$iface" != "wlan0" ]] && grep -q '"interface" *: *"wlan0"' "$DEST/waybar/config.jsonc" 2>/dev/null; then
        if confirm "Replace wifi interface wlan0 with $iface in waybar?"; then
            sed -i "s/\"interface\" *: *\"wlan0\"/\"interface\":    \"$iface\"/" "$DEST/waybar/config.jsonc"
            ok "interface: waybar now uses $iface"
        fi
    fi
}

make_executable() {
    find "$DEST" \( -path '*/waybar/scripts/*' -o -path '*/power-menu/*' -o -name '*.sh' \) -type f -exec chmod +x {} + 2>/dev/null || true
    chmod +x "$SRC"/waybar/scripts/* "$SRC"/power-menu/* 2>/dev/null || true
    ok "scripts made executable"
}

postcheck() {
    info "post-install checks"
    if [[ -x "$DEST/power-menu/power_menu.sh" ]]; then ok "power_menu.sh executable"; else warn "power_menu.sh not executable"; fi
    if [[ -x "$DEST/waybar/scripts/steam_widget" ]]; then ok "steam_widget executable"; else warn "steam_widget not executable"; fi
    if [[ -n "$MONITOR" && "$MONITOR" != "eDP-1" ]]; then
        grep -q 'eDP-1' "$DEST/hypr/hyprlock.conf" 2>/dev/null && warn "eDP-1 still present in hyprlock.conf" || ok "no eDP-1 references left"
    else
        ok "monitor unchanged (eDP-1)"
    fi
}

main() {
    [[ -d "$SRC" ]] || die "config/ not found next to install.sh — run it from the repo"
    [[ "$(basename "$REPO_DIR")" == "dotk" ]] || warn "repo directory is not named 'dotk' — continuing anyway"

    info "dotk installer"
    info "source: $SRC"
    info "target: $DEST"

    if ! preflight; then
        confirm "Some configs are missing. Continue anyway?" || die "aborted"
    fi

    if [[ $SKIP_DEPS -eq 0 ]]; then
        if confirm "Install system dependencies (requires sudo)?"; then
            install_deps
        else
            warn "skipping dependency installation"
        fi
    fi

    install_configs

    if [[ -z "$MONITOR" ]]; then
        if detect_monitor; then
            info "detected monitor: $MONITOR @ $MODE"
            if [[ "$MONITOR" == "eDP-1" ]]; then
                MONITOR=""
                MODE=""
            elif ! confirm "Replace eDP-1 with $MONITOR in configs?"; then
                MONITOR=""
                MODE=""
            fi
        else
            warn "could not detect a monitor"
            if confirm "Enter your monitor name manually?"; then
                local m
                read -rp "  monitor name (e.g. HDMI-A-1, DP-1) [eDP-1]: " m
                MONITOR="${m:-eDP-1}"
            fi
            if [[ -z "$MODE" ]] && confirm "Enter your resolution manually (or keep 1920x1200@60)?"; then
                local r
                read -rp "  resolution as WxH@R (e.g. 2560x1440@144): " r
                MODE="$r"
            fi
        fi
    fi

    apply_monitor "$MONITOR" "$MODE"
    apply_interface
    make_executable
    postcheck

    info "done. Changes take effect after logging out and back in."
    info "Run 'fc-cache -f' if fonts were just installed."
}

main
