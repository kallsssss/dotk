--  General
-- https://wiki.hypr.land/Configuring/Basics/Variables/
---@diagnostic disable: undefined-global

hl.config({
    general = {
        layout      = "dwindle",
        border_size = 0,
        gaps_in     = 3,
        gaps_out    = 6,
        col         = {
            -- Nord Colors
            active_border   = 0xffa4d8e8,
            inactive_border = 0xff3b4252,
        },
    },

    decoration = {
        rounding           = 5,
        rounding_power     = 5.0,
        active_opacity     = 1.0,
        inactive_opacity   = 0.90,
        fullscreen_opacity = 1.0,
        blur               = {
            enabled           = true,
            size              = 5,
            passes            = 2,
            noise             = 0,
            brightness        = 0.8,
            ignore_opacity    = true,
            xray              = false,
            new_optimizations = true,
        },

        shadow             = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0xcc1a1e26,
        },
    },

    dwindle = {
        preserve_split = true,
        smart_resizing = true,
    },

    input = {
        kb_layout      = "fi",
        kb_variant     = "",
        follow_mouse   = 1,
        focus_on_close = 0,
    },

    misc = {
        disable_hyprland_logo = true,
        focus_on_activate     = true,
    },

    animations = {
        enabled = true,
    },
})

--  Bezier curves
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

--  Animations
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })

--  Layer rules
-- Waybar: frosted glass blur
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = true })
