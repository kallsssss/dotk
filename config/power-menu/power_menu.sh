#!/usr/bin/env bash
# ~/.config/power-menu/power_menu.sh
# Nord-themed rofi power menu

# Nord palette
NORD0="#2E3440"
NORD1="#3B4252"
NORD2="#434C5E"
NORD3="#4C566A"
NORD4="#D8DEE9"
NORD6="#ECEFF4"
NORD8="#88C0D0"
NORD11="#BF616A" # red (shutdown/reboot)
NORD14="#A3BE8C" # green (lock)

OPTIONS=" Suspend\n Reboot\n Shutdown\n Logout"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu \
  -i \
  -p "" \
  -theme-str "
    * {
        font: \"JetBrains Mono Nerd Font 12\";
        background-color: transparent;
        text-color:       ${NORD4};
    }
    window {
        background-color: ${NORD0};
        border:           2px;
        border-color:     ${NORD8};
        border-radius:    8px;
        width:            220px;
        height:           220px;
        padding:          8px;
        location:         center;
    }
    mainbox {
        background-color: transparent;
        children:         [listview];
        spacing:          0;
    }
    listview {
        background-color: transparent;
        lines:            5;
        columns:          1;
        spacing:          4px;
        padding:          4px;
        scrollbar:        false;
    }
    element {
        background-color: transparent;
        text-color:       ${NORD4};
        padding:          8px 14px;
        border-radius:    5px;
        orientation:      horizontal;
        spacing:          10px;
    }
    element selected {
        background-color: ${NORD1};
        text-color:       ${NORD6};
    }
    element-text {
        background-color: transparent;
        text-color:       inherit;
        expand:           true;
    }
    " \
  -no-custom \
  -kb-cancel Escape \
  2>/dev/null)

case "$CHOICE" in
*Suspend)
  hyprctl dispatch 'hl.dsp.exit()'
  sleep 0.5
  systemctl suspend
  ;;
*Reboot) systemctl reboot ;;
*Shutdown) systemctl poweroff ;;
*Logout) hyprctl dispatch 'hl.dsp.exit()' ;;
esac

