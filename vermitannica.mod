return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Vermitannica must be lower than Vermintide Mod Framework in your launcher's load order.")

        new_mod("vermitannica", {
            mod_script       = "scripts/mods/vermitannica/vermitannica",
            mod_data         = "scripts/mods/vermitannica/vermitannica_data",
            mod_localization = "scripts/mods/vermitannica/vermitannica_localization"
        })
	end,
	packages = {
        "resource_packages/vermitannica/vermitannica"
	}
}
