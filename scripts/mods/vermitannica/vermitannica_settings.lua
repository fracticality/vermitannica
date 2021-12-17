local mod = get_mod("vermitannica")

local breed_textures = UISettings.breed_textures
if not breed_textures.skaven_explosive_loot_rat then
    breed_textures.skaven_explosive_loot_rat = UISettings.breed_textures.skaven_clan_rat
end

VermitannicaSettings = {
    view_settings = {
        view_name = "vermitannica_view",
        view_open_transition = "open_vermitannica_view",
        view_close_transition = "close_vermitannica_view",
    },
    textures = {
        breed_textures = breed_textures,
        race_modifier_icons = {
            skaven = "icon_property_power_skaven",
            chaos = "icon_property_power_chaos",
            beastmen = "icon_property_power_chaos"
        },
        armor_category_modifier_icons = {
            "icon_property_power_unarmoured",
            "icon_property_power_armoured",
            "icon_property_power_large",
            "icons_placeholder",
            "icon_property_power_frenzy",
            "icon_property_power_armoured"
        },
        attribute_icons = {
            mass = "tabs_icon_inventory",
            max_health = "icon_property_health_increase",
            stagger_resist = "killfeed_icon_12",
            breed_type = "reinforcement_kill"
        },
        mass_modifier_icons = {
            tank = "flanged_mace",
            linesman = "saber_slash",
            heavy_linesman = "blade_drag"
        }
    },
    armor_categories = {
        "armor_category_unarmoured",
        "armor_category_armoured",
        "armor_category_monster",
        "armor_category_player",
        "armor_category_frenzied",
        "armor_category_heavily_armoured"
    },
    breed_types = {
        lord = "type_lord",
        boss = "type_boss",
        special = "type_special",
        elite = "type_elite",
        infantry = "type_infantry"
    },
    menu_scenegraphs = {
        screen = {
            scale = "fit",
            size = { 1920, 1080 },
            position = { 0, 0, UILayer.default + 1 }
        },
        area_root = {
            parent = "screen",
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { 1820, 840 },
            position = { 50, -120, 1 }
        },
        area_left = {
            parent = "area_root",
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { 300, 700 },
            position = { 80, -95, 1 }
        },
        area_left_large = {
            parent = "area_root",
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { 920, 700 },
            position = { 80, -95, 1 }
        },

        area_middle = {
            parent = "area_root",
            vertical_alignment = "top",
            horizontal_alignment = "center",
            size = { 550, 700 },
            position = { 0, -95, 1 }
        },
        area_middle_large = {
            parent = "area_root",
            vertical_alignment = "top",
            horizontal_alignment = "center",
            size = { 910, 700 },
            position = { 0, 0, 1 }
        },

        area_right = {
            parent = "area_root",
            vertical_alignment = "top",
            horizontal_alignment = "right",
            size = { 550, 700 },
            position = { -40, -95, 1 }
        },
        area_right_large = {
            parent = "area_root",
            vertical_alignment = "top",
            horizontal_alignment = "right",
            size = { 1100, 700 },
            position = { 0, 0, 1 }
        }
    }
}

return