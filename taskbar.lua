local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi

local net_widgets = require("net_widgets")

local function setup(config)
	local screen = config.screen
	local task_bar_position = config.position

	-- Keyboard map indicator and switcher
	local keyboardlayout = awful.widget.keyboardlayout()

	-- Wibar
	-- Create a textclock widget
	local mytextclock = wibox.widget.textclock()

	-- Create System Tray widget
	-- see: https://github.com/awesomeWM/awesome/issues/971
	local systray_widget = wibox.widget.systray()
	systray_widget:set_reverse(true)

	local systray_wrapper = wibox.widget({
		{
			systray_widget,
			left = 10,
			top = 2,
			bottom = 2,
			right = 10,
			widget = wibox.container.margin,
		},
		shape_clip = true,
		widget = wibox.container.background,
	})

	memwidget = wibox.widget.textbox()
	vicious.cache(vicious.widgets.mem)
	vicious.register(memwidget, vicious.widgets.mem, "$1 ($2MiB/$3MiB)", 13)

	-- Create a wibox for each screen and add it
	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)

	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal("request::activate", "tasklist", { raise = true })
			end
		end),
		awful.button({}, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
		end),
		awful.button({}, 4, function()
			awful.client.focus.byidx(1)
		end),
		awful.button({}, 5, function()
			awful.client.focus.byidx(-1)
		end)
	)

	if screen.index == 1 then
		screen.primary = true
	else
		screen.primary = false
	end

	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, screen, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	screen.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	screen.mylayoutbox = awful.widget.layoutbox(s)
	screen.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	screen.mytaglist = awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})
	-- Create a tasklist widget
	screen.mytasklist = awful.widget.tasklist({
		screen = screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- Create the wibox
	screen.mywibox = awful.wibar({
		position = config.position,
		screen = screen,
		opacity = 0.8,
		height = dpi(24),
		position = task_bar_position,
	})

	-- Add widgets to the wibox
	if screen.primary then
		screen.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				menu_launcher,
				screen.mytaglist,
				screen.mypromptbox,
			},
			screen.mytasklist, -- Middle widget
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				-- keyboardlayout,
				systray_wrapper,
				mytextclock,
				screen.mylayoutbox,
			},
		})
	else
		screen.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{
				-- Left widgets
				layout = wibox.layout.fixed.horizontal,
				menu_launcher,
				screen.mytaglist,
				screen.mypromptbox,
			},
			screen.mytasklist, -- Middle widget
			{
				-- Right widgets
				layout = wibox.layout.fixed.horizontal,
				mytextclock,
				screen.mylayoutbox,
			},
		})
	end
end

return {
	setup = setup,
}
