local mod = get_mod("vermitannica")

local window_default_settings = UISettings.game_start_windows
local window_size = window_default_settings.large_window_size   -- 1600 x 900

local left_window_size = {  -- 548 x 722
    math.floor( (window_size[1] + 44) / 3 ),
    window_size[2] - 178
}

local enemy_definitions = dofile("scripts/mods/bestiary/bestiary_enemy_data")
local skaven_icon_slots = enemy_definitions.skaven_icon_slots
local chaos_icon_slots = enemy_definitions.chaos_icon_slots
local beastmen_icon_slots = enemy_definitions.beastmen_icon_slots
local enemy_info = enemy_definitions.enemy_info

-- Borrowed from UIWidgets.create_icon_selector()
mod.create_icon_selector_with_default_color = function (scenegraph_id, icon_size, slot_icons, slot_spacing, use_frame, optional_frame_size, optional_allow_multi_hover, color)
    local default_color = color or {
        255,
        100,
        100,
        100
    }
    local amount = #slot_icons
    local widget = {
        element = {}
    }
    local passes = {}
    local content = {
        amount = amount
    }
    local style = {}
    local slot_width_spacing = slot_spacing or 0
    local offset_layer = 0
    local total_length = -slot_width_spacing
    local start_width_offset = 0

    for k = 1, amount, 1 do
        local name_suffix = "_" .. tostring(k)
        total_length = total_length + icon_size[1] + slot_width_spacing
        local offset = {
            start_width_offset,
            0,
            offset_layer
        }
        local hotspot_name = "hotspot" .. name_suffix
        passes[#passes + 1] = {
            pass_type = "hotspot",
            content_id = hotspot_name,
            style_id = hotspot_name
        }
        style[hotspot_name] = {
            size = icon_size,
            offset = offset
        }
        content[hotspot_name] = {
            allow_multi_hover = optional_allow_multi_hover
        }
        local hotspot_content = content[hotspot_name]
        local icon_texture = slot_icons[k][1]
        local icon_name = "icon" .. name_suffix
        passes[#passes + 1] = {
            pass_type = "texture",
            content_id = hotspot_name,
            texture_id = icon_name,
            style_id = icon_name
        }
        style[icon_name] = {
            size = icon_size,
            color = default_color,
            offset = {
                offset[1],
                offset[2],
                offset[3] + 2
            }
        }
        hotspot_content[icon_name] = icon_texture
        local selection_icon_name = "selection_icon" .. name_suffix
        passes[#passes + 1] = {
            pass_type = "texture",
            content_id = hotspot_name,
            texture_id = selection_icon_name,
            style_id = selection_icon_name,
            content_check_function = function (content)
                return content[selection_icon_name] and content.is_selected
            end
        }
        style[selection_icon_name] = {
            size = icon_size,
            color = default_color,
            offset = {
                offset[1],
                offset[2],
                offset[3] + 3
            },
            default_offset = {
                offset[1],
                offset[2],
                offset[3] + 4
            }
        }
        local disabled_name = "disabled" .. name_suffix
        passes[#passes + 1] = {
            pass_type = "texture",
            content_id = hotspot_name,
            texture_id = disabled_name,
            style_id = disabled_name,
            content_check_function = function (content)
                return content.disable_button and not content.locked
            end
        }
        style[disabled_name] = {
            size = icon_size,
            color = default_color,
            offset = {
                offset[1],
                offset[2],
                offset[3] + 4
            }
        }
        hotspot_content[disabled_name] = "kick_player_icon"
        local locked_name = "locked" .. name_suffix
        passes[#passes + 1] = {
            pass_type = "texture",
            content_id = hotspot_name,
            texture_id = locked_name,
            style_id = locked_name,
            content_check_function = function (content)
                return content.locked
            end
        }
        style[locked_name] = {
            size = {
                30,
                38
            },
            color = default_color,
            offset = {
                (offset[1] + icon_size[1] / 2) - 15,
                (offset[2] + icon_size[2] / 2) - 19,
                offset[3] + 5
            }
        }
        hotspot_content[locked_name] = "locked_icon_01"

        if use_frame then
            local frame_name = "frame" .. name_suffix
            passes[#passes + 1] = {
                pass_type = "texture",
                content_id = hotspot_name,
                texture_id = frame_name,
                style_id = frame_name
            }
            local frame_size = (optional_frame_size and table.clone(optional_frame_size)) or {
                86,
                108
            }
            style[frame_name] = {
                size = {
                    frame_size[1],
                    frame_size[2]
                },
                color = default_color,
                offset = {
                    (offset[1] + icon_size[1] / 2) - frame_size[1] / 2,
                    (offset[2] + icon_size[2] / 2) - frame_size[2] / 2,
                    offset[3] + 3
                }
            }
            hotspot_content[frame_name] = "portrait_frame_hero_selection"
        end

        start_width_offset = start_width_offset + icon_size[1] + slot_width_spacing
    end

    widget.element.passes = passes
    widget.content = content
    widget.style = style
    widget.offset = {
        -total_length / 2,
        0,
        0
    }
    widget.scenegraph_id = scenegraph_id

    return widget
end

local scenegraph_definition = {
    root = {
        is_root = true,
        size = {
            1920,
            1080
        },
        position = {
            0,
            0,
            UILayer.default
        }
    },
    menu_root = {
        parent = "root",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            1920,
            1080
        },
        position = {
            0,
            0,
            0
        }
    },
    screen = {
        scale = "fit",
        size = {
            1920,
            1080
        },
        position = {
            0,
            0,
            UILayer.default
        }
    },
    header = {
        parent = "menu_root",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            1920,
            50
        },
        position = {
            0,
            -20,
            100
        }
    },
    window = {
        parent = "screen",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = window_size,
        position = {
            0,
            0,
            1
        }
    },
    window_background = {
        parent = "window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            window_size[1] - 5,
            window_size[2] - 5
        },
        position = {
            0,
            0,
            0
        }
    },
    exit_button = {
        parent = "window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            380,
            42
        },
        position = {
            0,
            -16,
            42
        }
    },
    title = {
        parent = "window",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            658,
            60
        },
        position = {
            0,
            34,
            46
        }
    },
    title_bg = {
        parent = "title",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            410,
            40
        },
        position = {
            0,
            -15,
            -1
        }
    },
    title_text = {
        parent = "title",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        position = {
            0,
            -3,
            2
        }
    },
    top_window = {
        parent = "window",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = {
            window_size[1],
            200,
        }
    },
    top_window_background = {
        parent = "top_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            window_size[1] - 5,
            195
        },
        position = {
            0,
            0,
            0
        }
    },

    top_window_icons_skaven = {
        parent = "top_window",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            window_size[1],
            200
        },
        position = {
            window_size[1] / 2,
            100,
            1
        },
        offset = {
            0,
            0,
            0
        }
    },

    top_window_icons_chaos = {
        parent = "top_window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            window_size[1],
            100
        },
        position = {
            window_size[1] / 2,
            25,
            1
        }
    },

    top_window_icons_beastmen = {
        parent = "top_window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            window_size[1],
            200
        },
        position = {
            window_size[1] / 2,
            0,
            1
        },
        offset = {
            0,
            0,
            0
        }
    },


    left_window = {
        parent = "window",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = {
            left_window_size[1],
            left_window_size[2]
        },
        position = {
            0,
            0,
            0
        }
    },
    left_window_fade = {
        parent = "left_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 44,
            left_window_size[2] - 44,
        },
        position = {
            0,
            0,
            1
        }
    },

    enemy_preview = {
        parent = "left_window",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 44,
            left_window_size[2] - 122
        },
        position = {
            0,
            -22,
            8
        }
    },

    breed_cycle_button = {
        parent = "enemy_detail_name",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = {
            350,
            75
        },
        position = {
            0,
            0,
            8
        }
    },

    center_window = {
        parent = "window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = left_window_size,
        position = {
            0, --left_window_size[1] - 22,
            0,
            1
        }
    },
    center_window_fade = {
        parent = "center_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 44,
            left_window_size[2] - 22
        },
        position = {
            0,
            0,
            3
        }
    },

    right_window = {
        parent = "window",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = left_window_size,
        position = {
            0,
            0,
            1
        }
    },
    right_window_fade = {
        parent = "right_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 44,
            left_window_size[2] - 44
        },
        position = {
            0,
            0,
            1
        }
    },
    lore_strings = {
        parent = "right_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 66,
            left_window_size[2] - 22
        },
        position = {
            0,
            0,
            4
        }
    },
    coming_soon_statistics = {
        parent = "right_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] / 1.5,
            left_window_size[2] / 2
        },
        position = {
            0,
            0,
            2
        }
    },
    button_tray = {
        parent = "left_window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 42,
            80
        },
        position = {
            0,
            22,
            2
        }
    },
    kill_button = {
        parent = "left_window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            75
        },
        position = {
            0,
            25,
            1
        }
    },
    enemy_detail_name = {
        parent = "center_window",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            350,
            75
        },
        position = {
            0,
            -50,
            1
        }
    },
    enemy_detail_divider = {
        parent = "enemy_detail_name",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] / 2,
            32
        },
        offset = {
            0,
            -30,
            -1
        }
    },
    enemy_detail_man_size_icon = {
        parent = "enemy_detail_mass",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
           60,
           60
        },
        position = {
            -80,
            -50,
            4
        }
    },
    enemy_detail_man_size_text = {
        parent = "enemy_detail_man_size_icon",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            0,
            40
        },
        position = {
            -5,
            -35,
            1
        }
    },
    enemy_detail_elite_icon = {
        parent = "enemy_detail_stagger",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            108,
            44
        },
        position = {
            -80,
            -50,
            4
        },
        offset = {
            0,
            0,
            1
        }
    },
    enemy_detail_special_icon = {
        parent = "enemy_detail_elite_icon",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            84,
            60
        },
        position = {
            0,
            0,
            1
        }
    },
    enemy_detail_elite_text = {
        parent = "enemy_detail_elite_icon",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            0,
            40
        },
        position = {
            -5,
            -35,
            1
        }
    },
    enemy_detail_boss_icon = {
        parent = "enemy_detail_elite_icon",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            48,
            48
        },
        position = {
            0,
            0,
            1
        }
    },
    enemy_detail_lord_icon = {
        parent = "enemy_detail_elite_icon",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            52,
            52
        },
        position = {
            0,
            0,
            1
        }
    },
    enemy_detail_race_category = {
        parent = "enemy_detail_divider",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            -160,
            -50,
            0
        }
    },
    enemy_detail_race = {
        parent = "enemy_detail_race_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            0,
            -50,
            0
        }
    },
    enemy_detail_armor_category = {
        parent = "enemy_detail_divider",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            160,
            -50,
            0
        }
    },
    enemy_detail_armor = {
        parent = "enemy_detail_armor_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            0,
            -50,
            0
        }
    },
    enemy_detail_health_category = {
        parent = "enemy_detail_divider",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            0,
            -50,
            0
        }
    },
    enemy_detail_health = {
        parent = "enemy_detail_health_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            0,
            -50,
            0
        }
    },
    enemy_detail_mass_category = {
        parent = "enemy_detail_health",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            -80,
            -50,
            0
        }
    },
    enemy_detail_mass = {
        parent = "enemy_detail_mass_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            0,
            -50,
            0
        }
    },
    enemy_detail_stagger_category = {
        parent = "enemy_detail_health",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            80,
            -50,
            0
        }
    },
    enemy_detail_stagger = {
        parent = "enemy_detail_stagger_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        offset = {
            0,
            -50,
            0
        }
    },

    enemy_detail_modifiers = {
        parent = "difficulty_button",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            350,
            50
        },
        position = {
            0,
            150,
            0
        }
    },

    enemy_detail_linesman = {
        parent = "enemy_detail_modifiers",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = {
            50,
            50
        },
        position = {
            -80,
            -50,
            0
        }
    },
    enemy_detail_linesman_text = {
        parent = "enemy_detail_linesman",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = {
            0,
            25
        },
        position = {
            0,
            0,
            2
        }
    },
    enemy_detail_linesman_value = {
        parent = "enemy_detail_linesman_text",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = {
            0,
            25
        },
        position = {
            0,
            -25,
            0
        }
    },

    enemy_detail_heavy_linesman = {
        parent = "enemy_detail_modifiers",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            50,
            50
        },
        position = {
            -60,
            -75,
            0
        }
    },
    enemy_detail_heavy_linesman_text = {
        parent = "enemy_detail_heavy_linesman",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = {
            0,
            25
        },
        position = {
            0,
            0,
            2
        }
    },
    enemy_detail_heavy_linesman_value = {
        parent = "enemy_detail_heavy_linesman_text",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = {
            0,
            25
        },
        position = {
            0,
            -25,
            0
        }
    },

    enemy_detail_tank = {
        parent = "enemy_detail_modifiers",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = {
            50,
            50
        },
        position = {
            80,
            -50,
            0
        }
    },
    enemy_detail_tank_text = {
        parent = "enemy_detail_tank",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = {
            0,
            25
        },
        position = {
            0,
            0,
            2
        }
    },
    enemy_detail_tank_value = {
        parent = "enemy_detail_tank_text",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = {
            0,
            25
        },
        position = {
            0,
            -25,
            0
        }
    },

    difficulty_button = {
        parent = "center_window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            350,
            75
        },
        offset = {
            0,
            50,
            2
        }
    },

    statistics_block = {
        parent = "right_window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            left_window_size[1] - 44,
            left_window_size[2]
        }
    },

    statistics_kills_text = {
        parent = "statistics_block",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            2
        }
    },
    statistics_slain_per_breed = {
        parent = "statistics_kills_text",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },

    statistics_melee_headshot_category = {
        parent = "statistics_slain_per_breed",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            -120,
            -50,
            2
        }
    },
    statistics_melee_headshot = {
        parent = "statistics_melee_headshot_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },
    statistics_ranged_headshot_category = {
        parent = "statistics_slain_per_breed",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            120,
            -50,
            2
        }
    },
    statistics_ranged_headshot = {
        parent = "statistics_ranged_headshot_category",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size ={
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },

    statistics_times_downed_text = {
        parent = "statistics_block",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            50,
            0
        }
    },
    statistics_times_downed = {
        parent = "statistics_times_downed_text",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },

    statistics_special_text1 = {
        parent = "statistics_block",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = {
            150,
            50
        },
        position = {
            10,
            100,
            2
        }
    },
    statistics_special_value1 = {
        parent = "statistics_special_text1",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },
    statistics_special_text2 = {
        parent = "statistics_block",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            100,
            2
        }
    },
    statistics_special_value2 = {
        parent = "statistics_special_text2",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },
    statistics_special_text3 = {
        parent = "statistics_block",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = {
            150,
            50
        },
        position = {
            -10,
            100,
            2
        }
    },
    statistics_special_value3 = {
        parent = "statistics_special_text3",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },

    statistics_boss_text1 = {
        parent = "statistics_block",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = {
            200,
            50
        },
        position = {
            50,
            100,
            2
        }
    },
    statistics_boss_value1 = {
        parent = "statistics_boss_text1",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },
    statistics_boss_text2 = {
        parent = "statistics_block",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = {
            200,
            50
        },
        position = {
            -50,
            100,
            2
        }
    },
    statistics_boss_value2 = {
        parent = "statistics_boss_text2",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    },

    statistics_damage_received_text = {
        parent = "statistics_block",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -100,
            0
        }
    },
    statistics_damage_received = {
        parent = "statistics_damage_received_text",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = {
            150,
            50
        },
        position = {
            0,
            -50,
            0
        }
    }
}

local title_text_style = {
    use_shadow = true,
    upper_case = true,
    localize = false,
    font_size = 28,
    horizontal_alignment = "center",
    vertical_alignment = "center",
    dynamic_font_size = true,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    offset = {
        0,
        0,
        2
    }
}

local enemy_detail_name_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 48,
    horizontal_alignment = "center",
    vertical_alignment = "center",
    dynamic_font_size = true,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
    select_text_color = Colors.get_color_table_with_alpha("font_title", 255),
    size = {
        scenegraph_definition.enemy_detail_name.size[1] - 40,
        scenegraph_definition.enemy_detail_name.size[2]
    },
    offset = {
        20,
        0,
        2
    }
}

local statistics_category_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 42,
    vertical_alignment = "center",
    horizontal_alignment = "center",
    dynamic_font_size = false,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    offset = {
        0,
        0,
        2
    }
}

local statistics_text_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 42,
    horizontal_alignment = "center",
    vertical_alignment = "center",
    dynamic_font_size = false,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_default", 255),
    offset = {
        0,
        0,
        2
    }
}

local enemy_detail_category_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 32,
    horizontal_alignment = "center",
    vertical_alignment = "center",
    dynamic_font_size = true,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    offset = {
        0,
        0,
        2
    }
}

local test_style = table.clone(enemy_detail_category_style)
test_style.word_wrap = true

local enemy_detail_text_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 28,
    horizontal_alignment = "center",
    vertical_alignment = "center",
    dynamic_font_size = false,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_default", 255),
    offset = {
        0,
        0,
        2
    }
}


local coming_soon_text_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 48,
    vertical_alignment = "center",
    horizontal_alignment = "center",
    dynamic_font_size = false,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("dark_red", 180),
    offset = {
        0,
        0,
        2
    }
}

local enemy_detail_left_mod_text_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 24,
    vertical_alignment = "top",
    horizontal_alignment = "left",
    font_type = "hell_shark",
    text_color = Colors.get_color_table_with_alpha("font_default", 255),
    offset = {
        0,
        0,
        2
    }
}

local enemy_detail_right_mod_text_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 24,
    vertical_alignment = "top",
    horizontal_alignment = "right",
    font_type = "hell_shark",
    text_color = Colors.get_color_table_with_alpha("font_default", 255),
    offset = {
        0,
        0,
        2
    }
}

local mass_modifier_title_text_left = {
    vertical_alignment = "center",
    horizontal_alignment = "left",
    font_size = 20,
    font_type = "hell_shark",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    offset = {
        0,
        0,
        2
    }
}

local mass_modifier_title_text_right = {
    vertical_alignment = "center",
    horizontal_alignment = "right",
    font_size = 20,
    font_type = "hell_shark",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    offset = {
        0,
        0,
        2
    }
}

local viewport_widget = {
    scenegraph_id = "enemy_preview",
    element = UIElements.Viewport,
    style = {
        viewport = {
            layer = 990,
            viewport_name = "enemy_preview_viewport",
            clear_screen_on_create = true,
            level_name = "levels/ui_inventory_preview/world",
            level_package_name = "resource_packages/levels/ui_inventory_preview",
            enable_sub_gui = false,
            world_name = "enemy_preview",
            world_flags = {
                Application.DISABLE_SOUND,
                Application.DISABLE_ESRAM
            },
            camera_position = {
                0,
                0,
                0
            },
            camera_lookat = {
                0,
                0,
                1
            }
        }
    },
    content = {
        button_hotspot = {
            allow_multi_hover = true
        }
    }
}

local widgets = {
    window = UIWidgets.create_frame("window", scenegraph_definition.window.size, "menu_frame_11", 40),
    window_background = UIWidgets.create_tiled_texture("window_background", "menu_frame_bg_02", {
        960,
        1080
    }, nil, nil, {
        255,
        180,
        180,
        180
    }),
    exit_button = UIWidgets.create_default_button("exit_button", scenegraph_definition.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34),
    title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
    title_bg = UIWidgets.create_background("title_bg", scenegraph_definition.title_bg.size, "menu_frame_bg_02"),
    title_text = UIWidgets.create_simple_text(mod:localize("bestiary_title"), "title_text", nil, nil, title_text_style),

    top_window = UIWidgets.create_frame("top_window", scenegraph_definition.top_window.size, "menu_frame_11", 40),
    top_window_background = UIWidgets.create_tiled_texture("top_window_background", "menu_frame_bg_01", {
        960,
        1080
    }, nil, nil, {
        255,
        180,
        180,
        180
    }),

    left_window_frame = UIWidgets.create_frame("left_window", scenegraph_definition.left_window.size, "menu_frame_11", 20),
    left_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "left_window_fade"),
    button_tray = UIWidgets.create_frame("button_tray", scenegraph_definition.button_tray.size, "menu_frame_09_divider", 24),
    button_tray_bg = UIWidgets.create_tiled_texture("button_tray", "menu_frame_bg_01", {
        960,
        1080
    }, nil, nil, {255, 180, 180, 180}),
    center_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "center_window_fade"),
    right_window_frame = UIWidgets.create_frame("right_window", scenegraph_definition.right_window.size, "menu_frame_11", 20),
    right_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "right_window_fade"),

    enemy_detail_name = UIWidgets.create_simple_text("", "enemy_detail_name", nil, nil, enemy_detail_name_style),
    enemy_detail_lord_icon = UIWidgets.create_simple_texture("boss_icon", "enemy_detail_lord_icon"),
    enemy_detail_boss_icon = UIWidgets.create_simple_texture("hud_tutorial_survival_icon_attack_direction", "enemy_detail_boss_icon"),
    enemy_detail_elite_icon = UIWidgets.create_simple_texture("mission_objective_01", "enemy_detail_elite_icon"),
    enemy_detail_elite_icon_glow = UIWidgets.create_simple_texture("mission_objective_glow_02", "enemy_detail_elite_icon"),
    enemy_detail_special_icon = UIWidgets.create_simple_texture("achievement_symbol_hourglass", "enemy_detail_special_icon"),
    enemy_detail_divider = UIWidgets.create_simple_texture("divider_01_top", "enemy_detail_divider"),
    enemy_detail_elite_text = UIWidgets.create_simple_text("", "enemy_detail_elite_text", nil, nil, enemy_detail_text_style),

    enemy_detail_man_size_icon = UIWidgets.create_simple_texture("hud_ability_icon", "enemy_detail_man_size_icon"),
    enemy_detail_man_size_text = UIWidgets.create_simple_text("", "enemy_detail_man_size_text", nil, nil, enemy_detail_text_style),

    enemy_detail_race_category = UIWidgets.create_simple_text("", "enemy_detail_race_category", nil, nil, enemy_detail_category_style),
    enemy_detail_race = UIWidgets.create_simple_text("", "enemy_detail_race", nil, nil, enemy_detail_text_style),
    enemy_detail_armor_category = UIWidgets.create_simple_text("", "enemy_detail_armor_category", nil, nil, enemy_detail_category_style),
    enemy_detail_armor = UIWidgets.create_simple_text("", "enemy_detail_armor", nil, nil, enemy_detail_text_style),
    enemy_detail_health_category = UIWidgets.create_simple_text("", "enemy_detail_health_category", nil, nil, enemy_detail_category_style),
    enemy_detail_health = UIWidgets.create_simple_text("", "enemy_detail_health", nil, nil, enemy_detail_text_style),

    enemy_detail_mass_category = UIWidgets.create_simple_text("", "enemy_detail_mass_category", nil, nil, enemy_detail_category_style),
    enemy_detail_mass = UIWidgets.create_simple_text("", "enemy_detail_mass", nil, nil, enemy_detail_text_style),
    enemy_detail_stagger_category = UIWidgets.create_simple_text("", "enemy_detail_stagger_category", nil, nil, enemy_detail_category_style),
    enemy_detail_stagger = UIWidgets.create_simple_text("", "enemy_detail_stagger", nil, nil, enemy_detail_text_style),

    enemy_detail_modifiers = UIWidgets.create_simple_text("", "enemy_detail_modifiers", nil, nil, enemy_detail_category_style),
    enemy_detail_linesman = UIWidgets.create_simple_texture("mass_modifier_icon", "enemy_detail_linesman"),
    enemy_detail_linesman_text = UIWidgets.create_simple_text("", "enemy_detail_linesman_text", nil, nil, mass_modifier_title_text_left),
    enemy_detail_linesman_value = UIWidgets.create_simple_text("", "enemy_detail_linesman_value", nil, nil, enemy_detail_left_mod_text_style),
    enemy_detail_heavy_linesman = UIWidgets.create_simple_texture("mass_modifier_icon", "enemy_detail_heavy_linesman"),
    enemy_detail_heavy_linesman_text = UIWidgets.create_simple_text("", "enemy_detail_heavy_linesman_text", nil, nil, mass_modifier_title_text_left),
    enemy_detail_heavy_linesman_value = UIWidgets.create_simple_text("", "enemy_detail_heavy_linesman_value", nil, nil, enemy_detail_left_mod_text_style),
    enemy_detail_tank = UIWidgets.create_simple_texture("mass_modifier_icon", "enemy_detail_tank"),
    enemy_detail_tank_text = UIWidgets.create_simple_text("", "enemy_detail_tank_text", nil, nil, mass_modifier_title_text_right),
    enemy_detail_tank_value = UIWidgets.create_simple_text("", "enemy_detail_tank_value", nil, nil, enemy_detail_right_mod_text_style),

    breed_cycle_button = UIWidgets.create_default_button("breed_cycle_button", scenegraph_definition.breed_cycle_button.size, nil, nil, "", 24, nil),
    difficulty_button = UIWidgets.create_default_button("difficulty_button", scenegraph_definition.difficulty_button.size, nil, nil, "", 24, nil),

    enemy_icons_skaven = mod.create_icon_selector_with_default_color("top_window_icons_skaven", {60, 70}, skaven_icon_slots, 30, false, nil),
    enemy_icons_chaos = mod.create_icon_selector_with_default_color("top_window_icons_chaos", {60, 70}, chaos_icon_slots, 30, false),
    enemy_icons_beastmen = mod.create_icon_selector_with_default_color("top_window_icons_beastmen", {60, 70}, beastmen_icon_slots, 30, false),

    lore_strings = UIWidgets.create_simple_text("", "lore_strings", nil, nil, table.clone(enemy_detail_text_style)),
    coming_soon_statistics = UIWidgets.create_simple_text("", "coming_soon_statistics", nil, nil, coming_soon_text_style),

    statistics_kills_text = UIWidgets.create_simple_text("", "statistics_kills_text", nil, nil, statistics_category_style),
    statistics_slain_per_breed = UIWidgets.create_simple_text("", "statistics_slain_per_breed", nil, nil, statistics_text_style),

    statistics_times_downed_text = UIWidgets.create_simple_text("", "statistics_times_downed_text", nil, nil, statistics_category_style),
    statistics_times_downed = UIWidgets.create_simple_text("", "statistics_times_downed", nil, nil, statistics_text_style),

    statistics_damage_received_text = UIWidgets.create_simple_text("", "statistics_damage_received_text", nil, nil, statistics_category_style),
    statistics_damage_received = UIWidgets.create_simple_text("", "statistics_damage_received", nil, nil, statistics_text_style),

    statistics_melee_headshot_category = UIWidgets.create_simple_text("", "statistics_melee_headshot_category", nil, nil, enemy_detail_category_style),
    statistics_melee_headshot = UIWidgets.create_simple_text("", "statistics_melee_headshot", nil, nil, enemy_detail_text_style),

    statistics_ranged_headshot_category = UIWidgets.create_simple_text("", "statistics_ranged_headshot_category", nil, nil, enemy_detail_category_style),
    statistics_ranged_headshot = UIWidgets.create_simple_text("", "statistics_ranged_headshot", nil, nil, enemy_detail_text_style),

    statistics_special_text1 = UIWidgets.create_simple_text("", "statistics_special_text1", nil, nil, test_style),
    statistics_special_value1 = UIWidgets.create_simple_text("", "statistics_special_value1", nil, nil, enemy_detail_text_style),

    statistics_special_text2 = UIWidgets.create_simple_text("", "statistics_special_text2", nil, nil, test_style),
    statistics_special_value2 = UIWidgets.create_simple_text("", "statistics_special_value2", nil, nil, enemy_detail_text_style),

    statistics_special_text3 = UIWidgets.create_simple_text("", "statistics_special_text3", nil, nil, test_style),
    statistics_special_value3 = UIWidgets.create_simple_text("", "statistics_special_value3", nil, nil, enemy_detail_text_style),

    statistics_boss_text1 = UIWidgets.create_simple_text("", "statistics_boss_text1", nil, nil, test_style),
    statistics_boss_value1 = UIWidgets.create_simple_text("", "statistics_boss_value1", nil, nil, enemy_detail_text_style),

    statistics_boss_text2 = UIWidgets.create_simple_text("", "statistics_boss_text2", nil, nil, test_style),
    statistics_boss_value2 = UIWidgets.create_simple_text("", "statistics_boss_value2", nil, nil, enemy_detail_text_style),

    kill_button = UIWidgets.create_default_button("kill_button", scenegraph_definition.kill_button.size, nil, nil, "Die!", 24, nil),
}

-- TODO: just create a variable for the following
widgets.lore_strings.style.text.font_size = 20
widgets.lore_strings.style.text_shadow.font_size = 20
widgets.lore_strings.style.text.word_wrap = true
widgets.lore_strings.style.text_shadow.word_wrap = true

widgets.enemy_detail_elite_icon_glow.offset = {0, 0, 1}

widgets.breed_cycle_button.style.title_text = enemy_detail_name_style
widgets.breed_cycle_button.style.title_text_shadow = table.clone(enemy_detail_name_style)
widgets.breed_cycle_button.style.title_text_shadow.text_color = Colors.get_color_table_with_alpha("black", 255)
widgets.breed_cycle_button.style.title_text_shadow.default_text_color = Colors.get_color_table_with_alpha("black", 255)
widgets.breed_cycle_button.style.title_text_shadow.select_text_color = Colors.get_color_table_with_alpha("black", 255)
widgets.breed_cycle_button.style.title_text_shadow.offset = {22, -2, 0}


local animation_definitions = {
    on_enter = {
        {
            name = "fade_in",
            start_progress = 0,
            end_progress = 0.3,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.alpha_multiplier = 0
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                params.render_settings.alpha_multiplier = 1
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_exit = {
        {
            name = "fade_out",
            start_progress = 0,
            end_progress = 0.3,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.alpha_multiplier = 1
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                params.render_settings.alpha_multiplier = 1
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    }
}

local camera_position_by_enemy = {
    chaos_spawn = {
        z = 1.25,
        x = 0,
        y = 3.5
    },
    chaos_troll = {
        z = 1.5,
        x = 0,
        y = 3.5
    },
    skaven_stormfiend = {
        z = 1.5,
        x = 0,
        y = 3.5
    },
    skaven_rat_ogre = {
        z = 1.5,
        x = 0,
        y = 3.5
    },
    chaos_exalted_champion_warcamp = {
        z = 1.25,
        x = 0,
        y = 2.5
    },
    chaos_exalted_champion_norsca = {
        z = 1,
        x = 0,
        y = 2.5
    },
    chaos_spawn_exalted_champion_norsca = {
        z = 1.25,
        x = 0,
        y = 3.5
    }
}

return {
    widgets = widgets,
    viewport_widget = viewport_widget,
    animation_definitions = animation_definitions,
    scenegraph_definition = scenegraph_definition,
    skaven_icon_slots = skaven_icon_slots,
    chaos_icon_slots = chaos_icon_slots,
    enemy_info = enemy_info,
    camera_position_by_enemy = camera_position_by_enemy
}