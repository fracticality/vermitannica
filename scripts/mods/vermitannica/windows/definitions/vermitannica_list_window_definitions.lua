local mod = get_mod("vermitannica")

local list_size = { 920, 700 }
local list_entry_size = { 300, 120 }
local list_scrollbar_size = { 16, list_size[2] }

local vermitannica_scenegraphs = table.clone(VermitannicaSettings.menu_scenegraphs)
local scenegraph_definition = {
    screen = vermitannica_scenegraphs.screen,
    area_root = vermitannica_scenegraphs.area_root,
    area_left = vermitannica_scenegraphs.area_left,
    area_left_large = vermitannica_scenegraphs.area_left_large,
    list_window = {
        parent = "area_left_large",
        vertical_alignment = "center",
        horizontal_alignment = "left",
        position = { 0, 0, 1 }
    },
    list_window_background = {
        parent = "area_left_large",
        vertical_alignment = "center",
        horizontal_alignment = "left",
        position = { 0, 0, 0 }
    },
    list = {
        parent = "list_window",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = list_size,
        position = { 0, -list_size[2], 0 }
    },
    list_scrollbar = {
        parent = "list_window",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = list_scrollbar_size,
        position = { -58, 0, 10 }
    },
    item_root = {
        parent = "list",
        vertical_alignment = "top",
        horizontal_alignment = "left",
        size = list_entry_size,
        position = { 0, 0, 1 }
    },
    list_detail_top_left = {
        vertical_alignment = "top",
        parent = "list_scrollbar",
        horizontal_alignment = "left",
        size = {
            157,
            97
        },
        position = {
            -45,
            60,
            2
        }
    },
    list_detail_bottom_left = {
        vertical_alignment = "bottom",
        parent = "list_scrollbar",
        horizontal_alignment = "left",
        size = {
            157,
            97
        },
        position = {
            -45,
            -60,
            2
        }
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

local list_widget_template = function (size)

    local frame_settings = UIFrameSettings.menu_frame_06
    local selection_frame_settings = UIFrameSettings.frame_outer_glow_01

    local selection_frame_size = {
        size[1] + selection_frame_settings.texture_sizes.vertical[1] * 2,
        size[2] + selection_frame_settings.texture_sizes.horizontal[2] * 2
    }
    local selection_frame_offset = {
        -selection_frame_settings.texture_sizes.vertical[1],
        -selection_frame_settings.texture_sizes.horizontal[2],
        6
    }
    local text_area_size = { size[1] / 3, 40 }

    local element = {
        passes = {
            {
                pass_type = "hotspot",
                content_id = "button_hotspot",
                style_id = "button_hotspot"
            },
            --{
            --    pass_type = "hotspot",
            --    content_id = "detail_1_hotspot",
            --    style_id = "detail_1_hotspot"
            --},
            --{
            --    pass_type = "hotspot",
            --    content_id = "detail_2_hotspot",
            --    style_id = "detail_2_hotspot"
            --},
            --{
            --    pass_type = "hotspot",
            --    content_id = "detail_3_hotspot",
            --    style_id = "detail_3_hotspot"
            --},
            {
                pass_type = "texture",
                texture_id = "rect",
                style_id = "overlay"
            },
            {
                pass_type = "texture",
                texture_id = "background",
                style_id = "background"
            },
            {
                pass_type = "texture_frame",
                style_id = "frame",
                texture_id = "frame"
            },
            {
                pass_type = "texture_frame",
                style_id = "selection_frame",
                texture_id = "selection_frame"
            },
            {
                pass_type = "texture",
                texture_id = "icon",
                style_id = "icon"
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
                pass_type = "text",
                text_id = "subtitle_text",
                style_id = "subtitle_text"
            },
            {
                pass_type = "text",
                text_id = "subtitle_text",
                style_id = "subtitle_text_shadow"
            },
            {
                pass_type = "texture",
                texture_id = "text_divider_horizontal",
                style_id = "text_divider_horizontal"
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
                pass_type = "texture",
                texture_id = "extra_icon_1",
                style_id = "extra_icon_1",
                content_check_function = function (content)
                    return content.extra_icon_1 and content.extra_icon_1 ~= ""
                end
            },
            {
                pass_type = "texture",
                texture_id = "extra_icon_1",
                style_id = "extra_icon_1_shadow",
                content_check_function = function (content)
                    return content.extra_icon_1 and content.extra_icon_1 ~= ""
                end
            },
            {
                pass_type = "texture",
                texture_id = "extra_icon_2",
                style_id = "extra_icon_2",
                content_check_function = function (content)
                    return content.extra_icon_2 and content.extra_icon_2 ~= ""
                end
            },
            {
                pass_type = "texture",
                texture_id = "extra_icon_2",
                style_id = "extra_icon_2_shadow",
                content_check_function = function (content)
                    return content.extra_icon_2 and content.extra_icon_2 ~= ""
                end
            }
        }
    }

    local content = {
        button_hotspot = {},
        size = size,
        rect = "rect_masked",
        background = "background_leather_02",
        frame = frame_settings.texture,
        selection_frame = selection_frame_settings.texture,
        icon = "icons_placeholder",
        title_text = "",
        subtitle_text = "",
        text_divider_horizontal = "divider_01_bottom",
        detail_1_icon = "",
        detail_1_text = "",
        detail_2_icon = "",
        detail_2_text = "",
        detail_3_icon = "",
        detail_3_text = "",
        extra_icon_1 = "",
        extra_icon_2 = ""
    }

    local style = {
        button_hotspot = {
            size = size,
            offset = { 0, 0, 0 }
        },
        background = {
            vertical_alignment = "top",
            horizontal_alignment = "left",
            masked = true,
            texture_size = size,
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 1 }
        },
        frame = {
            texture_size = frame_settings.texture_size,
            texture_sizes = frame_settings.texture_sizes,
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 5 },
            masked = true,
        },
        selection_frame = {
            texture_size = selection_frame_settings.texture_size,
            texture_sizes = selection_frame_settings.texture_sizes,
            color = { 255, 255, 255, 255 },
            size = selection_frame_size,
            offset = selection_frame_offset,
            masked = true
        },
        overlay = {
            vertical_alignment = "top",
            horizontal_alignment = "left",
            masked = true,
            texture_size = size,
            color = { 0, 5, 5, 5 },
            offset = { 0, 0, 8 }
        },
        icon = {
            size = { 60, 70 },
            offset = { size[1] - 70, size[2] - 80, 3 },
            masked = true,
        },
        title_text = {
            font_type = "hell_shark_header_masked",
            font_size = 28,
            dynamic_font_size = true,
            text_color = Colors.get_color_table_with_alpha("font_default", 255),
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { size[1] - 85, size[2] },
            offset = { 10, -10, 3 },
        },
        title_text_shadow = {
            font_type = "hell_shark_header_masked",
            font_size = 28,
            dynamic_font_size = true,
            text_color = Colors.get_color_table_with_alpha("black", 255),
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { size[1] - 85, size[2] },
            offset = { 12, -12, 2 },
        },
        subtitle_text = {
            font_type = "hell_shark_header_masked",
            font_size = 24,
            text_color = Colors.get_color_table_with_alpha("gray", 255),
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            size = { size[1] / 2, size[2] },
            offset = { 10, 40, 3 }
        },
        subtitle_text_shadow = {
            font_type = "hell_shark_header_masked",
            font_size = 24,
            text_color = Colors.get_color_table_with_alpha("black", 255),
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            size = { size[1] / 2, size[2] },
            offset = { 12, 38, 2 }
        },
        text_divider_horizontal = {
            color = { 255, 255, 255, 255 },
            vertical_alignment = "center",
            horizontal_alignment = "left",
            size = { size[1] - 85, 21 },
            offset = { 10, 40, 5 },
            masked = true
        },
        detail_1_icon = {
            size = { 25, 25 },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            masked = true,
            offset = { 10, 10, 3 }
        },
        detail_1_icon_shadow = {
            size = { 25, 25 },
            color = Colors.get_color_table_with_alpha("black", 255),
            masked = true,
            offset = { 12, 8, 2 }
        },
        detail_1_text = {
            font_type = "hell_shark_header_masked",
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            font_size = 18,
            dynamic_font_size = true,
            size = text_area_size,
            text_color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { 40, 8, 3 }
        },
        detail_2_icon = {
            size = { 25, 25 },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            masked = true,
            offset = { text_area_size[1] + 5, 10, 3 }
        },
        detail_2_icon_shadow = {
            size = { 25, 25 },
            color = Colors.get_color_table_with_alpha("black", 255),
            masked = true,
            offset = { text_area_size[1] + 7, 8, 2 }
        },
        detail_2_text = {
            font_type = "hell_shark_header_masked",
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            font_size = 18,
            dynamic_font_size = true,
            size = text_area_size,
            text_color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { text_area_size[1] + 35, 8, 3 }
        },
        detail_3_icon = {
            size = { 25, 25, },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            masked = true,
            offset = { text_area_size[1] * 2 + 25, 10, 3 }
        },
        detail_3_icon_shadow = {
            size = { 25, 25 },
            color = Colors.get_color_table_with_alpha("black", 255),
            masked = true,
            offset = { text_area_size[1] * 2 + 26, 8, 2 }
        },
        detail_3_text = {
            font_type = "hell_shark_header_masked",
            vertical_alignment = "bottom",
            horizontal_alignment = "left",
            font_size = 18,
            dynamic_font_size = true,
            size = text_area_size,
            text_color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { text_area_size[1] * 2 + 55, 8, 3 }
        },
        extra_icon_1 = {
            size = { 37.5, 37.5 },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            masked = true,
            offset = { size[1] - 110, 40, 3 }
        },
        extra_icon_1_shadow = {
            size = { 37.5, 37.5 },
            color = Colors.get_color_table_with_alpha("black", 255),
            masked = true,
            offset = { size[1] - 108, 38, 2 }
        },
        extra_icon_2 = {
            size = { 37.5, 37.5 },
            color = Colors.get_color_table_with_alpha("font_default", 255),
            default_color = Colors.get_color_table_with_alpha("font_default", 255),
            hover_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            masked = true,
            offset = { size[1] - 145, 40, 3 }
        },
        extra_icon_2_shadow = {
            size = { 37.5, 37.5 },
            color = Colors.get_color_table_with_alpha("black", 255),
            masked = true,
            offset = { size[1] - 143, 38, 2 }
        }
    }

    return {
        element = element,
        content = content,
        style = style,
        offset = { 0, 0, 0 },
        scenegraph_id = "item_root"
    }

end

local function create_list_mask(scenegraph_id, list_scenegraph_id, size, entry_size)
    local masked = true
    local entry_hover_frame_settings = UIFrameSettings.frame_outer_glow_04_big
    local entry_hover_frame_spacing = 10
    --local entry_hover_frame_spacing = entry_hover_frame_settings.texture_sizes.horizontal[2]
    local element = {
        passes = {
            {
                style_id = "hotspot",
                pass_type = "hotspot",
                content_id = "hotspot"
            },
            {
                style_id = "list_hotspot",
                pass_type = "hotspot",
                content_id = "list_hotspot"
            },
            {
                pass_type = "texture",
                style_id = "mask",
                texture_id = "mask_texture"
            },
            {
                pass_type = "texture",
                style_id = "mask_top",
                texture_id = "mask_edge"
            },
            {
                pass_type = "rotated_texture",
                style_id = "mask_bottom",
                texture_id = "mask_edge"
            }
        }
    }
    local content = {
        mask_edge = "mask_rect_edge_fade",
        mask_texture = "mask_rect",
        list_hotspot = {},
        hotspot = {},
        scrollbar = {
            scroll_amount = 0.1,
            percentage = 0.1,
            scroll_value = 1
        }
    }
    local style = {
        hotspot = {
            size = {
                size[1],
                size[2]
            },
            offset = {
                0,
                0,
                0
            }
        },
        list_hotspot = {
            size = {
                size[1] + entry_hover_frame_spacing * 2,
                size[2] + entry_hover_frame_spacing * 2
            },
            color = {
                255,
                255,
                255,
                255
            },
            offset = {
                -entry_hover_frame_spacing,
                -entry_hover_frame_spacing,
                0
            }
        },
        mask = {
            masked = masked,
            texture_size = {
                size[1] + entry_hover_frame_spacing * 2,
                size[2]
            },
            color = {
                255,
                255,
                255,
                255
            },
            offset = {
                -entry_hover_frame_spacing,
                0,
                0
            }
        },
        mask_top = {
            --masked = masked,
            texture_size = {
                size[1] + entry_hover_frame_spacing * 2,
                entry_hover_frame_spacing
            },
            color = {
                255,
                255,
                255,
                255
            },
            offset = {
                0,
                size[2],
                0
            }
        },
        mask_bottom = {
            --masked = masked,
            texture_size = {
                size[1] + entry_hover_frame_spacing * 2,
                entry_hover_frame_spacing
            },
            color = {
                255,
                255,
                255,
                255
            },
            offset = {
                -entry_hover_frame_spacing,
                -entry_hover_frame_spacing,
                0
            },
            angle = math.pi,
            pivot = {
                (size[1] + entry_hover_frame_spacing * 2) / 2,
                entry_hover_frame_spacing / 2
            }
        }
    }
    local widget = {
        element = element,
        content = content,
        style = style,
        offset = {
            0,
            0,
            0
        },
        scenegraph_id = scenegraph_id
    }

    return widget
end


local list_widget_definitions = {
    list = create_list_mask("list_window", nil, scenegraph_definition.area_left_large.size, nil),
    list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", scenegraph_definition.list_scrollbar.size, "gold")
}

local list_detail_widget_definitions = {
    list_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
        {
            0,
            0
        },
        {
            1,
            1
        }
    }, "list_detail_top_left"),
    list_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
        {
            0,
            1
        },
        {
            1,
            0
        }
    }, "list_detail_bottom_left"),
    list_detail_top_center = UIWidgets.create_tiled_texture("list_detail_top_center", "divider_skull_middle", {
        64,
        97
    }),
    list_detail_bottom_center = UIWidgets.create_tiled_texture("list_detail_bottom_center", "divider_skull_middle_down", {
        64,
        97
    }),
    list_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        {
            0,
            0
        },
        {
            1,
            1
        }
    }, "list_detail_top_right"),
    list_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
        {
            0,
            1
        },
        {
            1,
            0
        }
    }, "list_detail_bottom_right"),
    chain = UIWidgets.create_tiled_texture("list_scrollbar", "chain_link_01_blue", {
        16,
        19
    })
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
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_list_initialized = {
        {
            name = "fade_in",
            start_progress = 0,
            end_progress = 0.6,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.list_alpha_multiplier = 0
                local widgets_by_name = widgets.widgets_by_name
                local list_widget = widgets_by_name.list
                local style = list_widget.style
                local mask_style = style.mask
                local mask_default_width = mask_style.texture_size[1]
                params.mask_default_width = mask_default_width
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.list_alpha_multiplier = anim_progress
                local widgets_by_name = widgets.widgets_by_name
                local list_widgets = widgets.list_items
                local longest_anim_distance = 0

                for index, widget in ipairs(list_widgets) do
                    local content = widget.content
                    local offset = widget.offset
                    local default_offset = widget.default_offset
                    local row = content.row
                    local column = content.col
                    local anim_offset = math.min(row * 50 + (4 - column) * 20, 300)
                    offset[1] = math.floor(default_offset[1] - anim_offset + anim_offset * anim_progress)
                    longest_anim_distance = math.max(longest_anim_distance, anim_offset)
                end

                local mask_default_width = params.mask_default_width
                local mask_size = math.floor((mask_default_width + longest_anim_distance) - longest_anim_distance * anim_progress)
                local list_widget = widgets_by_name.list
                local style = list_widget.style
                style.mask.texture_size[1] = mask_size
                style.mask_top.texture_size[1] = mask_size
                style.mask_bottom.texture_size[1] = mask_size
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
    on_list_updated = {
        {
            name = "fade_in",
            start_progress = 0,
            end_progress = 0.3,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.list_alpha_multiplier = 0
                local widgets_by_name = widgets.widgets_by_name
                local list_widget = widgets_by_name.list
                local style = list_widget.style
                local mask_style = style.mask
                local mask_default_width = mask_style.texture_size[1]
                params.mask_default_width = mask_default_width
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.list_alpha_multiplier = anim_progress
                local widgets_by_name = widgets.widgets_by_name
                local list_widgets = widgets.list_items
                local longest_anim_distance = 0

                for index, widget in ipairs(list_widgets) do
                    local content = widget.content
                    local offset = widget.offset
                    local default_offset = widget.default_offset
                    local row = content.row
                    local column = content.col
                    local anim_offset = math.min(row * 50 + (4 - column) * 20, 300)
                    offset[1] = math.floor(default_offset[1] - anim_offset + anim_offset * anim_progress)
                    longest_anim_distance = math.max(longest_anim_distance, anim_offset)
                end

                local mask_default_width = params.mask_default_width
                local mask_width = math.floor((mask_default_width + longest_anim_distance) - longest_anim_distance * anim_progress)
                local list_widget = widgets_by_name.list
                local style = list_widget.style
                style.mask.texture_size[1] = mask_width
                style.mask_top.texture_size[1] = mask_width
                style.mask_bottom.texture_size[1] = mask_width
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
            end_progress = 0.6,
            init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                params.render_settings.list_alpha_multiplier = 1
                params.render_settings.alpha_multiplier = 1
                local widgets_by_name = widgets.widgets_by_name
                local list_widget = widgets_by_name.list
                local style = list_widget.style
                local mask_style = style.mask
                local mask_default_width = mask_style.texture_size[1]
                params.mask_default_width = mask_default_width
            end,
            update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                local anim_progress = math.easeOutCubic(progress)
                params.render_settings.list_alpha_multiplier = 1 - anim_progress
                params.render_settings.alpha_multiplier = 1 - anim_progress
                local widgets_by_name = widgets.widgets_by_name
                local list_widgets = widgets.list_items
                local longest_anim_distance = 0

                for index, widget in ipairs(list_widgets) do
                    local content = widget.content
                    local offset = widget.offset
                    local default_offset = widget.default_offset
                    local row = content.row
                    local column = content.col
                    local anim_offset = math.min(row * 50 + (4 - column) * 20, 300)
                    offset[1] = math.floor(default_offset[1] - anim_offset * anim_progress)
                    longest_anim_distance = math.max(longest_anim_distance, anim_offset)
                end

                local mask_default_width = params.mask_default_width
                local mask_size = math.floor((mask_default_width + longest_anim_distance) - (longest_anim_distance * 2) * anim_progress)
                local list_widget = widgets_by_name.list
                local style = list_widget.style
                style.mask.texture_size[1] = mask_size
                style.mask_top.texture_size[1] = mask_size
                style.mask_bottom.texture_size[1] = mask_size

                ui_scenegraph.list_window.local_position[1] = scenegraph_definition.list_window.position[1] + 50 * anim_progress
            end,
            on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                return
            end
        }
    },
}

return {
    scenegraph_definition = scenegraph_definition,
    list_widget_definitions = list_widget_definitions,
    list_detail_widget_definitions = list_detail_widget_definitions,
    animation_definitions = animation_definitions,
    list_widget_template = list_widget_template,
    enemy_definitions = mod:dofile("scripts/mods/bestiary/bestiary_enemy_data").enemy_info
}