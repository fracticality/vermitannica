local mod = get_mod("vermitannica")

return {
    name = mod:localize("vermitannica"),
    description = mod:localize("vermitannica_description"),

    options = {
        widgets = {
            {
                setting_id = "open_vermitannica",
                type = "keybind",
                default_value = {},
                keybind_global = true,
                keybind_trigger = "pressed",
                keybind_type = "function_call",
                function_name = "open_vermitannica"
            },
            {
                setting_id = "open_bestiary",
                type = "keybind",
                default_value = {},
                keybind_global = true,
                keybind_trigger = "pressed",
                keybind_type = "function_call",
                function_name = "open_bestiary"
            }
        },
    },

    custom_gui_textures = {
        textures = {
            "gui/vermitannica/vermitannica_atlas"
        },
        atlases = {
            {
                "materials/vermitannica/vermitannica_atlas",
                "vermitannica_atlas",
                "vermitannica_atlas_masked"
            },
        },
        ui_renderer_injections = {
            {
                "ingame_ui",
                "materials/vermitannica/vermitannica_atlas"
            },
        },
    },

}