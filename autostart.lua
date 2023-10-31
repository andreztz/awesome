local executer = require("modules/executer")

local function setup()
	-- Autostart
	executer.execute_commands({
		"xcompmgr",
		"volctl",
		"nm-applet",
		"xfce4-clipman",
		"redshift",
	})
end

return {
	setup = setup,
}
