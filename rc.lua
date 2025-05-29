-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


local set_wallpaper = require("utils").set_wallpaper
-- local _log = require("gears.debug")
-- Exemplo de uso do sistema de log
-- _log.print_error("Exibe uma mensagem de erro!")
-- _log.print_warning("Exibe mensagem de aviso!")
-- Exibe uma tabela
-- _log.dump({
--     nome = "Test",
--     sobrenome = 1
-- })
-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        })
        in_error = false
    end)
end

awful.util.shell = "bash"

HOME = os.getenv("HOME")
beautiful.init(HOME .. "/.config/awesome/themes/" .. "ztz/theme.lua")
terminal = "kitty"
editor = "nvim" or os.getenv("EDITOR")
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

WALLPAPER = HOME .. "/Pictures/wallpapers/wallpaper.jpeg"

beautiful.notification_icon_size = 16

local layouts = require("layouts")
layouts.setup()

local menu = require("menu")
menu.setup()

local bindings = require("bindings")
bindings.setup()

local rules = require("rules")
rules.setup({ titlebars = false })

local signals = require("signals")
signals.setup()

local autostart = require("autostart")
autostart.setup()

local taskbar = require("taskbar")
-- WARNING: To ensure run taskbar.setup starts correctly,
-- run it inside the awful.screen.connect_for_each_screen function

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s, WALLPAPER)
    taskbar.setup({ position = "bottom", screen = s })
end)

screen.connect_signal("property::geometry", function(s)
    set_wallpaper(s, WALLPAPER)
end)
