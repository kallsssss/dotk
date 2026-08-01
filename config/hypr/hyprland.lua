-- Hyprland Config 
-- https://wiki.hypr.land/Configuring/Start/
---@diagnostic disable: undefined-global

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "1920x1200@60",
    position = "0x0",
    scale    = 1,
})


-------------------
---- AUTOSTART ----
-------------------
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("sh -c 'XDG_MENU_PREFIX=arch- kbuildsycoca6'")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start hypridle.service")
    hl.exec_cmd("dunst")
end)

-- Hide Waybar on 6th workspace
require("waybar6").setup()

-- Style
require("general")

-- Window Rules
require("windowRules")

-- Keybinds
require("keybind")
