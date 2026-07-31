--  Window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Syntax: hl.window_rule({ match = { prop = "regex" }, effect = value, ... })
-- Named rules take precedence and can be toggled at runtime via hyprctl.
---@diagnostic disable: undefined-global

-- Blueman Manager
hl.window_rule({ match = { class = "^blueman-manager$" }, float = true, center = true, size = { 800, 600 } })

-- Plasma NM
hl.window_rule({ match = { title = "^Networks$" }, float = true, center = true, size = { 650, 480 } })

-- PulseAudio volume control
hl.window_rule({ match = { title = "^Volume Control$" }, float = true, center = true, size = { 720, 480 } })

-- Ark (archiver)
hl.window_rule({ match = { class = "^org%.kde%.ark$" }, float = true, size = { 900, 600 } })

-- Steam
-- Steam popups
hl.window_rule({ match = { class = "^steam$", title = "^Friends List$" }, float = true })
hl.window_rule({ match = { class = "^steam$", title = "^Steam Settings$" }, float = true })
-- Steam Big Picture Mode
hl.window_rule({
    match      = { class = "^steam$", title = "^Steam Big Picture Mode$" },
    fullscreen = true,
    workspace  = "6",
    rounding   = 0,
})

-- Blender
hl.window_rule({ match = { class = "^blender$", title = "^File Browser$" }, float = true, center = true, size = { 1000, 800 } })

-- Thunar rename dialog
hl.window_rule({ match = { class = "^thunar$", title = "^Rename.*$" }, float = true })

-- Dolphin / KDE portal chooser
hl.window_rule({
    match = { class = "^org%.freedesktop%.impl%.portal%.desktop%.kde$", title = "^Choose Application$" },
    float = true,
})

-- Firefox: no blur for performance; Picture-in-Picture pinned overlay
-- hl.window_rule({ match = { class = "^[Ff]irefox$" }, no_blur = true })
hl.window_rule({
    match = { class = "^[Ff]irefox$", title = "^Picture-in-Picture$" },
    float = true,
    pin = true,
    size = { 576, 324 },
    no_shortcuts_inhibit = true,
})

-- PrismLauncher: float dialogs, tile main window
hl.window_rule({
    match = { class = "^org%.prismlauncher%.PrismLauncher$", title = "negative:^Prism Launcher [0-9.]+$" },
    float = true,
    center = true,
    size = { 800, 600 },
})
hl.window_rule({
    match = { class = "^org%.prismlauncher%.PrismLauncher$", title = "^Prism Launcher [0-9.]+$" },
    tile = true,
})
hl.window_rule({
    match = { class = "^org%.prismlauncher%.PrismLauncher$", title = "^Please wait%.%.%..*$" },
    float = true,
    size = { 230, 235 },
})

-- Minecraft (waywall) — named so it can be toggled at runtime
hl.window_rule({
    name = "waywall-rules",
    match = { class = "waywall" },
    fullscreen = true,
    border_size = 0,
    rounding = 0,
    workspace = "6",
})

-- Minecraft (normal instances)
hl.window_rule({
    match = { class = "^Minecraft.*$" },
    workspace = "6 silent",
    fullscreen = true,
    border_size = 0,
    rounding = 0,
})

-- MultiMC
hl.window_rule({
    match = { class = "^org%.multimc%.MultiMC$", title = ".*—.*" },
    float = true,
    center = true,
    size = { 800, 600 },
})
