local executer = require("executer")

local function setup()
    -- Autostart
    executer.execute_commands({
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
        "/usr/bin/greenclip daemon",
        "redshift-gtk",
        "powerkit",
        "volctl",
        "nm-applet",
        "picom",
        "/usr/bin/opensnitch-ui",
        "/usr/bin/tailscale-systray",
    })
end

return {
    setup = setup,
}
