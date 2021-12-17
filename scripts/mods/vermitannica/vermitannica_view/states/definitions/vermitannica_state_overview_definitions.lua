local mod = get_mod("vermitannica")

local scenegraph_definition = {
    root = {
        vertical_alignment = "center",
        horizontal_alignment = "center",
        scale = "fit",
        position = { 0, 0, UILayer.ingame_player_list },
        size = { 1920, 1080 }
    },
    --test_statistic = {
    --    parent = "root",
    --    vertical_alignment = "center",
    --    horizontal_alignment = "center",
    --    size = { 200, 50 },
    --    position = { 0, 0, 50 },
    --},
    --foreign_state_button_lg = {
    --    parent = "root",
    --    vertical_alignment = "center",
    --    position = { 0, 0, 10 },
    --    size = { 360, 640 }
    --},
    --foreign_state_button_md = {
    --    parent = "root",
    --    vertical_alignment = "center",
    --    position = { 0, 0, 10 },
    --    size = { 270, 480 }
    --},
    --foreign_state_button_sm = {
    --    parent = "root",
    --    vertical_alignment = "center",
    --    position = { 0, 0, 10 },
    --    size = { 135, 240 }
    --}
}

local widget_templates = {
    statistic = function (scenegraph_id, size)

        local frame_settings = UIFrameSettings.menu_frame_06

        local element = {
            passes = {
                {
                    pass_type = "hotspot",
                    content_id = "hotspot"
                },
                {
                    pass_type = "text",
                    text_id = "display_name",
                    style_id = "display_name"
                },
                {
                    pass_type = "text",
                    text_id = "display_name",
                    style_id = "display_name_shadow"
                },
                {
                    pass_type = "text",
                    text_id = "display_value",
                    style_id = "display_value"
                },
                {
                    pass_type = "text",
                    text_id = "display_value",
                    style_id = "display_value_shadow"
                },
                {
                    pass_type = "tiled_texture",
                    texture_id = "background",
                    style_id = "background"
                },
                {
                    pass_type = "texture_frame",
                    texture_id = "background_frame",
                    style_id = "background_frame"
                },

            }
        }

        local content = {
            display_name = "Total Slain",
            display_value = "3,800,000",
            background = "menu_frame_bg_03",
            hotspot = {},
            background_frame = frame_settings.texture,
        }

        local style = {
            display_name = {
                font_type = "hell_shark",
                font_size = 20,
                dynamic_font_size = true,
                vertical_alignment = "top",
                horizontal_alignment = "left",
                text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
                offset = { 5, 0, 3 }
            },
            display_name_shadow = {
                font_type = "hell_shark",
                font_size = 20,
                dynamic_font_size = true,
                vertical_alignment = "top",
                horizontal_alignment = "left",
                text_color = Colors.get_color_table_with_alpha("black", 200),
                offset = { 7, -2, 2 }
            },
            display_value = {
                font_type = "hell_shark",
                font_size = 20,
                dynamic_font_size = true,
                vertical_alignment = "bottom",
                horizontal_alignment = "right",
                text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
                offset = { -7, 0, 3 }
            },
            display_value_shadow = {
                font_type = "hell_shark",
                font_size = 20,
                dynamic_font_size = true,
                vertical_alignment = "bottom",
                horizontal_alignment = "right",
                text_color = Colors.get_color_table_with_alpha("black", 200),
                offset = { -5, -2, 2 }
            },
            background = {
                texture_tiling_size = { 256, 256 },
                texture_size = size,
                color = { 255, 255, 255, 255 }
            },
            background_frame = {
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes
            }
        }

        return {
            element = element,
            content = content,
            style = style,
            scenegraph_id = scenegraph_id,
            offset = { 0, 0, 0 }
        }

    end
}

local widget_definitions = {
    --test_statistic = widget_templates.statistic("test_statistic", scenegraph_definition.test_statistic.size)
}

return {
    scenegraph_definition = scenegraph_definition,
    widget_definitions = widget_definitions,
    widget_templates = widget_templates
}