local mod = get_mod("vermitannica")

local vermitannica_scenegraphs = VermitannicaSettings.menu_scenegraphs
local scenegraph_definition = {
    screen = vermitannica_scenegraphs.screen,
    area_root = vermitannica_scenegraphs.area_root,
    area_left = vermitannica_scenegraphs.area_left,
    area_middle = vermitannica_scenegraphs.area_middle,
    area_left_large = vermitannica_scenegraphs.area_left_large,
    area_right = vermitannica_scenegraphs.area_right,

    difficulty_selector_root = {
        parent = "area_right",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 100, 100 },
        position = { 0, -140, 0 }
    },
    more_details_button = {
        parent = "area_right",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = { 89, 93 },
        position = { 0, 105, 0 }
    },

    list_detail_top_left = {
        parent = "area_left_large",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 157, 97 },
        position = { -103, 60, 20 }
    },
    list_detail_bottom_left = {
        parent = "area_left_large",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 157, 97 },
        position = { -103, -60, 20 }
    },
    list_detail_top_center = {
        vertical_alignment = "top",
        parent = "list_detail_top_left",
        horizontal_alignment = "left",
        size = {
            873,
            97
        },
        position = {
            157,
            0,
            0
        }
    },
    list_detail_bottom_center = {
        vertical_alignment = "bottom",
        parent = "list_detail_bottom_left",
        horizontal_alignment = "left",
        size = {
            873,
            97
        },
        position = {
            157,
            0,
            0
        }
    },
    list_detail_top_right = {
        vertical_alignment = "top",
        parent = "list_detail_top_center",
        horizontal_alignment = "right",
        size = {
            23,
            97
        },
        position = {
            23,
            0,
            0
        }
    },
    list_detail_bottom_right = {
        vertical_alignment = "bottom",
        parent = "list_detail_bottom_center",
        horizontal_alignment = "right",
        size = {
            23,
            97
        },
        position = {
            23,
            0,
            0
        }
    }
}

local vermitannica_textures = VermitannicaSettings.textures
local attribute_icons = vermitannica_textures.attribute_icons
local mass_modifier_icons = vermitannica_textures.mass_modifier_icons
local race_modifier_icons = vermitannica_textures.race_modifier_icons
local armor_category_modifier_icons = vermitannica_textures.armor_category_modifier_icons
local detail_panel_stat_templates = {
    ---@param enemy_data table<string, vermitannica_breed>
    race_modifier = function (enemy_data)
        local race_modifier = string.format("race_%s", enemy_data.race)
        return {
            icon = race_modifier_icons[enemy_data.race],
            text = "",
            tooltip = {
                title = mod:localize(race_modifier),
                description = mod:localize(string.format("%s_description", race_modifier))
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    breed_type = function (enemy_data)
        return {
            icon = attribute_icons.breed_type,
            text = mod:localize(enemy_data.breed_type),
            tooltip = {
                title = mod:localize("breed_type"),
                description = mod:localize("breed_type_description")
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    armor_category_modifier = function (enemy_data)
        local armor_category = VermitannicaSettings.armor_categories[enemy_data.armor_category]
        local armor_category_description = string.format("%s_description", armor_category)

        return {
            icon = armor_category_modifier_icons[enemy_data.armor_category],
            text = "",
            tooltip = {
                title = mod:localize(armor_category),
                description = mod:localize(armor_category_description)
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    hit_mass = function (enemy_data, difficulty_rank)
        local hit_mass_text = enemy_data.hit_mass[difficulty_rank]
        local block_mass = enemy_data.block_mass
        if block_mass then
            hit_mass_text = string.format("%s (%s)", hit_mass_text, block_mass[difficulty_rank])
        end

        return {
            icon = attribute_icons.mass,
            text = hit_mass_text,
            tooltip = {
                title = mod:localize("stat_mass"),
                description = mod:localize("stat_mass_description")
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    max_health = function (enemy_data, difficulty_rank)
        return {
            icon = attribute_icons.max_health,
            text = enemy_data.health[difficulty_rank],
            tooltip = {
                title = mod:localize("stat_max_health"),
                description = mod:localize("stat_max_health_description")
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    stagger_resist = function (enemy_data, difficulty_rank)
        return {
            icon = attribute_icons.stagger_resist,
            text = enemy_data.stagger_resist[difficulty_rank],
            tooltip = {
                title = mod:localize("stat_stagger_resist"),
                description = mod:localize("stat_stagger_resist_description")
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    tank_modifier = function (enemy_data)
        local tank_modifier = enemy_data.tank_modifier
        local text = tank_modifier and string.format("%s%%", tank_modifier * 100) or ""

        return {
            icon = tank_modifier and mass_modifier_icons.tank,
            text = text,
            tooltip = tank_modifier and {
                title = mod:localize("stat_tank_modifier"),
                description = mod:localize("stat_tank_modifier_description")
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    linesman_modifier = function (enemy_data)
        local linesman_modifier = enemy_data.linesman_modifier
        local text = linesman_modifier and string.format("%s%%", linesman_modifier * 100) or ""

        return {
            icon = linesman_modifier and mass_modifier_icons.linesman,
            text = text,
            tooltip = linesman_modifier and {
                title = mod:localize("stat_linesman_modifier"),
                description = mod:localize("stat_linesman_modifier_description")
            }
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    heavy_linesman_modifier = function (enemy_data)
        local heavy_linesman_modifier = enemy_data.heavy_linesman_modifier
        local text = heavy_linesman_modifier and string.format("%s%%", heavy_linesman_modifier * 100) or ""

        return {
            icon = heavy_linesman_modifier and mass_modifier_icons.heavy_linesman,
            text = text,
            tooltip = heavy_linesman_modifier and {
                title = mod:localize("stat_heavy_linesman_modifier"),
                description = mod:localize("stat_heavy_linesman_modifier_description")
            }
        }
    end
}

local detail_panel_templates = {
    classifications = function (enemy_data)
        return {
            title_text = mod:localize("details_classifications"),
            details = {
                detail_panel_stat_templates.race_modifier(enemy_data),
                detail_panel_stat_templates.breed_type(enemy_data),
                detail_panel_stat_templates.armor_category_modifier(enemy_data)
            }
        }
    end,
    attributes = function (enemy_data, difficulty_rank)
        return {
            title_text = mod:localize("details_attributes"),
            details = {
                detail_panel_stat_templates.hit_mass(enemy_data, difficulty_rank),
                detail_panel_stat_templates.max_health(enemy_data, difficulty_rank),
                detail_panel_stat_templates.stagger_resist(enemy_data, difficulty_rank)
            }
        }
    end,
    mass_modifiers = function (enemy_data)
        return {
            title_text = mod:localize("details_mass_modifiers"),
            details = {
                detail_panel_stat_templates.tank_modifier(enemy_data),
                detail_panel_stat_templates.linesman_modifier(enemy_data),
                detail_panel_stat_templates.heavy_linesman_modifier(enemy_data)
            }
        }
    end

}

local detail_panel_layouts = {
    ---@param enemy_data table<string, vermitannica_breed>
    details = function (enemy_data, difficulty_rank)

        local has_mass_modifier = enemy_data.tank_modifier or enemy_data.linesman_modifier or enemy_data.heavy_linesman_modifier

        return {
            detail_panel_templates.classifications(enemy_data),
            detail_panel_templates.attributes(enemy_data, difficulty_rank),
            has_mass_modifier and detail_panel_templates.mass_modifiers(enemy_data)
        }
    end,
    ---@param enemy_data table<string, vermitannica_breed>
    list = function(enemy_data, difficulty_rank)

        local list_items = {}
        for _, breed_data in ipairs(enemy_data) do

            local id = breed_data.id
            local breed_name = EnemyPackageLoaderSettings.alias_to_breed[id] or id

            local detail_sets = {
                detail_panel_templates.attributes(breed_data, difficulty_rank).details,
                detail_panel_templates.mass_modifiers(breed_data).details
            }

            local details_content = {}
            for i, detail_set in ipairs(detail_sets) do
                details_content[i] = {}
                for j, detail in ipairs(detail_set) do
                    details_content[i][j] = {
                        icon = detail.icon,
                        text = detail.text
                    }
                end
            end

            local list_item = {
                content = {
                    id = id,
                    title_text = breed_data.display_name,
                    subtitle_text = mod:localize(breed_data.breed_type),
                    icon = vermitannica_textures.breed_textures[breed_name],
                    extra_icon_1 = detail_panel_stat_templates.race_modifier(breed_data).icon,
                    extra_icon_2 = detail_panel_stat_templates.armor_category_modifier(breed_data).icon,
                },
                details_content = details_content
            }

            list_items[#list_items + 1] = list_item

        end

        return list_items

    end
}

local detail_panel_settings = {
    detail_panel_layouts = detail_panel_layouts,
    detail_panel_templates = detail_panel_templates,
    detail_panel_stat_templates = detail_panel_stat_templates
}

local area_left_detail_widget_definitions = {
    area_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
        {
            0,
            0
        },
        {
            1,
            1
        }
    }, "list_detail_top_left"),
    area_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
        {
            0,
            1
        },
        {
            1,
            0
        }
    }, "list_detail_bottom_left"),
    area_detail_top_center = UIWidgets.create_tiled_texture("list_detail_top_center", "divider_skull_middle", {
        64,
        97
    }),
    area_detail_bottom_center = UIWidgets.create_tiled_texture("list_detail_bottom_center", "divider_skull_middle_down", {
        64,
        97
    }),
    area_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        {
            0,
            0
        },
        {
            1,
            1
        }
    }, "list_detail_top_right"),
    area_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        {
            0,
            1
        },
        {
            1,
            0
        }
    }, "list_detail_bottom_right"),
    --chain = UIWidgets.create_tiled_texture("list_scrollbar", "chain_link_01_blue", { 16, 19 })
}

local area_right_detail_widget_definitions = {
    area_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
        {
            0,
            0
        },
        {
            1,
            1
        }
    }, "list_detail_top_left"),
    area_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
        {
            0,
            1
        },
        {
            1,
            0
        }
    }, "list_detail_bottom_left"),
    area_detail_top_center = UIWidgets.create_tiled_texture("list_detail_top_center", "divider_skull_middle", {
        64,
        97
    }),
    area_detail_bottom_center = UIWidgets.create_tiled_texture("list_detail_bottom_center", "divider_skull_middle_down", {
        64,
        97
    }),
    area_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        {
            0,
            0
        },
        {
            1,
            1
        }
    }, "list_detail_top_right"),
    area_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        {
            0,
            1
        },
        {
            1,
            0
        }
    }, "list_detail_bottom_right"),
}

local function create_simple_text_button(scenegraph_id, size, localization_id)

    local icon_button = UIWidgets.create_icon_button(scenegraph_id, size, nil, nil, "icons_placeholder")
    local icon_button_passes = icon_button.element.passes
    local icon_button_content = icon_button.content
    local icon_button_style = icon_button.style

    local index
    for i, pass_definition in ipairs(icon_button_passes) do
        local texture_id = pass_definition.texture_id
        if texture_id and texture_id == "texture_icon" then
            index = i
            break
        end
    end

    if index then
        icon_button_passes[index] = {
            pass_type = "text",
            text_id = "label_text",
            style_id = "label_text"
        }

        icon_button_content.texture_icon = nil
        icon_button_content.label_text = mod:localize(localization_id)

        icon_button_style.texture_icon = nil
        icon_button_style.label_text = {
            font_type = "hell_shark",
            font_size = 24,
            dynamic_font_size = true,
            text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            hover_text_color = Colors.get_color_table_with_alpha("white", 255),
            selected_text_color = Colors.get_color_table_with_alpha("font_title", 255),
            vertical_alignment = "center",
            horizontal_alignment = "center",
            size = size,
            offset = { 0, -2, 4 }
        }

        local modified_button = {
            element = {
                passes = icon_button_passes
            },
            content = icon_button_content,
            style = icon_button_style,
            offset = { 0, 0, 0 },
            scenegraph_id = scenegraph_id
        }

        return modified_button
    end

    return icon_button

end

local widget_definitions = {
    more_details_button = UIWidgets.create_layout_button("more_details_button", "store_info_expand_off", "store_info_expand_on"),
    --more_details_button = UIWidgets.create_icon_button("more_details_button", scenegraph_definition.more_details_button.size, nil, nil, "store_info_expand_off"),
}

local animation_definitions = {
    on_enter = {
        {
            name = "fade_in",
            start_progress = 0,
            end_progress = 0.6,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.alpha_multiplier = 0
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.alpha_multiplier = anim_progress

                local difficulty_selector_widgets = widgets.difficulty_selector_widgets
                local difficulty_selector_widgets_n = #difficulty_selector_widgets
                for i = 1, difficulty_selector_widgets_n, 1 do
                    local widget = difficulty_selector_widgets[i]
                    local offset = widget.offset
                    local default_offset = widget.default_offset
                    local anim_offset = (difficulty_selector_widgets_n - i) * 25 + 50
                    offset[2] = math.floor(default_offset[2] + anim_offset - anim_offset * anim_progress)
                end

                local more_details_button = widgets.widgets_by_name.more_details_button
                local offset = more_details_button.offset
                local anim_offset = -50
                offset[2] = anim_offset - (anim_offset * anim_progress)
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    area_left_collapse = {
        {
            name = "area_left_collapse",
            start_progress = 0,
            end_progress = 0.6,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.start_length = ui_scenegraph.area_left_large.size[1]
                params.target_length = scenegraph_definition.area_left.size[1]
                widgets.widgets_by_name.more_details_button.content.texture_id = "store_info_contract_off"
                widgets.widgets_by_name.more_details_button.content.selected_texture = "store_info_contract_on"
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)

                local anim_length = params.target_length - (params.target_length - params.start_length) * (1 - anim_progress)
                ui_scenegraph.list_detail_top_center.size[1] = (anim_length - 47)
                ui_scenegraph.list_detail_bottom_center.size[1] = (anim_length - 47)
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    area_left_expand = {
        {
            name = "area_left_expand",
            start_progress = 0,
            end_progress = 0.6,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.start_length = ui_scenegraph.area_left.size[1]
                params.target_length = scenegraph_definition.area_left_large.size[1]
                widgets.widgets_by_name.more_details_button.content.texture_id = "store_info_expand_off"
                widgets.widgets_by_name.more_details_button.content.selected_texture = "store_info_expand_on"
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)

                local anim_length = params.target_length - (params.target_length - params.start_length) * (1 - anim_progress)
                ui_scenegraph.list_detail_top_center.size[1] = (anim_length - 47)
                ui_scenegraph.list_detail_bottom_center.size[1] = (anim_length - 47)
                --ui_scenegraph.more_details_button.local_position[1] = (scenegraph_definition.more_details_button.position[1] - (params.target_length - params.start_length)) * (1 - anim_progress) + 145
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    }
}

local enemy_data = mod:dofile("scripts/mods/bestiary/bestiary_enemy_data")
local breed_data_by_name = enemy_data.breed_data_by_name
local breed_data_sorted = enemy_data.breed_data_sorted

return {
    scenegraph_definition = scenegraph_definition,
    widget_definitions = widget_definitions,
    animation_definitions = animation_definitions,
    area_detail_widget_definitions = {
        left = area_left_detail_widget_definitions,
        right = area_right_detail_widget_definitions
    },
    detail_panel_settings = detail_panel_settings,
    breed_data_by_name = breed_data_by_name,
    breed_data_sorted = breed_data_sorted
}