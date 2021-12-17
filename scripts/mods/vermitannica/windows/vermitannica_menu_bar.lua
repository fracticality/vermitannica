local mod = get_mod("vermitannica")

local definitions = {
    scenegraph_definition = {
        root = {
            size = { 1920, 1080 },
            position = { 0, 0, 0 }
        },
        menu_bar_root = {
            parent = "root",
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { 1920, 90 },
            position = { 0, 0, 20 }
        },
        close_button = {
            parent = "menu_bar_root",
            vertical_alignment = "top",
            horizontal_alignment = "right",
            size = { 0, 0 },
            position = { -40, -40, 3 }
        },
        menu_bar = {
            parent = "menu_bar_root",
            vertical_alignment = "top",
            horizontal_alignment = "center",
            size = { 1920, 90 },
            position = { 0, 0, 0 }
        },
        menu_item = {
            parent = "menu_bar",
            vertical_alignment = "top",
            horizontal_alignment = "left",
            size = { 150, 70 },
            position = { 0, 0, 4 }
        },
        menu_divider = {
            parent = "menu_bar",
            vertical_alignment = "bottom",
            horizontal_alignment = "center",
            size = { 0, 21 },
            position = { 0, 0, 5 }
        },
        selected_item_marker = {
            parent = "menu_bar",
            size = { 54, 22 },
            position = { 0, 0, 10 }
        }
    },
    animation_definitions = {
        on_enter = {
            {
                name = "fade_in",
                start_progress = 0,
                end_progress = 0.6,
                init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                    --for _, widget in pairs(widgets) do
                    --    widget.alpha_multiplier = 0
                    --end
                    params.render_settings.alpha_multiplier = 0
                end,
                update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                    local anim_progress = math.easeOutCubic(progress)
                    --for _, widget in pairs(widgets) do
                    --    widget.alpha_multiplier = anim_progress
                    --end
                    params.render_settings.alpha_multiplier = anim_progress
                end,
                on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                    return
                end
            },
            {
                name = "slide_in",
                start_progress = 0.0,
                end_progress = 0.3,
                init = function (ui_scenegraph, scenegraph_definition, widgets, params)
                    return
                end,
                update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
                    local anim_progress = math.easeOutCubic(progress)
                    local remaining_progress = 1 - anim_progress
                    ui_scenegraph.menu_item.local_position[2] = scenegraph_definition.menu_item.position[2] + (scenegraph_definition.menu_item.size[2] * remaining_progress)
                    ui_scenegraph.menu_divider.local_position[2] = ui_scenegraph.menu_bar.local_position[2] - (ui_scenegraph.menu_bar.size[2] * remaining_progress)
                end,
                on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
                    return
                end
            }
        }
    }
}
local scenegraph_definition = definitions.scenegraph_definition
local animation_definitions = definitions.animation_definitions

local function create_menu_selection_marker()

    local selected_marker_settings = UIAtlasHelper.get_atlas_settings_by_texture_name("mission_objective_01")
    local selected_marker_glow_settings = UIAtlasHelper.get_atlas_settings_by_texture_name("mission_objective_glow_02")

    local element = {
        passes = {
            {
                pass_type = "texture",
                texture_id = "selected_marker",
                style_id = "selected_marker"
            },
            {
                pass_type = "texture",
                texture_id = "selected_marker_glow",
                style_id = "selected_marker_glow"
            }
        }
    }

    local content = {
        selected_marker = "mission_objective_01",
        selected_marker_glow = "mission_objective_glow_02"
    }

    local style = {
        selected_marker = {
            size = selected_marker_settings.size,
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 0 }
        },
        selected_marker_glow = {
            size = selected_marker_glow_settings.size,
            color = { 255, 255, 255, 255 },
            offset = { 0, 0, 1 }
        },
    }

    return {
        element = element,
        content = content,
        style = style,
        offset = { 0, 0, 0 },
        scenegraph_id = "selected_item_marker"
    }

end

local display_name_font_style = {
    font_type = "hell_shark",
    font_size = 48,
    text_color = Colors.get_color_table_with_alpha("font_title", 255),
}

local function create_menu_item_template(size)

    local selected_marker_settings = UIAtlasHelper.get_atlas_settings_by_texture_name("mission_objective_01")
    local selected_marker_glow_settings = UIAtlasHelper.get_atlas_settings_by_texture_name("mission_objective_glow_02")

    local element = {
        passes = {
            {
                pass_type = "hotspot",
                content_id = "hotspot",
                style_id = "hotspot"
            },
            {
                pass_type = "texture",
                texture_id = "divider",
                style_id = "divider"
            },
            {
                pass_type = "text",
                text_id = "display_name",
                style_id = "display_name",
            },
            {
                pass_type = "text",
                text_id = "display_name",
                style_id = "display_name_shadow"
            }
        }
    }

    local content = {
        display_name = "",
        hotspot = {},
        divider = "divider_01_bottom"
    }

    local style = {
        hotspot = {
            size = size,
            offset = { 0, 0, 0 }
        },
        divider = {
            size = { size[1], 21 },
            color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            offset = { 0, 0, 1 }
        },
        selected_marker = {
            size = selected_marker_settings.size,
            offset = { (size[1] / 2) - selected_marker_glow_settings.size[1] / 2, -selected_marker_glow_settings.size[2] / 2, 1 }
        },
        display_name = {
            font_type = "hell_shark",
            font_size = 48,
            text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
            hover_text_color = Colors.get_color_table_with_alpha("white", 255),
            selected_text_color = Colors.get_color_table_with_alpha("font_title", 255),
        },
        display_name_shadow = {
            font_type = "hell_shark",
            font_size = 48,
            text_color = Colors.get_color_table_with_alpha("black", 255)
        }
    }

    return {
        element = element,
        content = content,
        style = style,
        offset = { 0, 0, 0 },
        scenegraph_id = "menu_item"
    }

end

---@class VermitannicaMenuBar
---@field private parent VermitannicaView
VermitannicaMenuBar = class(VermitannicaMenuBar)
VermitannicaMenuBar.NAME = "VermitannicaMenuBar"

function VermitannicaMenuBar:init(params)

    self.parent = params.parent
    self.menu_items = params.menu_items
    self.ui_top_renderer = params.ui_top_renderer

    self.render_settings = {}
    self.ui_animations = {}

end

function VermitannicaMenuBar:on_enter()

    self:_create_ui_elements()

    self:active(true)

    self:_start_transition_animation("on_enter", "on_enter", self.menu_item_widgets)

end

function VermitannicaMenuBar:_start_transition_animation(key, animation_name, widgets)
    local params = {
        render_settings = self.render_settings
    }
    local anim_id = self.ui_animator:start_animation(animation_name, widgets or {}, scenegraph_definition, params)
    self.ui_animations[key] = anim_id
end

function VermitannicaMenuBar:_create_ui_elements()

    self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

    self:_create_menu_item_widgets()

    local menu_bar_bg_definition = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
        { 1, 0},
        { 0, 1 }
    }, "menu_bar_root", nil, nil, UISettings.console_menu_rect_color)
    self.menu_bar_bg = UIWidget.init(menu_bar_bg_definition)
    self.close_button = UIWidget.init( UIWidgets.create_layout_button("close_button", "layout_button_close", "layout_button_close_glow"))

    self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

    UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

end

function VermitannicaMenuBar:_create_menu_item_widgets()
    local ui_top_renderer = self.ui_top_renderer

    local menu_items = self.menu_items
    local num_menu_items = #menu_items
    local menu_item_size = scenegraph_definition.menu_item.size

    local padding = 30
    local total_width = padding

    local menu_item_widgets = {}
    for i = 1, num_menu_items, 1 do
        local menu_item = menu_items[i]
        local menu_item_display_name = menu_item.display_name

        local text_width = UIUtils.get_text_width(ui_top_renderer, display_name_font_style, menu_item_display_name)
        local width = math.max(text_width, menu_item_size[1])

        local text_height = UIUtils.get_text_height(ui_top_renderer, {width}, display_name_font_style, menu_item_display_name)
        local height = math.max(text_height, menu_item_size[2])

        local widget = UIWidget.init( create_menu_item_template({ width, height }) )
        widget.content.name = menu_item.name
        widget.content.display_name = menu_item.display_name

        widget.offset[1] = total_width

        total_width = total_width + (width + padding)

        local display_name_style = widget.style.display_name
        local display_name_offset = { math.max((width / 2) - (text_width / 2), 0), 0, 5 }
        display_name_style.offset = display_name_offset
        widget.style.display_name_shadow.offset = {
            display_name_offset[1] + 2,
            display_name_offset[2] - 2,
            display_name_offset[3] - 1
        }

        table.insert(menu_item_widgets, widget)
    end
    self.menu_item_widgets = menu_item_widgets
    self.ui_scenegraph.menu_bar.size[1] = total_width

    local menu_divider_definition = UIWidgets.create_simple_texture("divider_01_bottom", "menu_divider")
    local menu_divider = UIWidget.init(menu_divider_definition)
    menu_divider.style.texture_id.size = { total_width, scenegraph_definition.menu_divider.size[2] }
    menu_divider.style.texture_id.offset = { -total_width / 2, 15, 0 }
    menu_divider.style.texture_id.color = Colors.get_color_table_with_alpha("font_button_normal", 255)
    self.menu_divider = menu_divider

    local selected_item_marker_settings = UIAtlasHelper.get_atlas_settings_by_texture_name("mission_objective_01")
    local selected_item_marker_definition = create_menu_selection_marker()
    local selected_item_marker = UIWidget.init(selected_item_marker_definition)
    selected_item_marker.offset[1] = self.menu_item_widgets[1].offset[1]
    selected_item_marker.offset[2] = selected_item_marker_settings.size[2] / 3
    self.selected_item_marker = selected_item_marker

    self.ui_animations.selected_marker_glow_pulse = UIAnimation.init(
            UIAnimation.pulse_animation, selected_item_marker.style.selected_marker_glow.color, 1, 0, 255, 0.75
    )

end

function VermitannicaMenuBar:on_exit()

    self:active(false)

end

function VermitannicaMenuBar:update(dt, t)

    if not self:active() then
        return
    end

    self:_handle_mouse_input(dt)

    self:draw(dt)

end

function VermitannicaMenuBar:_update_animations(dt)
    local animations = self.ui_animations
    local ui_animator = self.ui_animator

    ui_animator:update(dt)

    for anim_name, anim_id in pairs(animations) do
        if ui_animator:is_animation_completed(anim_id) then
            ui_animator:stop_animation(anim_id)

            animations[anim_id] = nil
        end
    end

    UIAnimation.update(animations.selected_marker_glow_pulse, dt)

    self:_animate_close_button(dt)
    self:_animate_menu_items(dt)
    self:_update_menu_selection_animation(dt)

end

function VermitannicaMenuBar:_animate_menu_items(dt)
    local menu_items = self.menu_item_widgets
    for i, menu_item in ipairs(menu_items) do
        local content = menu_item.content
        local style = menu_item.style
        local hotspot = content.hotspot
        local is_hover = hotspot.is_hover
        local is_selected = hotspot.is_selected
        local input_pressed = not is_selected and hotspot.is_clicked and hotspot.is_clicked == 0
        local input_progress = hotspot.input_progress or 0
        local hover_progress = hotspot.hover_progress or 0
        local selection_progress = hotspot.selection_progress or 0
        local input_speed = 12
        local hover_speed = 8
        local selection_speed = 10

        if input_pressed then
            input_progress = math.min(input_progress + dt * input_speed, 1)
        else
            input_progress = math.max(input_progress - dt * input_speed, 0)
        end

        if is_hover then
            hover_progress = math.min(hover_progress + dt * hover_speed, 1)
        else
            hover_progress = math.max(hover_progress - dt * hover_speed, 0)
        end

        if is_selected then
            selection_progress = math.min(selection_progress + dt * selection_speed, 1)
        else
            selection_progress = math.max(selection_progress - dt * selection_speed, 0)
        end

        local display_name_style = style.display_name
        local display_name_text_color = display_name_style.text_color
        local display_name_default_text_color = display_name_style.default_text_color
        local display_name_hover_text_color = display_name_style.hover_text_color
        local display_name_selected_text_color = display_name_style.selected_text_color

        Colors.lerp_color_tables(display_name_default_text_color, display_name_hover_text_color, hover_progress, display_name_text_color)
        Colors.lerp_color_tables(display_name_text_color, display_name_selected_text_color, selection_progress, display_name_text_color)

        local hover_offset = math.max(hover_progress, selection_progress) * 5
        menu_item.offset[2] = hover_offset - 5
        style.hotspot.offset[2] = -menu_item.offset[2]

        hotspot.hover_progress = hover_progress
        hotspot.input_progress = input_progress
        hotspot.selection_progress = selection_progress
    end
end

function VermitannicaMenuBar:_animate_close_button(dt)
    local close_button = self.close_button
    local content = close_button.content
    local style = close_button.style
    local hotspot = content.button_hotspot
    local is_hover = hotspot.is_hover
    local is_selected = hotspot.is_selected
    local hover_progress = hotspot.hover_progress or 0
    local selection_progress = hotspot.selection_progress or 0
    local anim_speed = 8

    if is_hover then
        hover_progress = math.min(hover_progress + (dt * anim_speed), 1)
    else
        hover_progress = math.max(hover_progress - (dt * anim_speed), 0)
    end

    if is_selected then
        selection_progress = math.min(selection_progress + (dt * anim_speed), 1)
    else
        selection_progress = math.max(selection_progress - (dt * anim_speed), 0)
    end

    local combined_progress = math.max(hover_progress, selection_progress)
    local hover_alpha = 255 * combined_progress
    style.texture_id.color[1] = 255 - hover_alpha
    style.texture_hover_id.color[1] = hover_alpha
    style.selected_texture.color[1] = hover_alpha
    hotspot.hover_progress = hover_progress
    hotspot.selection_progress = selection_progress
end

function VermitannicaMenuBar:_handle_mouse_input(dt)

    local parent = self.parent
    local sound_event

    local menu_items = self.menu_item_widgets
    for i, menu_item in ipairs(menu_items) do
        local hotspot = menu_item.content.hotspot
        local is_selected = hotspot.is_selected

        if not is_selected then
            if UIUtils.is_button_hover_enter(menu_item) then
                sound_event = "Play_hud_hover"
            elseif UIUtils.is_button_pressed(menu_item) then
                sound_event = "Play_hud_select"
                local name = menu_item.content.name
                parent:request_screen_change_by_name(name)
                self:select_menu_item_by_index(i)

                break
            end
        end
    end

    local close_button = self.close_button
    if UIUtils.is_button_hover_enter(close_button) then
        sound_event = "Play_hud_hover"
    elseif UIUtils.is_button_pressed(close_button) then
        parent:close_menu()
    end

    if sound_event then
        parent:play_sound(sound_event)
    end

end

function VermitannicaMenuBar:_start_menu_selection_animation(new_index)
    local target_menu_item = self.menu_item_widgets[new_index]
    local target_offset = target_menu_item.offset[1] + target_menu_item.style.selected_marker.offset[1]
    local start_offset = self.selected_item_marker.offset[1]
    local menu_selection_animation = {
        duration = 0.5,
        total_duration = 0.5,
        target_offset = target_offset,
        start_offset = start_offset
    }

    self.menu_selection_animation = menu_selection_animation
end

function VermitannicaMenuBar:_update_menu_selection_animation(dt)
    local menu_selection_animation = self.menu_selection_animation
    if not menu_selection_animation then
        return
    end

    local duration = menu_selection_animation.duration
    if not duration then
        return
    end

    duration = math.max(duration - dt, 0)

    local start_offset = menu_selection_animation.start_offset
    local target_offset = menu_selection_animation.target_offset
    local total_duration = menu_selection_animation.total_duration
    local progress = 1 - duration / total_duration
    local anim_progress = math.easeOutCubic(progress)
    local animation_offset = (target_offset - start_offset) * anim_progress
    local current_offset = start_offset + animation_offset

    self.selected_item_marker.offset[1] = current_offset

    menu_selection_animation.duration = (duration == 0 and nil) or duration
end

function VermitannicaMenuBar:select_menu_item_by_index(index)

    self:_start_menu_selection_animation(index)

    local menu_items = self.menu_item_widgets
    for i, menu_item in ipairs(menu_items) do
        menu_item.content.hotspot.is_selected = i == index
    end
end

function VermitannicaMenuBar:select_menu_item_by_name(item_name)
    local menu_items = self.menu_item_widgets
    for i, menu_item in ipairs(menu_items) do
        if item_name == menu_item.content.name then
            self:select_menu_item_by_index(i)
        end
    end
end

function VermitannicaMenuBar:draw(dt)

    local ui_top_renderer = self.ui_top_renderer
    local ui_scenegraph = self.ui_scenegraph
    local input_service = self.parent:input_service()
    local render_settings = self.render_settings

    UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

    local alpha_multiplier = render_settings.alpha_multiplier or 1

    for _, menu_item in ipairs(self.menu_item_widgets) do
        render_settings.alpha_multiplier = menu_item.alpha_multiplier or alpha_multiplier
        UIRenderer.draw_widget(ui_top_renderer, menu_item)
    end

    UIRenderer.draw_widget(ui_top_renderer, self.menu_divider)
    UIRenderer.draw_widget(ui_top_renderer, self.selected_item_marker)
    UIRenderer.draw_widget(ui_top_renderer, self.menu_bar_bg)
    UIRenderer.draw_widget(ui_top_renderer, self.close_button)

    render_settings.alpha_multiplier = alpha_multiplier

    UIRenderer.end_pass(ui_top_renderer)

end

function VermitannicaMenuBar:post_update_on_enter()

end

function VermitannicaMenuBar:post_update(dt)

    self:_update_animations(dt)

end

function VermitannicaMenuBar:post_update_on_exit()

end

function VermitannicaMenuBar:active(make_active)

    if make_active == nil then
        return self.is_active
    end

    self.is_active = make_active

end