local awful = require("awful")
local beautiful = require("beautiful")

-- Rules
local function setup(config)
    local titlebars = config.titlebars or false
    -- Rules to apply to new clients (through the "manage" signal).
    awful.rules.rules = {
        -- All clients will match this rule.
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                titlebars_enabled = titlebars,
                placement = awful.placement.no_overlap
                    + awful.placement.no_offscreen,
            },
        },
        -- Add titlebars to dialogs
        {
            rule_any = { type = { "dialog" } },
            properties = { titlebars_enabled = true },
        },

        -- Floating clients.
        {
            rule_any = {
                instance = {
                    "DTA", -- Firefox addon DownThemAll.
                    "copyq", -- Includes session name in class.
                    "pinentry",
                },
                class = {
                    "Arandr",
                    "Blueman-manager",
                    "Gpick",
                    "Kruler",
                    "MessageWin", -- kalarm.
                    "Sxiv",
                    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                    "Wpa_gui",
                    "veromix",
                    "xtightvncviewer",
                },

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester", -- xev.
                },
                role = {
                    "AlarmWindow", -- Thunderbird's calendar.
                    "ConfigManager", -- Thunderbird's about:config.
                    "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                },
            },
            properties = { floating = true },
        },
        {
            rule = { class = "terminology" },
            properties = {
                maximized = true,
                size_hints_honor = false,
            },
        },
        {
            rule = { class = "tgui" },
            properties = {
                titlebars_enabled = true,
            },
        },
    }
end

return {
    setup = setup,
}
