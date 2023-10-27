local executer = require("modules/executer")

local function setup()
	-- Autostart
	executer.execute_commands({
		"xcompmgr",
		"flameshot",
		"volctl",
		"nm-applet",
		"xfce4-clipman",
		"redshift",
	})
end

return {
	setup = setup,
}
