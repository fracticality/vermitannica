local mod = get_mod("vermitannica")

local vermitannica_scenegraphs = VermitannicaSettings.menu_scenegraphs
local window_size = { 550, 700 }
local inner_window_size = {
    window_size[1] - 84,
    window_size[2] - 84
}

local scenegraph_definition = {
    screen = vermitannica_scenegraphs.screen,
    area = vermitannica_scenegraphs.area,
    area_root = vermitannica_scenegraphs.area_root,
    area_left = vermitannica_scenegraphs.area_left,
    area_right = vermitannica_scenegraphs.area_right,
    area_divider = vermitannica_scenegraphs.area_divider,

    window_root = {
        parent = "area_right",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = window_size,
        position = { 0, 0, 10 }
    },
    window_background = {
        parent = "area_right",
        vertical_alignment = "center",
        horizontal_alignment = "right",
        size = window_size,
        position = { 0, 0, 0 }
    },
    window = {
        parent = "window_root",
        vertical_alignment = "center",
        horizontal_alignment = "right",
        size = window_size,
        position = { 0, 0, 0 }
    },

    frame_title_text = {
        parent = "window_root",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = { window_size[1], 0 },
        position = { 0, 15, 2}
    },

    detail_panel_root = {
        parent = "window",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { window_size[1], 200 },
        position = { 0, 0, 1 }
    },

    window_panel_top = {
        parent = "window",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = { window_size[1], 200 },
        position = { 0, -25, 1 }
    },
    window_panel_top_title_bg = {
        parent = "window_panel_top",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 327, 48 },
        position = { 0, 0, 1 }
    },
    window_panel_top_divider_top = {
        parent = "window_panel_top",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = { window_size[1], 21 },
        position = { 0, 16, 3 }
    },
    window_panel_top_divider_bottom = {
        parent = "window_panel_top",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = { window_size[1], 21 },
        position = { 0, -5, 3 }
    },
    window_panel_top_detail_top_left = {
        parent = "window_panel_top",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 110, 100 },
        position = { 0, -2, 2 }
    },
    window_panel_top_detail_bottom_left = {
        parent = "window_panel_top",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 110, 100 },
        position = { 0, 0, 2 }
    },
    window_panel_top_detail_top_right = {
        parent = "window_panel_top",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = { 110, 100 },
        position = { 0, -2, 2 }
    },
    window_panel_top_detail_bottom_right = {
        parent = "window_panel_top",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = { 110, 100 },
        position = { 0, 0, 2 }
    },

    window_panel_divider_top = {
        parent = "window_panel_top",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = { window_size[1], 50 },
        position = { 0, -50, 0 }
    },

    window_panel_middle = {
        parent = "window",
        vertical_alignment = "center",
        horizontal_alignment = "center",
        size = { window_size[1], 200 },
        position = { 0, 0, 0 }
    },
    window_panel_middle_detail_top_left = {
        parent = "window_panel_middle",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 110, 100 },
        position = { 0, 0, 0 }
    },
    window_panel_middle_detail_bottom_left = {
        parent = "window_panel_middle",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 110, 100 },
        position = { 0, 0, 0 }
    },

    window_panel_bottom = {
        parent = "window",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = { window_size[1], 200 },
        position = { 0, 25, 0 }
    },
    window_panel_bottom_detail_top_left = {
        parent = "window_panel_bottom",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 110, 100 },
        position = { 0, 0, 0 }
    },
    window_panel_bottom_detail_bottom_left = {
        parent = "window_panel_bottom",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 110, 100 },
        position = { 0, 0, 0 }
    },

    frame_detail_top_left = {
        parent = "frame_detail_top_center",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 23, 97 },
        position = { -23, 0, 0 }
    },
    frame_detail_top_center = {
        parent = "frame_detail_top_right",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = { window_size[1], 97 },
        position = { -23, 0, 0 }
    },
    frame_detail_top_right = {
        parent = "window_root",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = { 23, 97 },
        position = { 23, 60, 3 }
    },
    frame_detail_bottom_left = {
        parent = "frame_detail_bottom_center",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 23, 97 },
        position = { -23, 0, 0 }
    },
    frame_detail_bottom_center = {
        parent = "frame_detail_bottom_right",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = { window_size[1], 97 },
        position = { -23, 0, 0 }
    },
    frame_detail_bottom_right = {
        parent = "window_root",
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        size = { 23, 97 },
        position = { 23, -60, 3 }
    }
}

local frame_title_text_style = {
    font_type = "hell_shark_header",
    font_size = 48,
    localize = false,
    use_shadow = true,
    vertical_alignment = "bottom",
    horizontal_alignment = "left",
    text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
    offset = { 0, 0, 2 }
}

local function create_detail_panel(scenegraph_id, size)

    local element = {
        passes = {
            {
                pass_type = "hotspot",
                content_id = "detail_1_hotspot",
                style_id = "detail_1_hotspot"
            },
            {
                pass_type = "hotspot",
                content_id = "detail_2_hotspot",
                style_id = "detail_2_hotspot"
            },
            {
                pass_type = "hotspot",
                content_id = "detail_3_hotspot",
                style_id = "detail_3_hotspot"
            },
            {
                pass_type = "tiled_texture",
                texture_id = "background",
                style_id = "background"
            },
            {
                pass_type = "texture",
                texture_id = "background_fade",
                style_id = "background_fade"
            },
            {
                pass_type = "texture_frame",
                texture_id = "frame",
                style_id = "frame"
            },
            {
                pass_type = "texture_uv",
                content_id = "detail_top_left",
                style_id = "detail_top_left"
            },
            {
                pass_type = "texture_uv",
                content_id = "detail_bottom_left",
                style_id = "detail_bottom_left"
            },
            {
                pass_type = "texture_uv",
                content_id = "detail_top_right",
                style_id = "detail_top_right"
            },
            {
                pass_type = "texture_uv",
                content_id = "detail_bottom_right",
                style_id = "detail_bottom_right"
            },
            {
                pass_type = "text",
                text_id = "title_text",
                style_id = "title_text"
            },
            {
                pass_type = "text",
                text_id = "title_text",
                style_id = "title_text_shadow"
            },
            {
                pass_type = "texture",
                texture_id = "title_divider",
                style_id = "title_divider"
            },

            {
                pass_type = "texture",
                texture_id = "detail_1_icon",
                style_id = "detail_1_icon",
                content_check_function = function (content)
                    return content.detail_1_icon and content.detail_1_icon ~= ""
                end
            },
            {
                pass_type = "texture",
                texture_id = "detail_1_icon",
                style_id = "detail_1_icon_shadow",
                content_check_function = function (content)
                    return content.detail_1_icon and content.detail_1_icon ~= ""
                end
            },
            {
                pass_type = "text",
                text_id = "detail_1_text",
                style_id = "detail_1_text"
            },
            {
                pass_type = "text",
                text_id = "detail_1_text",
                style_id = "detail_1_text_shadow"
            },
            {
                pass_type = "additional_option_tooltip",
                additional_option_id = "detail_1_tooltip",
                content_passes = {
                    "additional_option_info"
                },
                style_id = "detail_1_tooltip",
                content_check_function = function (content)
                    return content.detail_1_tooltip and content.detail_1_hotspot.is_hover
                end
            },

            {
                pass_type = "texture",
                texture_id = "detail_2_icon",
                style_id = "detail_2_icon",
                content_check_function = function (content)
                    return content.detail_2_icon and content.detail_2_icon ~= ""
                end
            },
            {
                pass_type = "texture",
                texture_id = "detail_2_icon",
                style_id = "detail_2_icon_shadow",
                content_check_function = function (content)
                    return content.detail_2_icon and content.detail_2_icon ~= ""
                end
            },
            {
                pass_type = "text",
                text_id = "detail_2_text",
                style_id = "detail_2_text"
            },
            {
                pass_type = "text",
                text_id = "detail_2_text",
                style_id = "detail_2_text_shadow"
            },
            {
                pass_type = "additional_option_tooltip",
                additional_option_id = "detail_2_tooltip",
                content_passes = {
                    "additional_option_info"
                },
                style_id = "detail_2_tooltip",
                content_check_function = function (content)
                    return content.detail_2_tooltip and content.detail_2_hotspot.is_hover
                end
            },

            {
                pass_type = "texture",
                texture_id = "detail_3_icon",
                style_id = "detail_3_icon",
                content_check_function = function (content)
                    return content.detail_3_icon and content.detail_3_icon ~= ""
                end
            },
            {
                pass_type = "texture",
                texture_id = "detail_3_icon",
                style_id = "detail_3_icon_shadow",
                content_check_function = function (content)
                    return content.detail_3_icon and content.detail_3_icon ~= ""
                end
            },
            {
                pass_type = "text",
                text_id = "detail_3_text",
                style_id = "detail_3_text"
            },
            {
                pass_type = "text",
                text_id = "detail_3_text",
                style_id = "detail_3_text_shadow"
            },
            {
                pass_type = "additional_option_tooltip",
                additional_option_id = "detail_3_tooltip",
                content_passes = {
                    "additional_option_info"
                },
                style_id = "detail_3_tooltip",
                content_check_function = function (content)
                    return content.detail_3_tooltip and content.detail_3_hotspot.is_hover
                end
            }
        }
    }

    local frame_settings = UIFrameSettings.menu_frame_06

    local content = {
        detail_1_hotspot = {},
        detail_2_hotspot = {},
        detail_3_hotspot = {},
        background = "menu_frame_bg_03",
        background_fade = "options_window_fade_01",
        frame = frame_settings.texture,
        detail_top_left = {
            texture_id = "athanor_decoration_corner",
            uvs = { {0, 0}, {1, 1 } }
        },
        detail_bottom_left = {
            texture_id = "athanor_decoration_corner",
            uvs = { {0, 1}, {1, 0} }
        },
        detail_top_right = {
            texture_id = "athanor_decoration_corner",
            uvs = { {1, 0}, {0, 1} }
        },
        detail_bottom_right = {
            texture_id = "athanor_decoration_corner",
            uvs = { {1, 1}, {0, 0} }
        },
        title_divider = "divider_01_top",

        title_text = "",

        detail_1_icon = "",
        detail_1_text = "",
        detail_1_tooltip = nil,

        detail_2_icon = "",
        detail_2_text = "",
        detail_2_tooltip = nil,

        detail_3_icon = "",
        detail_3_text = "",
        detail_3_tooltip = nil
    }

    local function detail_text_style(offset)
        return {
            size = { 50, 30 },
            font_type = "hell_shark",
            font_size = 28,
            vertical_alignment = "top",
            horizontal_alignment = "center",
            text_color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = offset
        }
    end

    local function detail_text_shadow_style(offset)
        return {
            size = { 50, 30 },
            font_type = "hell_shark",
            font_size = 28,
            vertical_alignment = "top",
            horizontal_alignment = "center",
            text_color = Colors.get_color_table_with_alpha("black", 255),
            offset = offset
        }
    end

    local style = {
        detail_1_hotspot = {
            size = { 50, 85 },
            offset = { 125, 20, 0 }
        },
        detail_2_hotspot = {
            size = { 50, 85 },
            offset = { size[1] / 2 - 25, 30, 0 }
        },
        detail_3_hotspot = {
            size = { 50, 85 },
            offset = { size[1] - 150, 20, 0 }
        },
        background = {
            texture_tiling_size = { 256, 256 },
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, -1 }
        },
        background_fade = {
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 0 }
        },
        frame = {
            texture_size = frame_settings.texture_size,
            texture_sizes = frame_settings.texture_sizes,
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 5 }
        },
        detail_top_left = {
            size = { 110, 100 },
            color = { 255, 255, 255, 255 },
            offset = { 0, 100, 2 }
        },
        detail_bottom_left = {
            size = { 110, 100 },
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 2 }
        },
        detail_top_right = {
            size = { 110, 100 },
            color = { 255, 255, 255, 255 },
            offset = { size[1] - 110, 100, 2 }
        },
        detail_bottom_right = {
            size = { 110, 100 },
            color = { 255, 255, 255, 255 },
            offset = { size[1] - 110, 0, 2 }
        },
        title_text = {
            size = { size[1], 48 },
            font_size = 36,
            dynamic_font_size = true,
            font_type = "hell_shark",
            vertical_alignment = "top",
            horizontal_alignment = "center",
            text_color = Colors.get_color_table_with_alpha("font_title", 255),
            offset = { 0, size[2] - 60, 3 }
        },
        title_text_shadow = {
            size = { size[1], 48 },
            font_size = 36,
            dynamic_font_size = true,
            font_type = "hell_shark",
            vertical_alignment = "top",
            horizontal_alignment = "center",
            text_color = Colors.get_color_table_with_alpha("black", 255),
            offset = { 2, size[2] - 62, 2 }
        },
        title_divider = {
            size = { 264, 32 },
            color = { 255, 255, 255, 255 },
            offset = { size[1] / 2 - 132, size[2] - 85, 1 }
        },

        detail_1_icon = {
            size = { 50, 50 },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { 125, 50, 2 }
        },
        detail_1_icon_shadow = {
            size = { 50, 50 },
            color = { 255, 0, 0, 0 },
            offset = { 127, 48, 1 }
        },
        detail_1_text = detail_text_style({ 125, 20, 2 }),
        detail_1_text_shadow = detail_text_shadow_style({ 127, 18, 1 }),
        detail_1_tooltip = {
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            grow_downwards = false,
            max_width = 300,
            offset = { 310, 110, 0 }
        },

        detail_2_icon = {
            size = { 50, 50 },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { size[1] / 2 - 25, 60, 2 }
        },
        detail_2_icon_shadow = {
            size = { 50, 50 },
            color = { 255, 0, 0, 0 },
            offset = { size[1] / 2 - 23, 58, 1 }
        },
        detail_2_text = detail_text_style({ size[1] / 2 - 25, 30, 2 }),
        detail_2_text_shadow = detail_text_shadow_style({ size[1] / 2 - 23, 28, 1 }),
        detail_2_tooltip = {
            vertical_alignment = "bottom",
            horizontal_alignment = "center",
            grow_downwards = false,
            max_width = 300,
            offset = { 0, 120, 0 }
        },

        detail_3_icon = {
            size = { 50, 50},
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { size[1] - 150, 50, 2 }
        },
        detail_3_icon_shadow = {
            size = { 50, 50},
            color = { 255, 0, 0, 0 },
            offset = { size[1] - 148, 48, 1 }
        },
        detail_3_text = detail_text_style({ size[1] - 150, 20, 2 }),
        detail_3_text_shadow = detail_text_shadow_style({ size[1] - 148, 18, 1 }),
        detail_3_tooltip = {
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            grow_downwards = false,
            max_width = 300,
            offset = { size[1] + 25, 110, 0 }
        }

    }

    return {
        element = element,
        content = content,
        style = style,
        offset = { 0, 0, 0 },
        scenegraph_id = scenegraph_id
    }

end

local frame_detail_widget_definitions = {

    frame_title_text = UIWidgets.create_simple_text("", "frame_title_text", nil, nil, frame_title_text_style),
    frame_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        { 1, 0 },
        { 0, 1 }
    }, "frame_detail_top_left"),
    frame_detail_top_center = UIWidgets.create_tiled_texture("frame_detail_top_center", "divider_skull_middle", { 64, 97 }),
    frame_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        { 0, 0 },
        { 1, 1 }
    }, "frame_detail_top_right"),

    frame_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        { 1, 1 },
        { 0, 0 }
    }, "frame_detail_bottom_left"),
    frame_detail_bottom_center = UIWidgets.create_tiled_texture("frame_detail_bottom_center", "divider_skull_middle_down", { 64, 97 }),
    frame_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        { 0, 1 },
        { 1, 0 }
    }, "frame_detail_bottom_right"),

}

local widget_definitions = {
    window_background = UIWidgets.create_rect_with_outer_frame("window_background", scenegraph_definition.window_background.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color)
}

local animation_definitions = {
    on_enter = {
        {
            name = "on_enter",
            start_progress = 0,
            end_progress = 0.6,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.alpha_multiplier = 0
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.alpha_multiplier = anim_progress

                local detail_panels = widgets.detail_panels
                for i, panel in ipairs(detail_panels) do
                    local anim_offset = math.min(i * 50 + 80, 300)
                    panel.offset[1] = math.floor(panel.default_offset[1] + anim_offset - (anim_offset * anim_progress))
                end

                ui_scenegraph.frame_detail_top_center.size[1] = scenegraph_definition.frame_detail_top_center.size[1] * anim_progress
                ui_scenegraph.frame_detail_bottom_center.size[1] = scenegraph_definition.frame_detail_bottom_center.size[1] * anim_progress

                ui_scenegraph.frame_title_text.local_position[2] = scenegraph_definition.frame_title_text.position[2] - 35 * (1 - anim_progress)
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    }
}

return {
    scenegraph_definition = scenegraph_definition,
    widget_definitions = widget_definitions,
    frame_detail_widget_definitions = frame_detail_widget_definitions,
    animation_definitions = animation_definitions,
    create_detail_panel = create_detail_panel
}