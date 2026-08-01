--  Keybinds
--  wiki: https://wiki.hypr.land/Configuring/Basics/Binds/
---@diagnostic disable: undefined-global

local Ss = "SUPER"

--  Programs
local home =        os.getenv("HOME")
local terminal =    "alacritty"
local fastfetch =   "alacritty --class fastfetch -e fish -c 'fastfetch; exec fish'"
local fileManager = "thunar"
local menu =        "rofi -show drun"
local browser =     "firefox"
local nm =          "plasmawindowed org.kde.plasma.networkmanagement"
local screen =      'grim -g "$(slurp)" - | swappy -f - -o ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png'
local audio =       "pavucontrol"
local bluetooth =   "blueman-manager"

--  Launch
hl.bind(Ss .. " + RETURN", hl.dsp.exec_cmd(fastfetch))
hl.bind(
    Ss .. " + SHIFT + RETURN",
    hl.dsp.exec_cmd(terminal, { float = true, move = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" } })
)
hl.bind(Ss .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind("ALT    + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(Ss .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(Ss .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(Ss .. " + V", hl.dsp.exec_cmd(audio))
hl.bind(Ss .. " + N", hl.dsp.exec_cmd(nm))
hl.bind(Ss .. " + SHIFT + N", hl.dsp.exec_cmd(bluetooth))
hl.bind(Ss .. " + Y", hl.dsp.exec_cmd(screen))

--  Window management
hl.bind(Ss .. " + Q", hl.dsp.window.close())
hl.bind(Ss .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(Ss .. " + F", hl.dsp.window.fullscreen())
hl.bind(Ss .. " + C", hl.dsp.window.pseudo())
hl.bind(Ss .. " + J", hl.dsp.layout("togglesplit"))

--  Move focused window (SUPER+SHIFT+arrow)
hl.bind(Ss .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(Ss .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(Ss .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(Ss .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

--  Focus (SUPER+arrow)
hl.bind(Ss .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(Ss .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(Ss .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(Ss .. " + down", hl.dsp.focus({ direction = "d" }))

--  Workspaces
for i = 1, 5 do
    hl.bind(Ss .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(Ss .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(Ss .. " + X", hl.dsp.focus({ workspace = 6 })) --empty workspace
hl.bind(Ss .. " + SHIFT + X", hl.dsp.window.move({ workspace = 6 }))

-- Trackpad
-- 3-finger workspace swipe
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
    scale     = 4
})
-- 3-finger swipe up = fullscreen
hl.gesture({
    fingers = 3,
    direction = "up",
    action = "fullscreen",
})
hl.gesture({
    fingers = 3,
    direction = "down",
    action = "float"
})

--  Mouse window control
hl.bind(Ss .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(Ss .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind(Ss .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
--  System
-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true })

-- Media playback
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("swayosd-client --playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("swayosd-client --playerctl previous"))

-- Suspend
hl.bind(Ss .. " + 0", function()
    hl.exec_cmd("loginctl lock-session")
    hl.timer(function()
        hl.exec_cmd("systemctl suspend")
    end, { timeout = 500, type = "oneshot" })
end)
-- Lock session
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))
-- power-menu
hl.bind(Ss .. " + M", hl.dsp.exec_cmd(home .. "/.config/power-menu/power_menu.sh"))
-- Power Profiles
hl.bind("SUPER + P", function()
    local current = io.popen("powerprofilesctl get"):read("*l")

    if current == "power-saver" then
        os.execute("powerprofilesctl set balanced")
    elseif current == "balanced" then
        os.execute("powerprofilesctl set performance")
    else
        os.execute("powerprofilesctl set power-saver")
    end
end)

-- Reload Waybar
hl.bind(Ss .. " + SHIFT + K", hl.dsp.exec_cmd("pkill waybar && waybar &"))
hl.bind(Ss .. " + k", hl.dsp.exec_cmd("waybar &"))
