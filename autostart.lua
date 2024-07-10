local executer = require("modules/executer")

local function setup()
	-- Autostart
	executer.execute_commands({
		"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
		"redshift-gtk",
		"powerkit",
		"volctl",
		"nm-applet",
		"xcompmgr",
		"/usr/bin/opensnitch-ui",
		"/usr/bin/copyq",
	})
end

return {
	setup = setup,
}
