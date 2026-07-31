--- Waybar Autohide on workspace 6 / X
---@diagnostic disable: undefined-global
local M = {}

local WAYBAR_WORKSPACE = "6"
local waybar_visible = true

local function set_waybar_visible(visible)
    if visible == waybar_visible then
        return
    end

    hl.exec_cmd("pkill -SIGUSR1 waybar")
    waybar_visible = visible
end

function M.setup()
    hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")

        local ws = hl.get_active_workspace()
        local active = ws and tostring(ws.name) or ""

        waybar_visible = active ~= WAYBAR_WORKSPACE

        if not waybar_visible then
            hl.exec_cmd("pkill -SIGUSR1 waybar")
        end
    end)

    hl.on("workspace.active", function(ws)
        local active = ws and tostring(ws.name) or ""
        set_waybar_visible(active ~= WAYBAR_WORKSPACE)
    end)
end

return M

