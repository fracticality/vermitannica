local mod = get_mod("vermitannica")

UIWidgets.create_console_panel_bottom_button = function (scenegraph_id, size, text, font_size, optional_offset, optional_horizontal_alignment)
    local new_marker_offset = {
        -19,
        -25,
        10
    }
    local marker_offset = {
        0,
        0,
        4
    }
    local selection_offset = {
        0,
        4,
        2
    }
    local shadow_offset = {
        2,
        3,
        3
    }

    local frame_settings = UIFrameSettings.menu_frame_12
    local edge_height = frame_settings.texture_sizes.vertical[1]

    if optional_offset then
        shadow_offset[1] = shadow_offset[1] + optional_offset[1]
        shadow_offset[2] = shadow_offset[2] + optional_offset[2]
        shadow_offset[3] = optional_offset[3] - 1
        selection_offset[1] = selection_offset[1] + optional_offset[1]
        selection_offset[2] = selection_offset[2] + optional_offset[2]
        selection_offset[3] = optional_offset[3] - 3
        marker_offset[1] = marker_offset[1] + optional_offset[1]
        marker_offset[2] = marker_offset[2] + optional_offset[2]
        marker_offset[3] = optional_offset[3] - 2
        new_marker_offset[1] = new_marker_offset[1] + optional_offset[1]
        new_marker_offset[2] = new_marker_offset[2] + optional_offset[2]
        new_marker_offset[3] = optional_offset[3] - 2
    end

    return {
        element = {
            passes = {
                {
                    pass_type = "hotspot",
                    content_id = "button_hotspot",
                    style_id = "button_hotspot"
                },
                {
                    style_id = "text_shadow",
                    pass_type = "text",
                    text_id = "text_field"
                },
                {
                    style_id = "text_hover",
                    pass_type = "text",
                    text_id = "text_field",
                    content_check_function = function (content)
                        return not content.button_hotspot.disable_button and (content.button_hotspot.is_hover or content.button_hotspot.is_selected)
                    end
                },
                {
                    style_id = "text",
                    pass_type = "text",
                    text_id = "text_field",
                    content_check_function = function (content)
                        return not content.button_hotspot.disable_button and not content.button_hotspot.is_hover and not content.button_hotspot.is_selected
                    end
                },
                {
                    style_id = "text_disabled",
                    pass_type = "text",
                    text_id = "text_field",
                    content_check_function = function (content)
                        return content.button_hotspot.disable_button
                    end
                },
                {
                    content_id = "selected_texture",
                    style_id = "selected_texture",
                    pass_type = "texture_uv",
                    content_check_function = function (content)
                        return not content.parent.button_hotspot.disable_button
                    end
                },
                {
                    texture_id = "frame",
                    style_id = "frame",
                    pass_type = "texture_frame",
                    content_check_function = function (content)
                        return not content.button_hotspot.disable_button
                    end
                },
                {
                    content_id = "marker",
                    style_id = "marker_left",
                    pass_type = "texture_uv"
                },
                {
                    texture_id = "marker_top_middle",
                    style_id = "marker_top_middle",
                    pass_type = "texture",
                    content_check_function = function (content)
                        return not content.button_hotspot.disable_button
                    end
                },
                {
                    texture_id = "marker_top_left",
                    style_id = "marker_top_left",
                    pass_type = "rotated_texture"
                },
                {
                    content_id = "marker",
                    style_id = "marker_right",
                    pass_type = "texture_uv"
                },
                {
                    content_id = "marker_top_right",
                    style_id = "marker_top_right",
                    pass_type = "texture_uv"
                }
            }
        },
        content = {
            button_hotspot = {},
            frame = frame_settings.texture,
            marker = {
                uvs = {
                    { 1, 1 },
                    { 0, 0 }
                },
                texture_id = "frame_detail_04"
            },
            marker_top_middle = "divider_01_top",
            marker_top_right = {
                uvs = {
                    { 0, 0 },
                    { 0.5, 1 }
                },
                texture_id = "frame_detail_04"
            },
            marker_top_left = "frame_detail_04",
            selected_texture = {
                uvs = {
                    { 1, 1 },
                    { 0, 0 }
                },
                texture_id = "hero_panel_selection_glow"
            },
            text_field = "",
            default_font_size = font_size
        },
        style = {
            button_hotspot = {
                size = { size[1] - edge_height * 2, size[2] - edge_height },
                offset = { edge_height, 0, 0 }
            },
            text = {
                word_wrap = false,
                upper_case = true,
                localize = false,
                vertical_alignment = "center",
                dynamic_font_size = true,
                font_type = "hell_shark_header",
                font_size = font_size,
                horizontal_alignment = optional_horizontal_alignment or "left",
                text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
                default_offset = optional_offset or {
                    0,
                    10,
                    4
                },
                offset = optional_offset or {
                    0,
                    5,
                    4
                },
                size = size
            },
            text_shadow = {
                word_wrap = false,
                upper_case = true,
                localize = false,
                vertical_alignment = "center",
                dynamic_font_size = true,
                font_type = "hell_shark_header",
                font_size = font_size,
                horizontal_alignment = optional_horizontal_alignment or "left",
                text_color = Colors.get_color_table_with_alpha("black", 255),
                default_offset = shadow_offset,
                offset = shadow_offset,
                size = size
            },
            text_hover = {
                word_wrap = false,
                upper_case = true,
                localize = false,
                vertical_alignment = "center",
                dynamic_font_size = true,
                font_type = "hell_shark_header",
                font_size = font_size,
                horizontal_alignment = optional_horizontal_alignment or "left",
                text_color = Colors.get_color_table_with_alpha("white", 255),
                default_offset = optional_offset or {
                    0,
                    10,
                    4
                },
                offset = optional_offset or {
                    0,
                    5,
                    4
                },
                size = size
            },
            text_disabled = {
                word_wrap = false,
                upper_case = true,
                localize = false,
                vertical_alignment = "center",
                dynamic_font_size = true,
                font_type = "hell_shark_header",
                font_size = font_size,
                horizontal_alignment = optional_horizontal_alignment or "left",
                text_color = Colors.get_color_table_with_alpha("gray", 50),
                default_offset = optional_offset or {
                    0,
                    10,
                    4
                },
                offset = optional_offset or {
                    0,
                    5,
                    4
                },
                size = size
            },
            selected_texture = {
                vertical_alignment = "bottom",
                horizontal_alignment = "center",
                color = Colors.get_color_table_with_alpha("font_title", 255),
                size = { size[1], 75 },
                offset = selection_offset
            },
            frame = {
                color = Colors.get_color_table_with_alpha("white", 255),
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                size = size,
                offset = { 0, 0, 3 }
            },
            marker_left = {
                vertical_alignment = "bottom",
                horizontal_alignment = "left",
                texture_size = { 55, 28 },
                color = Colors.get_color_table_with_alpha("white", 255),
                offset = {
                    marker_offset[1] - 26,
                    marker_offset[2],
                    marker_offset[3]
                }
            },
            marker_top_middle = {
                vertical_alignment = "top",
                horizontal_alignment = "center",
                color = Colors.get_color_table_with_alpha("white", 255),
                texture_size = { 264, 32 },
                offset = { 0, -16, marker_offset[3] }
            },
            marker_top_left = {
                vertical_alignment = "top",
                horizontal_alignment = "left",
                texture_size = { 27.5, 28 },
                uvs = {
                    { 0, 0 },
                    { 0.5, 1 }
                },
                angle = math.pi * 1.5,
                pivot = { 0, 0 },
                color = Colors.get_color_table_with_alpha("white", 255),
                offset = { marker_offset[1] + 27.5, marker_offset[2], marker_offset[3] }
            },
            marker_right = {
                vertical_alignment = "bottom",
                horizontal_alignment = "right",
                texture_size = {
                    55,
                    28
                },
                color = Colors.get_color_table_with_alpha("white", 255),
                offset = {
                    marker_offset[1] + 26,
                    marker_offset[2],
                    marker_offset[3]
                }
            },
            marker_top_right = {
                vertical_alignment = "top",
                horizontal_alignment = "right",
                texture_size = { 27.5, 28 },
                color = Colors.get_color_table_with_alpha("white", 255),
                offset = { marker_offset[1], marker_offset[2], marker_offset[3] }
            }
        },
        offset = {
            0,
            0,
            0
        },
        scenegraph_id = scenegraph_id
    }
end

local function create_hero_skin_widget_template(scenegraph_id, size)
    local frame_style = "menu_frame_09"
    local frame_settings = UIFrameSettings[frame_style]

    local hover_frame_style = "menu_frame_12"
    local hover_frame_settings = UIFrameSettings[hover_frame_style]

    local selection_frame_style = "frame_outer_glow_01"
    local selection_frame_settings = UIFrameSettings[selection_frame_style]
    local selection_frame_width = selection_frame_settings.texture_sizes.horizontal[2]

    return {
        element = {
            passes = {
                {
                    pass_type = "hotspot",
                    content_id = "button_hotspot"
                },
                {
                    pass_type = "texture",
                    texture_id = "rarity_texture",
                    style_id = "rarity_texture"
                },
                {
                    pass_type = "texture",
                    texture_id = "icon",
                    style_id = "icon"
                },
                {
                    pass_type = "texture_frame",
                    style_id = "frame",
                    texture_id = "frame",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return not hotspot.is_selected and not hotspot.is_hover
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "hover_frame",
                    texture_id = "hover_frame",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return hotspot.is_hover or hotspot.is_selected
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "selection_frame",
                    texture_id = "selection_frame",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return hotspot.is_selected
                    end
                },
                {
                    pass_type = "rect",
                    style_id = "overlay",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return not hotspot.is_selected and not hotspot.is_hover
                    end
                },
                {
                    pass_type = "vermitannica_tooltip",
                    style_id = "item_tooltip",
                    text_id = "item_tooltip",
                    item_id = "item",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return hotspot.is_hover and content.item
                    end
                }
            }
        },
        content = {
            button_hotspot = {},
            icon = "icons_placeholder",
            rarity_texture = "icons_placeholder",
            frame = frame_settings.texture,
            hover_frame = hover_frame_settings.texture,
            selection_frame = selection_frame_settings.texture,
            item_tooltip = "tooltip_text",
        },
        style = {
            overlay = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                texture_size = size,
                color = { 100, 0, 0, 0 },
                offset = { 0, 0, 2 }
            },
            icon = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                texture_size = size,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 1 }
            },
            rarity_texture = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                texture_size = size,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 0 }
            },
            frame = {
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 4 }
            },
            hover_frame = {
                texture_size = hover_frame_settings.texture_size,
                texture_sizes = hover_frame_settings.texture_sizes,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 4 }
            },
            selection_frame = {
                size = { size[1] + selection_frame_width * 2, size[2] + selection_frame_width * 2 },
                texture_size = selection_frame_settings.texture_size,
                texture_sizes = selection_frame_settings.texture_sizes,
                color = { 255, 255, 255, 255 },
                offset = { -selection_frame_width, -selection_frame_width, 4 },
            },
            item_tooltip = {
                font_type = "hell_shark",
                localize = true,
                font_size = 18,
                horizontal_alignment = "left",
                vertical_alignment = "top",
                max_width = 500,
                size = { 80, 80 },
                offset = { 0, 0, 0 },
                text_color = Colors.get_color_table_with_alpha("white", 255),
                line_colors = {
                    Colors.get_color_table_with_alpha("font_title", 255),
                    Colors.get_color_table_with_alpha("white", 255)
                }
            }
        },
        scenegraph_id = scenegraph_id,
        offset = { 0, 0, 0 }
    }
end

local function create_widget_template(scenegraph_id, size, frame_style, hover_frame_style)
    frame_style = frame_style or "menu_frame_09"
    local frame_settings = UIFrameSettings[frame_style]

    hover_frame_style = hover_frame_style or "menu_frame_12"
    local hover_frame_settings = UIFrameSettings[hover_frame_style]

    local selection_frame_style = "frame_outer_glow_01"
    local selection_frame_settings = UIFrameSettings[selection_frame_style]
    local selection_frame_width = selection_frame_settings.texture_sizes.horizontal[2]

    local widget = {
        element = {
            passes = {
                {
                    pass_type = "hotspot",
                    content_id = "button_hotspot"
                },
                {
                    pass_type = "texture",
                    texture_id = "icon",
                    style_id = "icon"
                },
                {
                    pass_type = "texture",
                    texture_id = "icon_background",
                    style_id = "icon_background"
                },
                {
                    pass_type = "texture",
                    texture_id = "icon_extra",
                    style_id = "icon_extra",
                    content_check_function = function (content, style)
                        if content.is_lord or content.is_boss then
                            if content.is_lord then
                                content.icon_extra = "boss_icon"
                            elseif content.is_boss then
                                content.icon_extra = "friends_icon_join"
                            end

                            if content.button_hotspot.is_hover or content.button_hotspot.is_selected then
                                style.color = { 255, 255, 255, 255 }
                            else
                                style.color = { 255, 100, 100, 100 }
                            end

                            return true
                        end
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "frame",
                    texture_id = "frame",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return not hotspot.is_selected and not hotspot.is_hover
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "hover_frame",
                    texture_id = "hover_frame",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return hotspot.is_hover or hotspot.is_selected
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "selection_frame",
                    texture_id = "selection_frame",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return hotspot.is_selected
                    end
                },
                {
                    pass_type = "rect",
                    style_id = "overlay",
                    content_check_function = function (content)
                        local hotspot = content.button_hotspot

                        return not hotspot.is_selected and not hotspot.is_hover
                    end
                },
                {
                    pass_type = "rect",
                    style_id = "rect"
                }
            }
        },
        content = {
            button_hotspot = {},
            icon = "icons_placeholder",
            icon_background = "icon_bg_default",
            icon_extra = "",
            frame = frame_settings.texture,
            hover_frame = hover_frame_settings.texture,
            selection_frame = selection_frame_settings.texture
        },
        style = {
            rect = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                texture_size = size,
                color = { 200, 0, 0, 0 },
                offset = { 0, 0, 0 }
            },
            icon = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                texture_size = size,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 4 }
            },
            icon_background = {
                texture_size = size,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 2 }
            },
            icon_extra = {
                vertical_alignment = "top",
                horizontal_alignment = "left",
                texture_size = { 30, 30 },
                offset = { -6, 10, 6 },
                color = { 255, 100, 100, 100 }
            },
            overlay = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                texture_size = size,
                color = { 100, 0, 0, 0 },
                offset = { 0, 0, 4 }
            },
            frame = {
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 6 }
            },
            hover_frame = {
                texture_size = hover_frame_settings.texture_size,
                texture_sizes = hover_frame_settings.texture_sizes,
                color = { 255, 255, 255, 255 },
                offset = { 0, 0, 6 }
            },
            selection_frame = {
                size = { size[1] + selection_frame_width * 2, size[2] + selection_frame_width * 2 },
                texture_size = selection_frame_settings.texture_size,
                texture_sizes = selection_frame_settings.texture_sizes,
                color = { 255, 255, 255, 255 },
                offset = { -selection_frame_width, -selection_frame_width, 0 }
            }
        },
        offset = { 0, 0, 0 },
        scenegraph_id = scenegraph_id
    }

    return widget
end

local function create_attribute_template(scenegraph_id, size)
    return {
        element = {
            passes = {
                {
                    pass_type = "text",
                    style_id = "attribute_name_text",
                    text_id = "attribute_name_text"
                },
                {
                    pass_type = "text",
                    style_id = "attribute_value_text",
                    text_id = "attribute_value_text"
                },
                {
                    pass_type = "rect",
                    style_id = "hover",
                    content_check_function = function (content)
                        return content.highlight
                    end
                }
            }
        },
        content = {
            attribute_name_text = "",
            attribute_value_text = "",
        },
        style = {
            attribute_name_text = {
                localize = false,
                use_shadow = false,
                text_alignment = "left",
                vertical_alignment = "center",
                horizontal_alignment = "left",
                word_wrap = false,
                dynamic_font_size = false,
                font_size = 24,
                font_type = "hell_shark",
                text_color = Colors.get_color_table_with_alpha("font_title", 255),
                offset = { 0, 0, UILayer.ingame_player_list + 10 }
            },
            attribute_value_text = {
                localize = false,
                use_shadow = false,
                text_alignment = "right",
                vertical_alignment = "center",
                horizontal_alignment = "right",
                word_wrap = false,
                dynamic_font_size = false,
                font_size = 20,
                font_type = "hell_shark",
                text_color = Colors.get_color_table_with_alpha("font_default", 255),
                offset = { 0, 0, UILayer.ingame_player_list + 10 }
            },
            hover = {
                size = { size[1] + 30, size[2] },
                color = { 100, 0, 0, 0 },
                offset = { -15, 0, 0 }
            },
        },
        scenegraph_id = scenegraph_id,
        offset = { 0, 0, 0 }
    }
end

local function create_attributes_panel(scenegraph_id, size)
    local panel_color = UISettings.console_menu_rect_color
    local frame_settings = UIFrameSettings.frame_outer_fade_02
    local inset_frame_settings = UIFrameSettings.menu_frame_06
    local edge_height = frame_settings.texture_sizes.horizontal[2]
    local frame_size = {
        size[1] + edge_height * 2,
        size[2] + edge_height * 2
    }

    return {
        element = {
            passes = {
                {
                    pass_type = "rect",
                    style_id = "background"
                },
                {
                    pass_type = "texture_frame",
                    style_id = "background_frame",
                    texture_id = "background_frame"
                },
                {
                    pass_type = "rect",
                    style_id = "inset_background"
                },
                {
                    pass_type = "texture_frame",
                    style_id = "inset_frame",
                    texture_id = "inset_frame"
                },
                {
                    pass_type = "text",
                    style_id = "header_text",
                    text_id = "header_text"
                },
                {
                    pass_type = "texture",
                    style_id = "divider",
                    texture_id = "divider"
                }
            }
        },
        content = {
            background_frame = frame_settings.texture,
            inset_frame = inset_frame_settings.texture,
            header_text = mod:localize("attributes"),
            divider = "divider_01_top"
        },
        style = {
            background = {
                color = UISettings.console_menu_rect_color,
                offset = { 0, 0, 0 },
            },
            background_frame = {
                color = panel_color,
                size = frame_size,
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                offset = { -edge_height, -edge_height, 0 }
            },
            inset_background = {
                color = UISettings.console_menu_rect_color,
                size = { 400, 500 },
                offset = { 0, 0, 0 }
            },
            inset_frame = {
                color = { 255, 255, 255, 255 },
                size = { 400, 500 },
                texture_size = inset_frame_settings.texture_size,
                texture_sizes = inset_frame_settings.texture_sizes,
                offset = { 0, 0, 0 }
            },
            divider = {
                color = { 255, 255, 255, 255 },
                size = { 264, 32 },
                offset = { 61, 400, 3 }
            },
            header_text = {
                localize = false,
                use_shadow = true,
                text_alignment = "center",
                vertical_alignment = "top",
                horizontal_alignment = "center",
                word_wrap = true,
                dynamic_font_size = true,
                font_size = 36,
                font_type = "hell_shark_header",
                text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
                offset = { 0, -30, 2 }
            }
        },
        scenegraph_id = scenegraph_id,
        offset = { 0, 0, 0 }
    }
end

local function create_lore_panel(scenegraph_id, size)
    local panel_color = UISettings.console_menu_rect_color
    local frame_settings = UIFrameSettings.frame_outer_fade_02
    local inset_tabs_background = "button_bg_01"
    local inset_tabs_background_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(inset_tabs_background)
    local inset_frame_settings = UIFrameSettings.menu_frame_09
    local edge_height = frame_settings.texture_sizes.horizontal[2]
    local frame_size = {
        size[1] + edge_height * 2,
        size[2] + edge_height * 2
    }

    return {
        element = {
            passes = {
                {
                    pass_type = "rect",
                    style_id = "background",
                },
                {
                    pass_type = "texture_frame",
                    style_id = "background_frame",
                    texture_id = "background_frame"
                },
                {
                    pass_type = "rect",
                    style_id = "inset_background"
                },
                {
                    pass_type = "texture_uv",
                    style_id = "inset_tabs_background",
                    content_id = "inset_tabs_background"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider",
                    texture_id = "inset_tabs_divider"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider_left",
                    texture_id = "inset_tabs_divider_left"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider_1",
                    texture_id = "inset_tabs_divider_vertical"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider_1_bottom",
                    texture_id = "inset_tabs_divider_bottom"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider_2_bottom",
                    texture_id = "inset_tabs_divider_bottom"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider_2",
                    texture_id = "inset_tabs_divider_vertical"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_tabs_divider_right",
                    texture_id = "inset_tabs_divider_right"
                },
                {
                    pass_type = "rect",
                    style_id = "inset_tabs_overlay"
                },
                {
                    pass_type = "texture_frame",
                    style_id = "inset_frame",
                    texture_id = "inset_frame"
                },
                {
                    pass_type = "text",
                    style_id = "lore_string",
                    text_id = "lore_string"
                },
                {
                    pass_type = "text",
                    style_id = "lore_string_shadow",
                    text_id = "lore_string"
                },
                {
                    pass_type = "texture_uv",
                    style_id = "inset_frame_top_right",
                    content_id = "inset_frame_top_right"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_frame_top_left",
                    texture_id = "inset_frame_top_left"
                },
                {
                    pass_type = "text",
                    style_id = "header_text",
                    text_id = "header_text"
                },
                {
                    pass_type = "text",
                    style_id = "header_text_shadow",
                    text_id = "header_text"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_frame_top_middle_1",
                    texture_id = "inset_frame_top_middle"
                },
                {
                    pass_type = "texture",
                    style_id = "inset_frame_top_middle_2",
                    texture_id = "inset_frame_top_middle"
                }
            }
        },
        content = {
            background_frame = frame_settings.texture,
            inset_frame = inset_frame_settings.texture,
            inset_frame_top_left = "frame_detail_03",
            inset_frame_top_right = {
                uvs = {
                    { 1, 0 },
                    { 0, 1 }
                },
                texture_id = "frame_detail_03"
            },
            inset_tabs_background = {
                uvs = {
                    {
                        0,
                        1 - math.min(900 / inset_tabs_background_settings.size[2], 1)
                    },
                    {
                        math.min(590 / inset_tabs_background_settings.size[1], 1),
                        1
                    }
                },
                texture_id = inset_tabs_background
            },
            inset_tabs_divider = "menu_frame_09_divider",
            inset_tabs_divider_vertical = "menu_frame_09_divider_vertical",
            inset_tabs_divider_left = "menu_frame_09_divider_left",
            inset_tabs_divider_bottom = "menu_frame_09_divider_bottom",
            inset_tabs_divider_right = "menu_frame_09_divider_right",
            header_text = "",
            lore_string = "",
            inset_frame_top_middle = "divider_01_top",
        },
        style = {
            background = {
                color = UISettings.console_menu_rect_color,
                offset = { 0, 0, 0 },
            },
            background_frame = {
                color = panel_color,
                size = frame_size,
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                offset = { -edge_height, -edge_height, 0 }
            },
            inset_background = {
                color = UISettings.console_menu_rect_color,
                size = { 590, 900 },
                offset = { 30, 80, 0 }
            },
            inset_tabs_background = {
                color = { 255, 255, 255, 255 },
                size = { 590, 50 },
                offset = { 30, 930, 0 }
            },
            inset_tabs_overlay = {
                color = { 80, 0, 0, 0 },
                size = { 590, 50 },
                offset = { 30, 930, 1 }
            },
            inset_frame = {
                color = { 255, 255, 255, 255 },
                size = { 590, 900 },
                texture_size = inset_frame_settings.texture_size,
                texture_sizes = inset_frame_settings.texture_sizes,
                offset = { 30, 80, 5 }
            },
            inset_tabs_divider = {
                color = { 255, 255, 255, 255 },
                size = { 590, 5 },
                offset = { 30, 930, 5 }
            },
            inset_tabs_divider_left = {
                color = { 255, 255, 255, 255 },
                size = { 9, 17 },
                offset = { 33, 924, 6 }
            },
            inset_tabs_divider_1 = {
                color = { 255, 255, 255, 255 },
                size = { 5, 50 },
                offset = { 190, 930, 4 }
            },
            inset_tabs_divider_1_bottom = {
                color = { 255, 255, 255, 255 },
                size = { 17, 9 },
                offset = { 184, 933, 5 }
            },
            inset_tabs_divider_2_bottom = {
                color = { 255, 255, 255, 255 },
                size = { 17, 9 },
                offset = { 454, 933, 5 }
            },
            inset_tabs_divider_2 = {
                color = { 255, 255, 255, 255 },
                size = { 5, 50 },
                offset = { 460, 930, 4 }
            },
            inset_tabs_divider_right = {
                size = { 9, 17 },
                offset = { 608, 924, 6 }
            },
            inset_frame_top_left = {
                color = { 255, 255, 255, 255 },
                size = { 230, 59 },
                offset = { 20, 935, 6 }
            },
            inset_frame_top_right = {
                color = { 255, 255, 255, 255 },
                size = { 230, 59 },
                offset = { 400, 935, 6 }
            },
            inset_frame_top_middle_1 = {
                color = { 255, 255, 255, 255 },
                size = { 264, 32 },
                offset = { 118, 962, 7 }
            },
            inset_frame_top_middle_2 = {
                color = { 255, 255, 255, 255 },
                size = { 264, 32 },
                offset = { 268, 962, 8 }
            },
            header_text = {
                localize = false,
                use_shadow = true,
                vertical_alignment = "bottom",
                horizontal_alignment = "center",
                word_wrap = true,
                font_size = 20,
                font_type = "hell_shark_header",
                text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
                offset = { 0, 860, 2 }
            },
            header_text_shadow = {
                localize = false,
                vertical_alignment = "bottom",
                horizontal_alignment = "center",
                word_wrap = true,
                font_size = 20,
                font_type = "hell_shark_header",
                text_color = Colors.get_color_table_with_alpha("black", 255),
                offset = { 2, 858, 1 }
            },
            lore_string = {
                localize = false,
                text_alignment = "left",
                vertical_alignment = "top",
                horizontal_alignment = "left",
                word_wrap = true,
                font_size = 20,
                font_type = "hell_shark",
                text_color = Colors.get_color_table_with_alpha("font_default", 255),
                size = { 560, 850 },
                offset = { 45, 0, 2 }
            },
            lore_string_shadow = {
                localize = false,
                text_alignment = "left",
                vertical_alignment = "top",
                horizontal_alignment = "left",
                word_wrap = true,
                font_size = 20,
                font_type = "hell_shark",
                text_color = Colors.get_color_table_with_alpha("black", 255),
                size = { 560, 850 },
                offset = { 47, -2, 1 }
            }
        },
        scenegraph_id = scenegraph_id,
        offset = { 0, 0, 0 }

    }
end

local create_tray = function (scenegraph_id, size, icon_size, add_extra_passes)

    local panel_color = UISettings.console_menu_rect_color
    local frame_settings = UIFrameSettings.frame_outer_fade_02
    local edge_height = frame_settings.texture_sizes.horizontal[2]
    local frame_size = {
        size[1] + edge_height * 2,
        size[2] + edge_height * 2
    }

    local widget = {
        element = {
            passes = {
                {
                    pass_type = "hotspot",
                    content_id = "button_hotspot",
                    style_id = "button_hotspot"
                },
                {
                    pass_type = "rect",
                    style_id = "background",
                    content_check_function = function (content)
                        return content.button_hotspot.is_hover and not content.active
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "background_frame",
                    texture_id = "background_frame",
                    content_check_function = function (content)
                        return content.button_hotspot.is_hover and not content.active
                    end
                },
                {
                    pass_type = "texture_frame",
                    style_id = "background_frame_active",
                    texture_id = "background_frame_active",
                    content_check_function = function (content)
                        return content.active
                    end
                },
                {
                    pass_type = "texture",
                    style_id = "icon",
                    texture_id = "icon",
                },
                {
                    pass_type = "rect",
                    style_id = "background_active",
                    content_check_function = function (content)
                        return content.active
                    end
                },
                {
                    pass_type = "text",
                    text_id = "title_text",
                    style_id = "title_text"
                },
                {
                    pass_type = "texture",
                    texture_id = "text_divider",
                    style_id = "text_divider"
                },
                {
                    pass_type = "text",
                    text_id = "sub_title_text",
                    style_id = "sub_title_text"
                }


            }
        },
        content = {
            button_hotspot = {},
            background_frame = frame_settings.texture,
            background_frame_active = frame_settings.texture,
            icon = "portrait_frame_hero_selection",
            title_text = "",
            text_divider = "infoslate_frame_02_horizontal",
            sub_title_text = "",

            edge_height = edge_height
        },
        style = {
            button_hotspot = {
                color = { 150, 255, 0, 0 },
                offset = { 5, 0, 0 },
                size = { size[1] - 10, size[2] - 5 }
            },
            title_text = {
                localize = true,
                text_alignment = "right",
                vertical_alignment = "center",
                horizontal_alignment = "left",
                word_wrap = true,
                font_size = 28,
                font_type = "hell_shark",
                text_color = Colors.get_color_table_with_alpha("font_title", 255),
                offset = { icon_size[1] + 45, 20, 8 }
            },
            text_divider = {
                color = { 255, 255, 255, 255 },
                vertical_alignment = "center",
                horizontal_alignment = "center",
                size = { size[1] / 2, 4 },
                offset = { icon_size[1] + 45, size[2] / 2, 8 }
            },
            sub_title_text = {
                localize = true,
                text_alignment = "left",
                vertical_alignment = "center",
                horizontal_alignment = "left",
                word_wrap = true,
                font_size = 24,
                font_type = "hell_shark",
                text_color = { 255, 255, 255, 255 },
                offset = { icon_size[1] + 45, -15, 8 }
            },
            background = {
                color = UISettings.console_menu_rect_color,
                offset = { 0, 0, 0 },
                size = size
            },
            background_frame = {
                color = panel_color,
                size = frame_size,
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                offset = { -edge_height, -edge_height, 0 }
            },
            icon = {
                size = icon_size,
                offset = { 30, 25, 8 }
            },
            background_active = {
                color = UISettings.console_menu_rect_color,
                offset = { 0, 0, 0 },
                size = { size[1], 0 }
            },
            background_frame_active = {
                color = panel_color,
                size = { frame_size[1], 0 },
                texture_size = frame_settings.texture_size,
                texture_sizes = frame_settings.texture_sizes,
                offset = { -edge_height, -edge_height, 0 }
            }
        },
        scenegraph_id = scenegraph_id,
        offset = { 0, 0, 0 }
    }

    if add_extra_passes then
        local content = widget.content
        local style = widget.style

        local passes = widget.element.passes
        local pass = {
            pass_type = "texture",
            texture_id = "icon_frame",
            style_id = "icon_frame"
        }
        passes[#passes + 1] = pass

        local texture_id = pass.texture_id
        local style_id = pass.style_id

        content[texture_id] = "item_frame"
        style[style_id] = {
            size = { 80, 80 },
            color = { 255, 255, 255, 255 },
            offset = { style.icon.offset[1] - 2.5, style.icon.offset[2] - 2.5, style.icon.offset[3] + 2 }
        }

        pass = {
            pass_type = "texture",
            texture_id = "icon_background",
            style_id = "icon_background"
        }
        passes[#passes + 1] = pass

        texture_id = pass.texture_id
        style_id = pass.style_id

        content[texture_id] = "icon_bg_default"
        style[style_id] = {
            size = { 80, 80 },
            color = { 255, 255, 255, 255 },
            offset = { style.icon.offset[1] - 2.5, style.icon.offset[2] - 2.5, style.icon.offset[3] - 2 }
        }

    end

    return widget
end

local create_thin_text_button = function (scenegraph_id, size, text, text_style)
    local text_hover_style = table.clone(text_style)
    text_hover_style.text_color = Colors.get_color_table_with_alpha("white", 255)

    local text_shadow_style = table.clone(text_style)
    local text_shadow_style_color = text_style.shadow_color or { 255, 0, 0, 0 }
    text_shadow_style.text_color = text_shadow_style_color
    text_shadow_style.offset = { 2, -2, -1 }

    local element = {
        passes = {
            {
                style_id = "button",
                pass_type = "hotspot",
                content_id = "button_hotspot"
            },
            --{
            --    pass_type = "rect",
            --    style_id = "button"
            --},
            {
                pass_type = "texture",
                style_id = "hover",
                texture_id = "hover",
                content_check_function = function (content)
                    local hotspot = content.button_hotspot

                    return hotspot.is_hover or hotspot.is_selected
                end
            },
            {
                pass_type = "text",
                style_id = "text",
                text_id = "text"
            },
            {
                pass_type = "text",
                style_id = "text_hover",
                text_id = "text",
                content_check_function = function (content)
                    local hotspot = content.button_hotspot

                    return hotspot.is_hover or hotspot.is_selected
                end
            },
            {
                pass_type = "text",
                style_id = "text_shadow",
                text_id = "text"
            }
        }
    }
    local content = {
        hover = "button_state_default_2",
        button_hotspot = {},
        text = text
    }
    local style = {
        button = {
            color = Colors.get_color_table_with_alpha("console_menu_rect", 125),
            offset = { 0, 0, 1 }
        },
        hover = {
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 1 }
        },
        text = text_style,
        text_hover = text_hover_style,
        text_shadow = text_shadow_style
    }
    local widget = {
        element = element,
        content = content,
        style = style,
        offset = { 0, 0, 0 },
        scenegraph_id = scenegraph_id
    }

    return widget
end

local create_thin_button = function (scenegraph_id, texture, texture_size)

    local frame_settings = UIFrameSettings.menu_frame_12
    local element = {
        passes = {
            {
                pass_type = "hotspot",
                content_id = "button_hotspot"
            },
            {
                pass_type = "rect",
                style_id = "button"
            },
            {
                pass_type = "texture_frame",
                style_id = "frame",
                texture_id = "frame"
            },
            {
                pass_type = "texture",
                style_id = "icon",
                texture_id = "icon",
                content_check_function = function (content)
                    return not content.button_hotspot.is_hover
                end
            },
            {
                pass_type = "texture",
                style_id = "icon_hover",
                texture_id = "icon",
                content_check_function = function (content)
                    return content.button_hotspot.is_hover or content.button_hotspot.is_selected
                end
            },
            {
                pass_type = "texture",
                style_id = "hover",
                texture_id = "hover",
                content_check_function = function (content)
                    return content.button_hotspot.is_hover or content.button_hotspot.is_selected
                end
            }
        }
    }
    local content = {
        hover = "button_state_default_2",
        icon = texture,
        button_hotspot = {},
        frame = frame_settings.texture
    }
    local style = {
        button = {
            color = Colors.get_color_table_with_alpha("black", 200),
            offset = { 0, 0, 0 }
        },
        icon = {
            color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = ( texture_size and { texture_size[1] / 4, texture_size[2] / 4, 4 } ) or { 0, 0, 4 },
            size = texture_size or { 60, 60 }
        },
        icon_hover = {
            color = Colors.get_color_table_with_alpha("white", 255),
            offset = ( texture_size and { texture_size[1] / 4, texture_size[2] / 4, 4 } ) or { 0, 0, 4 },
            size = texture_size or { 60, 60 }
        },
        frame = {
            texture_size = frame_settings.texture_size,
            texture_sizes = frame_settings.texture_sizes,
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 3 }
        },
        hover = {
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 1 }
        }
    }
    local widget = {
        element = element,
        content = content,
        style = style,
        offset = { 0, 0, 0 },
        scenegraph_id = scenegraph_id
    }

    return widget

end

local scenegraph_definition = {
    background = {
        vertical_alignment = "center",
        horizontal_alignment = "center",
        scale = "fit",
        position = { 0, 0, UILayer.ingame_player_list },
        size = { 1920, 1080 }
    },

    viewport = {
        parent = "background",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = { 1000, 840 },
        position = { 0, 0, 0}
    },

    exit_button = {
        vertical_alignment = "top",
        horizontal_alignment = "right",
        parent = "background",
        size = { 60, 60 },
        position = { -15, -15, UILayer.ingame_player_list + 2 },
    },
    options_button = {
        vertical_alignment = "center",
        horizontal_alignment = "center",
        parent = "exit_button",
        size = { 60, 60 },
        position = { -75, 0, 0 }
    },
    hero_browser = {
        vertical_alignment = "top",
        horizontal_alignment = "left",
        parent = "background",
        size = { 210, 60 },
        position = { 15, -15, 0 }
    },
    browser_back_button = {
        vertical_alignment = "top",
        horizontal_alignment = "left",
        parent = "hero_browser",
        size = { 0, 0 },
        position = { 40, -100, 3 }
    },
    enemy_browser = {
        vertical_alignment = "center",
        horizontal_alignment = "center",
        parent = "hero_browser",
        size = { 210, 60 },
        position = { 225, 0, 0 }
    },

    current_state_text = {
        parent = "top_panel",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        size = { 300, 50 },
        position = { 0, 0, 1 }
    },

    career_tray = {
        parent = "background",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        position = { -(476 + 60), 0, 0 },
        size = { 480, 120 }
    },
    weapon_tray = {
        parent = "background",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        position = { 0, 0, 0 },
        size = { 600, 120 }
    },
    enemy_tray = {
        parent = "background",
        vertical_alignment = "bottom",
        horizontal_alignment = "center",
        position = { 476 + 60, 0, 0 },
        size = { 480, 120 }
    },

    career_icon_template = {
        parent = "career_tray",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        position = { 0, 65, 5 },
        size = { 60, 70 }
    },
    weapon_icon_template = {
        parent = "weapon_tray",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        position = { 0, 65, 5 },
        size = { 75, 75 }
    },
    enemy_icon_template = {
        parent = "enemy_tray",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        position = { 0, 65, 5 },
        size = { 60, 70 }
    },

    hero_skin_template = {
        parent = "hero_browser_panel",
        vertical_alignment = "bottom",
        horizontal_alignment = "left",
        size = { 100, 100 },
        position = { 30, 80, 1 }
    },

    bottom_panel = {
        vertical_alignment = "bottom",
        scale = "fit_width",
        size = { 1920, 80 },
        position = { 0, 0, UILayer.ingame_player_list + 1 }
    },
    top_panel = {
        vertical_alignment = "top",
        scale = "fit_width",
        size = { 1920, 80 },
        position = { 0, 0, UILayer.ingame_player_list + 1 }
    },
    panel_edge = {
        vertical_alignment = "bottom",
        parent = "bottom_panel",
        scale = "fit_width",
        size = { 1920, 4 },
        position = { 0, 0, 2 }
    },

    enemy_browser_panel = {
        horizontal_alignment = "left",
        scale = "fit_height",
        parent = "background",
        size = { 650, 1080 },
        position = { 0, 0, 1 }
    },
    enemy_sub_browser_back_button = {
        vertical_alignment = "top",
        horizontal_alignment = "right",
        parent = "enemy_browser_panel",
        size = { 0, 0 },
        position = { -45, -35, 3 }
    },

    hero_browser_panel = {
        horizontal_alignment = "right",
        scale = "fit_height",
        parent = "background",
        size = { 650, 1080 },
        position = { 0, 0, 1 }
    },
    hero_sub_browser_back_button = {
        vertical_alignment = "top",
        horizontal_alignment = "left",
        parent = "hero_browser_panel",
        size = { 0, 0 },
        position = { 45, -35, 3 }
    },
    hero_browser_skins_button = {
        parent = "hero_browser_panel",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = { 160, 50 },
        position = { 30, -100, 1 }
    },
    hero_browser_hats_button = {
        parent = "hero_browser_panel",
        vertical_alignment = "top",
        horizontal_alignment = "right",
        size = { 160, 50 },
        position = { -30, -100, 1 }
    },
    hero_browser_weapon_skins_button = {
        parent = "hero_browser_panel",
        vertical_alignment = "top",
        horizontal_alignment = "center",
        size = { 270, 50 },
        position = { 0, -100, 1 }
    },

    hero_attributes_panel = {
        vertical_alignment = "center",
        horizontal_alignment = "left",
        parent = "enemy_browser_panel",
        size = { 400, 500 },
        position = { 0, 0, 0 }
    },
    hero_attribute_base = {
        vertical_alignment = "top",
        horizontal_alignment = "center",
        parent = "hero_attributes_panel",
        size = { 370, 35 },
        position = { 0, -100, 0 }
    },
    enemy_attributes_panel = {
        vertical_alignment = "center",
        horizontal_alignment = "right",
        parent = "hero_browser_panel",
        size = { 400, 500 },
        position = { 0, 0, 0 }
    },
    enemy_attribute_base = {
        vertical_alignment = "top",
        horizontal_alignment = "center",
        parent = "enemy_attributes_panel",
        size = { 370, 35 },
        position = { 0, -100, 0 }
    },
}

local thin_button_text_style = {
    use_shadow = true,
    upper_case = false,
    localize = false,
    font_size = 32,
    vertical_alignment = "center",
    horizontal_alignment = "center",
    dynamic_font_size = true,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
    offset = { 0, -3, 2 }
}

local title_text_style = {
    use_shadow = true,
    upper_case = true,
    localize = false,
    font_size = 54,
    vertical_alignment = "center",
    horizontal_alignment = "center",
    --dynamic_font_size = true,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
    offset = { 0, 0, 2 }
}

local current_state_text_style = {
    use_shadow = true,
    upper_case = true,
    localize = false,
    font_size = 42,
    vertical_alignment = "top",
    horizontal_alignment = "right",
    dynamic_font_size = true,
    font_type = "hell_shark_header",
    text_color = Colors.get_color_table_with_alpha("font_default", 255),
    offset = { 0, 0, 2 }
}

local panel_color = UISettings.console_menu_rect_color

local widget_definitions = {
    bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
        { 0, 1 },
        { 1, 0 }
    }, "bottom_panel", nil, nil, panel_color),
    top_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
        { 1, 0},
        { 0, 1 }
    }, "top_panel", nil, nil, panel_color),
    panel_edge = UIWidgets.create_tiled_texture("panel_edge", "menu_frame_04_divider", {
        1,
        4
    }),

    current_state_text = UIWidgets.create_simple_text("", "current_state_text", nil, nil, title_text_style),

    options_button = create_thin_button("options_button", "cogwheel_small", { 40, 40 }),
    exit_button = create_thin_button("exit_button", "friends_icon_close"),
    hero_browser = create_thin_text_button("hero_browser", scenegraph_definition.hero_browser.size, mod:localize("hero_browser"), thin_button_text_style),
    browser_back_button = UIWidgets.create_layout_button("browser_back_button", "layout_button_back", "layout_button_back_glow"),
    enemy_browser = create_thin_text_button("enemy_browser", scenegraph_definition.enemy_browser.size, mod:localize("enemy_browser"), thin_button_text_style),

    career_tray_button = UIWidgets.create_console_panel_bottom_button("career_tray", scenegraph_definition.career_tray.size, "change career", 32, nil, "center"),
    weapon_tray_button = UIWidgets.create_console_panel_bottom_button("weapon_tray", scenegraph_definition.weapon_tray.size, "change weapon", 32, nil, "center"),
    enemy_tray_button = UIWidgets.create_console_panel_bottom_button("enemy_tray", scenegraph_definition.enemy_tray.size, "change enemy", 32, nil, "center"),

    --hero_attributes_panel  = create_attributes_panel("hero_attributes_panel", scenegraph_definition.hero_attributes_panel.size),
    --enemy_attributes_panel = create_attributes_panel("enemy_attributes_panel", scenegraph_definition.enemy_attributes_panel.size),
    hero_browser_panel = create_lore_panel("hero_browser_panel", scenegraph_definition.hero_browser_panel.size),
    enemy_browser_panel = create_lore_panel("enemy_browser_panel", scenegraph_definition.enemy_browser_panel.size),
    enemy_sub_browser_back_button = UIWidgets.create_layout_button("enemy_sub_browser_back_button", "layout_button_back", "layout_button_back_glow"),
    hero_sub_browser_back_button = UIWidgets.create_layout_button("hero_sub_browser_back_button", "layout_button_back", "layout_button_back_glow"),
    hero_browser_skins_button = create_thin_text_button("hero_browser_skins_button", scenegraph_definition.hero_browser_skins_button.size, mod:localize("skins"), thin_button_text_style),
    hero_browser_hats_button = create_thin_text_button("hero_browser_hats_button", scenegraph_definition.hero_browser_hats_button.size, mod:localize("hats"), thin_button_text_style),
    hero_browser_weapon_skins_button = create_thin_text_button("hero_browser_weapon_skins_button", scenegraph_definition.hero_browser_weapon_skins_button.size, mod:localize("weapon_skins"), thin_button_text_style),
}

local tray_widgets = {
    career_tray = create_tray("career_tray", scenegraph_definition.career_tray.size, { 60, 70 }),
    weapon_tray = create_tray("weapon_tray", scenegraph_definition.weapon_tray.size, { 75, 75 }, true),
    enemy_tray = create_tray("enemy_tray", scenegraph_definition.enemy_tray.size, { 60, 70 }),
}

local viewport_definition = {
    scenegraph_id = "background",
    element = {
        passes = {
            {
                style_id = "viewport",
                pass_type = "viewport",
                content_id = "viewport"
            },
            {
                pass_type = "hotspot",
                content_id = "button_hotspot",
                style_id = "hotspot"
            }
        }
    },
    style = {
        viewport = {
            scenegraph_id = "background",
            viewport_name = "vermitannica_preview_viewport",
            shading_environment = "environment/ui_end_screen",
            level_name = "levels/ui_keep_menu/world",
            clear_screen_on_create = true,
            enable_sub_gui = false,
            fov = 70,
            world_name = "vermitannica_preview",
            world_flags = {
                Application.DISABLE_SOUND,
                Application.DISABLE_ESRAM,
                Application.ENABLE_VOLUMETRICS
            },
            layer = UILayer.ingame_player_list,
            camera_position = {
                0,
                0,
                0
            },
            camera_lookat = {
                0,
                0,
                -0.1
            }
        },
        hotspot = {
            scenegraph_id = "viewport"
        }
    },
    content = {
        button_hotspot = {
            allow_multi_hover = true
        }
    }
}

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
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.alpha_multiplier = anim_progress

                ui_scenegraph.top_panel.local_position[2] = scenegraph_definition.top_panel.position[2] + 100 * (1 - anim_progress)
                ui_scenegraph.bottom_panel.local_position[2] = scenegraph_definition.bottom_panel.position[2] + -100 * (1 - anim_progress)

                ui_scenegraph.career_tray.local_position[2] = scenegraph_definition.career_tray.position[2] + -100 * (1 - anim_progress)
                ui_scenegraph.weapon_tray.local_position[2] = scenegraph_definition.weapon_tray.position[2] + -100 * (1 - anim_progress)
                ui_scenegraph.enemy_tray.local_position[2] = scenegraph_definition.enemy_tray.position[2] + -100 * (1 - anim_progress)

                ui_scenegraph.exit_button.local_position[2] = scenegraph_definition.exit_button.position[2] + 100 * (1 - anim_progress)
                ui_scenegraph.options_button.local_position[2] = scenegraph_definition.options_button.position[2] + 100 * (1 - anim_progress)
                ui_scenegraph.hero_browser.local_position[2] = scenegraph_definition.hero_browser.position[2] + 100 * (1 - anim_progress)
                ui_scenegraph.enemy_browser.local_position[2] = scenegraph_definition.enemy_browser.position[2] + 100 * (1 - anim_progress)
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_scenario_builder_enter = {
        {
            name = "slide_up",
            start_progress = 0,
            end_progress = 0.3,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                for _, widget in ipairs(widgets) do
                    widget.alpha_multiplier = 0
                end
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                for _, widget in ipairs(widgets) do
                    widget.alpha_multiplier = anim_progress
                end

                ui_scenegraph.hero_attributes_panel.local_position[1] = scenegraph_definition.hero_attributes_panel.position[1] + 200 * (1 - anim_progress)
                ui_scenegraph.enemy_attributes_panel.local_position[1] = scenegraph_definition.enemy_attributes_panel.position[1] - 200 * (1 - anim_progress)

                ui_scenegraph.hero_attribute_base.local_position[2] = scenegraph_definition.hero_attribute_base.position[2] - 200 * (1 - anim_progress)
                ui_scenegraph.enemy_attribute_base.local_position[2] = scenegraph_definition.enemy_attribute_base.position[2] - 200 * (1 - anim_progress)

                local career_tray_local_position = ui_scenegraph.career_tray.local_position
                local career_tray_scenegraph_position = scenegraph_definition.career_tray.position
                if career_tray_local_position[2] ~= career_tray_scenegraph_position[2] then
                    career_tray_local_position[2] = career_tray_scenegraph_position[2] - 200 * (1 - anim_progress)
                end

                local weapon_tray_local_position = ui_scenegraph.weapon_tray.local_position
                local weapon_tray_scenegraph_position = scenegraph_definition.weapon_tray.position
                if weapon_tray_local_position[2] ~= weapon_tray_scenegraph_position[2] then
                    weapon_tray_local_position[2] = weapon_tray_scenegraph_position[2] - 200 * (1 - anim_progress)
                end

                local enemy_tray_local_position = ui_scenegraph.enemy_tray.local_position
                local enemy_tray_scenegraph_position = scenegraph_definition.enemy_tray.position
                if enemy_tray_local_position[2] ~= enemy_tray_scenegraph_position[2] then
                    enemy_tray_local_position[2] = enemy_tray_scenegraph_position[2] - 200 * (1 - anim_progress)
                end
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_enemy_browser_enter = {
        {
            name = "slide_in",
            start_progress = 0,
            end_progress = 0.3,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                for _, widget in pairs(widgets) do
                    widget.alpha_multiplier = 0
                end
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                for _, widget in pairs(widgets) do
                    widget.alpha_multiplier = anim_progress
                end

                ui_scenegraph.enemy_browser_panel.local_position[1] = scenegraph_definition.enemy_browser_panel.position[1] - 200 * (1 - anim_progress)

                ui_scenegraph.career_tray.local_position[2] = scenegraph_definition.career_tray.position[2] - 200 * (anim_progress)
                ui_scenegraph.weapon_tray.local_position[2] = scenegraph_definition.weapon_tray.position[2] - 200 * (anim_progress)

                local enemy_tray_local_position = ui_scenegraph.enemy_tray.local_position
                local enemy_tray_scenegraph_position = scenegraph_definition.enemy_tray.position
                if enemy_tray_local_position[2] ~= enemy_tray_scenegraph_position[2] then
                    enemy_tray_local_position[2] = enemy_tray_scenegraph_position[2] - 200 * (1 - anim_progress)
                end
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_hero_browser_enter = {
        {
            name = "slide_in",
            start_progress = 0,
            end_progress = 0.3,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                for _, widget in pairs(widgets) do
                    widget.alpha_multiplier = 0
                end
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                for _, widget in pairs(widgets) do
                    widget.alpha_multiplier = anim_progress
                end

                ui_scenegraph.hero_browser_panel.local_position[1] = scenegraph_definition.hero_browser_panel.position[1] + 200 * (1 - anim_progress)
                ui_scenegraph.enemy_tray.local_position[2] = scenegraph_definition.enemy_tray.position[2] - 200 * (anim_progress)

                local career_tray_local_position = ui_scenegraph.career_tray.local_position
                local career_tray_scenegraph_position = scenegraph_definition.career_tray.position
                if career_tray_local_position[2] ~= career_tray_scenegraph_position[2] then
                    career_tray_local_position[2] = career_tray_scenegraph_position[2] - 200 * (1 - anim_progress)
                end

                local weapon_tray_local_position = ui_scenegraph.weapon_tray.local_position
                local weapon_tray_scenegraph_position = scenegraph_definition.weapon_tray.position
                if weapon_tray_local_position[2] ~= weapon_tray_scenegraph_position[2] then
                    weapon_tray_local_position[2] = weapon_tray_scenegraph_position[2] - 200 * (1 - anim_progress)
                end
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_hero_browser_sub_mode_enter = {
        {
            name = "slide_in",
            start_progress = 0,
            end_progress = 0.25,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                for _, widget in ipairs(widgets) do
                    widget.alpha_multiplier = 0
                end
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                for _, widget in ipairs(widgets) do
                    widget.alpha_multiplier = anim_progress
                end

                ui_scenegraph.hero_skin_template.size[1] = scenegraph_definition.hero_skin_template.size[1] + (75 / 2) * (1 - anim_progress)
                ui_scenegraph.hero_skin_template.size[2] = scenegraph_definition.hero_skin_template.size[2] + (75 / 2) * (1 - anim_progress)

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
            end_progress = 1,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.alpha_multiplier = 1
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.alpha_multiplier = 1 - anim_progress
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    }
}

local view_manager = VermitannicaManagers.view

local refresh_mt
local settings_by_screen

local function refresh()
    local view_states = view_manager:view_states()

    settings_by_screen = {}

    for _, view_state_settings in ipairs(view_states) do

        table.insert(settings_by_screen, {
            name = view_state_settings.name,
            display_name = view_state_settings.display_name,
            state_name = view_state_settings.state_name,
            draw_background_world = view_state_settings.draw_background_world,
            draw_hero_unit = view_state_settings.draw_hero_unit,
            draw_enemy_unit = view_state_settings.draw_enemy_unit,
            camera_position = view_state_settings.camera_position
        })

    end

    setmetatable(settings_by_screen, refresh_mt)

    return settings_by_screen

end

refresh_mt = {
    __call = function (t)
        t = refresh()

        return t
    end
}

refresh()

local accepted_breeds = {
    "skaven_slave",
    "skaven_clan_rat",
    "skaven_plague_monk",
    "skaven_storm_vermin",
    "skaven_warpfire_thrower",
    "skaven_poison_wind_globadier",
    "skaven_gutter_runner",
    "skaven_ratling_gunner",
    "skaven_pack_master",
    "skaven_loot_rat",
    "skaven_rat_ogre",
    "skaven_stormfiend",
    "skaven_storm_vermin_warlord",
    "skaven_stormfiend_boss",
    "skaven_grey_seer",

    "chaos_fanatic",
    "chaos_marauder",
    "chaos_berzerker",
    "chaos_raider",
    "chaos_warrior",
    "chaos_corruptor_sorcerer",
    "chaos_vortex_sorcerer",
    "chaos_troll",
    "chaos_spawn",
    "chaos_exalted_sorcerer",
    "chaos_exalted_champion_warcamp",
    "chaos_exalted_champion_norsca",

    "beastmen_ungor",
    "beastmen_ungor_archer",
    "beastmen_gor",
    "beastmen_bestigor",
    "beastmen_standard_bearer",
    "beastmen_minotaur"
}

local lord_breeds = {
    chaos_exalted_sorcerer = true,
    chaos_exalted_champion_warcamp = true,
    skaven_storm_vermin_warlord = true,
    skaven_grey_seer = true
}

local boss_breeds = {
    chaos_troll = true,
    chaos_spawn = true,
    chaos_exalted_champion_norsca = true,
    skaven_stormfiend = true,
    skaven_stormfiend_boss = true,
    skaven_rat_ogre = true,
    beastmen_minotaur = true
}

-- TODO: localize
local armor_categories = {
    "Infantry",
    "Armored",
    "Monster",
    "Player",
    "Berserker",
    "Heavily Armored"
}

local breed_name_overrides = {
    chaos_fanatic = mod:localize("chaos_fanatic"),
    chaos_corruptor_sorcerer = mod:localize("chaos_corruptor_sorcerer"),
    chaos_vortex_sorcerer = mod:localize("chaos_vortex_sorcerer"),
    skaven_slave = mod:localize("skaven_slave"),
    beastmen_standard_bearer = mod:localize("beastmen_standard_bearer"),
    beastmen_bestigor = mod:localize("beastmen_bestigor"),
    beastmen_gor = mod:localize("beastmen_gor"),
    beastmen_ungor_archer = mod:localize("beastmen_ungor_archer"),
    beastmen_ungor = mod:localize("beastmen_ungor")
}
local settings_by_tray = {
    [1] = {
        name = "career_tray",
        disable_on_select = true,
        widget_template = create_widget_template("career_icon_template", scenegraph_definition.career_icon_template.size),
        populate_items_func = function (self)

            local widget_template = self.widget_template
            local career_widgets = {}
            local num_columns = #SPProfilesAbbreviation

            local row_width = scenegraph_definition.career_tray.size[1] - 30
            local icon_width = scenegraph_definition.career_icon_template.size[1]
            local icon_height = scenegraph_definition.career_icon_template.size[2]
            local padding = (row_width - (icon_width * num_columns)) / (num_columns - 1)

            for i = 1, 3 do

                for j, profile_index in ipairs(ProfilePriority) do

                    local profile_settings = SPProfiles[profile_index]
                    local career_settings = profile_settings.careers[i]

                    local widget = UIWidget.init(widget_template)
                    career_widgets[#career_widgets + 1] = widget
                    local offset = widget.offset
                    local content = widget.content
                    local portrait_image = UISettings.breed_textures[career_settings.breed.name]

                    content.settings = career_settings
                    content.icon = portrait_image

                    content.title_text = career_settings.display_name
                    content.sub_title_text = profile_settings.character_name

                    offset[1] = (j - 1) * (icon_width + padding) + 15
                    offset[2] = (i - 1) * (icon_height + 10) + 10

                end

            end

            for _, widget in ipairs(career_widgets) do
                widget.content.visible = false
            end

            self.num_rows = 3
            self.num_columns = num_columns
            self.widgets = career_widgets

            local tray_widget = self.tray_widget
            local tray_style = tray_widget.style
            local tray_content = tray_widget.content
            local edge_height = tray_content.edge_height

            tray_style.background_active.size[2] = (self.num_rows * (icon_height + 10)) + scenegraph_definition.career_tray.size[2] + 10
            tray_style.background_frame_active.size[2] = tray_style.background_active.size[2] + edge_height * 2

        end
    },
    [2] = {
        name = "weapon_tray",
        disable_on_select = false,
        widget_template = create_widget_template("weapon_icon_template", scenegraph_definition.weapon_icon_template.size),
        populate_items_func = function (self, selected_career_name, selected_career_equipment)
            if not selected_career_name then
                return
            end

            local widget_template = self.widget_template
            local weapons = {}
            local ranged_weapons = {}
            for weapon_name, weapon_settings in pairs(ItemMasterList) do

                if table.contains(weapon_settings.can_wield, selected_career_name) then

                    if weapon_settings.rarity ~= "magic" then

                        if weapon_settings.slot_type == "melee" then
                            weapons[#weapons + 1] = weapon_name
                        elseif weapon_settings.slot_type == "ranged" then
                            ranged_weapons[#ranged_weapons + 1] = weapon_name
                        end

                    end

                end

            end

            for i, weapon_name in ipairs(ranged_weapons) do
                weapons[#weapons + i] = weapon_name
            end

            local weapon_widgets = {}

            local num_columns = 5
            local row_width = scenegraph_definition.weapon_tray.size[1] - 30
            local icon_width = scenegraph_definition.weapon_icon_template.size[1]
            local icon_height = scenegraph_definition.weapon_icon_template.size[2]
            local padding = (row_width - (icon_width * num_columns)) / (num_columns - 1)

            local row_index = 1
            local column_index = 1
            for _, weapon_name in pairs(weapons) do

                if column_index > num_columns then
                    column_index = 1
                    row_index = row_index + 1
                end

                local weapon_settings = ItemMasterList[weapon_name]
                local weapon_skin_name = selected_career_equipment.weapon_skin_by_weapon_name[weapon_name]
                local weapon_skin_settings = WeaponSkins.skins[weapon_skin_name]

                local widget = UIWidget.init(widget_template)
                weapon_widgets[#weapon_widgets + 1] = widget

                local offset = widget.offset
                local content = widget.content
                local rarity_texture = UISettings.item_rarity_textures[weapon_skin_settings.rarity]

                content.settings = weapon_settings
                content.icon = weapon_skin_settings.inventory_icon
                content.icon_background = rarity_texture
                content.title_text = weapon_skin_settings.display_name
                content.sub_title_text = weapon_settings.name
                content.visible = false

                offset[1] = (column_index - 1) * (icon_width + padding) + 15
                offset[2] = (row_index - 1) * (icon_height + 10) + 10

                column_index = column_index + 1

            end

            self.num_rows = row_index
            self.num_columns = num_columns
            self.widgets = weapon_widgets

            local tray_widget = self.tray_widget
            local tray_style = tray_widget.style
            local tray_content = tray_widget.content
            local edge_height = tray_content.edge_height

            tray_style.background_active.size[2] = (self.num_rows * (icon_height + 10)) + scenegraph_definition.weapon_tray.size[2] + 10
            tray_style.background_frame_active.size[2] = tray_style.background_active.size[2] + (edge_height * 2)

        end
    },
    [3] = {
        name = "enemy_tray",
        disable_on_select = false,
        widget_template = create_widget_template("enemy_icon_template", scenegraph_definition.enemy_icon_template.size),
        populate_items_func = function (self)

            local breed_textures = UISettings.breed_textures

            local widget_template = self.widget_template
            local enemy_widgets = {}

            local num_columns = 6
            local row_width = scenegraph_definition.enemy_tray.size[1] - 30
            local icon_width = scenegraph_definition.enemy_icon_template.size[1]
            local icon_height = scenegraph_definition.enemy_icon_template.size[2]
            local padding = (row_width - (icon_width * num_columns)) / (num_columns - 1)

            local row_index = 1
            local column_index = 1
            for accepted_breed_index, breed_name in pairs(accepted_breeds) do

                if self.start_new_row or column_index > num_columns then
                    row_index = row_index + 1
                    column_index = 1
                end

                local widget = UIWidget.init(widget_template)
                enemy_widgets[#enemy_widgets + 1] = widget
                local offset = widget.offset
                local content = widget.content
                local breed = Breeds[breed_name]

                content.settings = breed
                content.icon = breed_textures[breed_name] or "icon_bg_default"
                content.title_text = breed_name_overrides[breed_name] or Localize(breed_name)

                content.is_lord = lord_breeds[breed_name]
                content.is_boss = not lord_breeds[breed_name] and boss_breeds[breed_name]
                content.breed_name = breed_name

                local sub_title_text = string.format("%s | %s", armor_categories[breed.armor_category], (string.upper((string.sub(breed.race, 1, 1))) .. string.sub(breed.race, 2)))
                if content.is_lord then
                    sub_title_text = sub_title_text .. string.format(" | %s", "Lord")
                elseif content.is_boss then
                    sub_title_text = sub_title_text .. string.format(" | %s", "Boss")
                elseif breed.special then
                    sub_title_text = sub_title_text .. string.format(" | %s", "Special")
                elseif breed.elite then
                    sub_title_text = sub_title_text .. string.format(" | %s", "Elite")
                end
                content.sub_title_text = sub_title_text

                offset[1] = (column_index - 1) * (icon_width + padding) + 15
                offset[2] = (row_index - 1) * (icon_height + 10) + 10

                self.start_new_row = false
                local prefix = string.split(breed_name, "_")[1]
                local next_prefix = accepted_breeds[accepted_breed_index + 1] and string.split(accepted_breeds[accepted_breed_index + 1], "_")[1]
                if prefix ~= next_prefix then
                    self.start_new_row = true
                end

                column_index = column_index + 1

            end

            for _, widget in ipairs(enemy_widgets) do
                widget.content.visible = false
            end

            self.start_new_row = nil
            self.num_rows = row_index
            self.num_columns = num_columns
            self.widgets = enemy_widgets

            local tray_widget = self.tray_widget
            local tray_style = tray_widget.style
            local tray_content = tray_widget.content
            local edge_height = tray_content.edge_height

            tray_style.sub_title_text.localize = false
            tray_style.title_text.localize = false

            tray_style.background_active.size[2] = (self.num_rows * (icon_height + 10)) + scenegraph_definition.enemy_tray.size[2] + 15
            tray_style.background_frame_active.size[2] = tray_style.background_active.size[2] + edge_height * 2

        end
    }
}

return {
    scenegraph_definition = scenegraph_definition,
    viewport_definition = viewport_definition,
    hero_skin_widget_template = create_hero_skin_widget_template("hero_skin_template", scenegraph_definition.hero_skin_template.size),
    hero_attribute_widget_template = create_attribute_template("hero_attribute_base", scenegraph_definition.hero_attribute_base.size),
    enemy_attribute_widget_template = create_attribute_template("enemy_attribute_base", scenegraph_definition.enemy_attribute_base.size),
    settings_by_screen = settings_by_screen,
    settings_by_tray = settings_by_tray,
    widget_definitions = widget_definitions,
    tray_widgets = tray_widgets,
    animation_definitions = animation_definitions
}