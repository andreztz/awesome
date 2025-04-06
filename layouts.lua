local awful = require("awful")

local function setup()
    -- Tabela de layouts, para cobrir com `awful.layout.inc`, a ordem importa.
    local layouts = {
        awful.layout.suit.floating,
        awful.layout.suit.tile,
        awful.layout.suit.tile.left,
        awful.layout.suit.tile.bottom,
        awful.layout.suit.tile.top,
        awful.layout.suit.fair,
        awful.layout.suit.fair.horizontal,
        awful.layout.suit.spiral,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.max,
        awful.layout.suit.max.fullscreen,
        awful.layout.suit.magnifier,
        awful.layout.suit.corner.nw,
        awful.layout.suit.corner.ne,
        awful.layout.suit.corner.sw,
        awful.layout.suit.corner.se,
    }
    local success = pcall(function() 
        awful.layout.append_default_layouts(layouts)
    end)

    if not success then
        awful.layout.layouts = layouts
    end
end

return {
    setup = setup,
}
