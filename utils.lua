local awful = require("awful")

local function file_exists(path)
	local f = io.open(path, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

-- -- add the key bindings in the clientkeys = gears.table.join( ... ) section:
-- -- Snap to edge/corner - Use arrow keys
-- awful.key({ modkey, "Shift" }, "Down",  function (c) snap_edge(c, 'bottom') end),
-- awful.key({ modkey, "Shift" }, "Left",  function (c) snap_edge(c, 'left') end),
-- awful.key({ modkey, "Shift" }, "Right", function (c) snap_edge(c, 'right') end),
-- awful.key({ modkey, "Shift" }, "Up",    function (c) snap_edge(c, 'top') end),
-- -- numpad key codes 1-9
-- local numpad_map = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
-- -- Snap to edge/corner - Use numpad
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[1], function (c) snap_edge(c, 'bottomleft') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[2], function (c) snap_edge(c, 'bottom') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[3], function (c) snap_edge(c, 'bottomright') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[4], function (c) snap_edge(c, 'left') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[5], function (c) snap_edge(c, 'center') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[6], function (c) snap_edge(c, 'right') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[7], function (c) snap_edge(c, 'topleft') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[8], function (c) snap_edge(c, 'top') end),
-- awful.key({ modkey, "Shift" }, "#" .. numpad_map[9], function (c) snap_edge(c, 'topright') end),

--- Positions a window at the edges or corners of the screen.
-- @tparam client c The client to be repositioned.
-- @string where The position where the window will be anchored ("right", "left", "bottom", "top", "topright", "topleft", "bottomright", "bottomleft", "center").
-- @tparam[opt] table geom The custom geometry for the window (optional).
local function snap_edge(c, where, geom)
	local sg = screen[c.screen].geometry --screen geometry
	local sw = screen[c.screen].workarea --screen workarea
	local workarea = {
		x_min = sw.x,
		x_max = sw.x + sw.width,
		y_min = sw.y,
		y_max = sw.y + sw.height,
	}
	local cg = geom or c:geometry()
	local border = c.border_width
	local cs = c:struts()
	cs["left"] = 0
	cs["top"] = 0
	cs["bottom"] = 0
	cs["right"] = 0
	if where ~= nil then
		c:struts(cs) -- cancel struts when snapping to edge
	end
	if where == "right" then
		cg.width = sw.width / 2 - 2 * border
		-- WARNING: Adjustment of -5 in sw.height to prevent client overflow.
		-- If the taskbar is at the "top", the client spills below the screen.
		-- If the taskbar is at the "bottom", the client overlaps with the taskbar.
		cg.height = sw.height - 5
		cg.x = workarea.x_max - cg.width
		cg.y = workarea.y_min
	elseif where == "left" then
		cg.width = sw.width / 2 - 2 * border
		-- WARNING: Adjustment of -5 in sw.height to prevent client overflow.
		-- If the taskbar is at the "top", the client spills below the screen.
		-- If the taskbar is at the "bottom", the client overlaps with the taskbar.
		cg.height = sw.height - 5
		cg.x = workarea.x_min
		cg.y = workarea.y_min
	elseif where == "bottom" then
		cg.width = sw.width
		cg.height = sw.height / 2 - 2 * border
		cg.x = workarea.x_min
		cg.y = workarea.y_max - cg.height
		awful.placement.center_horizontal(c)
	elseif where == "top" then
		cg.width = sw.width
		cg.height = sw.height / 2 - 2 * border
		cg.x = workarea.x_min
		cg.y = workarea.y_min
		awful.placement.center_horizontal(c)
	elseif where == "topright" then
		cg.width = sw.width / 2 - 2 * border
		cg.height = sw.height / 2 - 2 * border
		cg.x = workarea.x_max - cg.width
		cg.y = workarea.y_min
	elseif where == "topleft" then
		cg.width = sw.width / 2 - 2 * border
		cg.height = sw.height / 2 - 2 * border
		cg.x = workarea.x_min
		cg.y = workarea.y_min
	elseif where == "bottomright" then
		cg.width = sw.width / 2 - 2 * border
		cg.height = sw.height / 2 - 2 * border
		cg.x = workarea.x_max - cg.width
		cg.y = workarea.y_max - cg.height
	elseif where == "bottomleft" then
		cg.width = sw.width / 2 - 2 * border
		cg.height = sw.height / 2 - 2 * border
		cg.x = workarea.x_min
		cg.y = workarea.y_max - cg.height
	elseif where == "center" then
		awful.placement.centered(c)
		return
	elseif where == nil then
		c:struts(cs)
		c:geometry(cg)
		return
	end
	c.floating = true
	if c.maximized then
		c.maximized = false
	end
	c:geometry(cg)
	awful.placement.no_offscreen(c)
end

local function set_wallpaper(s, wallpaper_path)
	local beautiful = require("beautiful")
	local gears = require("gears")

	if file_exists(wallpaper_path) then
		gears.wallpaper.maximized(wallpaper_path, s, true)
	else
		if beautiful.wallpaper then
			local wallpaper = beautiful.wallpaper
			-- If wallpaper is a function, call it with the screen
			if type(wallpaper) == "function" then
				wallpaper = wallpaper(s)
			end
			gears.wallpaper.maximized(wallpaper, s, true)
		end
	end
end

return { snap_edge = snap_edge, set_wallpaper = set_wallpaper }
