local mod = get_mod("vermitannica")

local scenegraph_definition = {
    root = {
        vertical_alignment = "center",
        horizontal_alignment = "center",
        scale = "fit",
        position = { 0, 0, UILayer.ingame_player_list },
        size = { 1920, 1080 }
    },
    foreign_state_button_lg = {
        parent = "root",
        vertical_alignment = "center",
        position = { 0, 0, 10 },
        size = { 360, 640 }
    },
    foreign_state_button_md = {
        parent = "root",
        vertical_alignment = "center",
        position = { 0, 0, 10 },
        size = { 270, 480 }
    },
    foreign_state_button_sm = {
        parent = "root",
        vertical_alignment = "center",
        position = { 0, 0, 10 },
        size = { 135, 240 }
    }
}

local widget_templates = {
    foreign_state_button = function (scenegraph_id, size)

        local frame_settings = UIFrameSettings.menu_frame_09
        local hover_frame_settings = UIFrameSettings.menu_frame_12_gold

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
                    pass_type = "texture",
                    texture_id = "background",
                    style_id = "background"
                },
                {
                    pass_type = "texture_frame",
                    texture_id = "background_frame",
                    style_id = "background_frame",
                    content_change_function = function (content, style, animations, dt)
                        local is_hover = content.hotspot.is_hover
                        content.background_frame = is_hover and hover_frame_settings.texture or frame_settings.texture
                    end,
                }
            }
        }

        local content = {
            display_name = "",
            background = "background_leather_02",
            hotspot = {},
            background_frame = frame_settings.texture,
        }

        local style = {
            display_name = {
                font_type = "hell_shark",
                font_size = 48,
                dynamic_font_size = true,
                text_color = Colors.get_color_table_with_alpha("font_title", 255),
            },
            display_name_shadow = {
                font_type = "hell_shark",
                font_size = 48,
                dynamic_font_size = true,
                text_color = Colors.get_color_table_with_alpha("black", 200),
            },
            background = {
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

}

return {
    scenegraph_definition = scenegraph_definition,
    widget_definitions = widget_definitions,
    widget_templates = widget_templates
}