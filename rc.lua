-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local vicious = require("vicious")
local executer = require("modules/executer")

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

-- Variable definitions
HOME = os.getenv("HOME")
-- Themes define colours, icons, font and wallpapers.
beautiful.init(HOME .. "/.config/awesome/themes/" .. "ztz/theme.lua")
-- This is used later as the default terminal and editor to run.
terminal = "terminology"
editor = "nvim" or os.getenv("EDITOR")
editor_cmd = terminal .. " -e " .. editor
awful.screen.set_auto_dpi_enabled(true)
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

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
	-- Wallpaper
	set_wallpaper(s)
	taskbar.setup({ position = "top", screen = s })
	-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
	screen.connect_signal("property::geometry", set_wallpaper)
end)
