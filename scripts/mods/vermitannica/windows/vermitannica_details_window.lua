local mod = get_mod("vermitannica")

local definitions = mod:dofile("scripts/mods/vermitannica/windows/definitions/vermitannica_details_window_definitions")
local scenegraph_definition = definitions.scenegraph_definition
local widget_definitions = definitions.widget_definitions
local frame_detail_widget_definitions = definitions.frame_detail_widget_definitions
local animation_definitions = definitions.animation_definitions
local create_detail_panel = definitions.create_detail_panel

VermitannicaDetailsWindow = class(VermitannicaDetailsWindow)
VermitannicaDetailsWindow.NAME = "VermitannicaDetailsWindow"

function VermitannicaDetailsWindow:on_enter(window_params, view_model)

    mod:debug("[%s] on_enter", self.NAME)

    self.parent = window_params.parent
    self.ui_top_renderer = window_params.ui_top_renderer
    self._window_params = window_params
    self.view_model = view_model

    self.ui_animations = {}
    self.render_settings = {
        alpha_multiplier = 1,
        snap_pixel_positions = true
    }

    self:_create_ui_elements()
    self:_start_transition_animation("on_enter")

end

function VermitannicaDetailsWindow:_create_ui_elements()

    self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

    local frame_detail_widgets = {}
    local frame_detail_widgets_by_name = {}
    for name, definition in pairs(frame_detail_widget_definitions) do
        local widget = UIWidget.init(definition)
        frame_detail_widgets[#frame_detail_widgets + 1] = widget
        frame_detail_widgets_by_name[name] = widget
    end
    self.frame_detail_widgets = frame_detail_widgets
    self.frame_detail_widgets_by_name = frame_detail_widgets_by_name

    local view_model = self.view_model
    self.frame_detail_widgets_by_name.frame_title_text.content.text = view_model.name

    self.widgets_by_name = {
        window_background = UIWidget.init(widget_definitions.window_background)
    }

    local detail_panels_n = #view_model.detail_panels
    local padding = 50
    local panel_size = scenegraph_definition.detail_panel_root.size
    local content_height = (panel_size[2] * detail_panels_n) + (detail_panels_n - 1) * padding
    local start_height = (scenegraph_definition.window_root.size[2] - content_height) / 2

    local vm_detail_panels = view_model.detail_panels
    local detail_panels = {}
    for index, detail_panel in ipairs(vm_detail_panels) do
        local widget_definition = create_detail_panel("detail_panel_root", panel_size)
        local widget = UIWidget.init(widget_definition)
        local content = widget.content
        local offset = widget.offset

        content.title_text = detail_panel.title_text
        local panel_details = detail_panel.details
        for i, detail in ipairs(panel_details) do
            local key = string.format("detail_%s_", i)
            content[key .. "icon"] = detail.icon
            content[key .. "text"] = detail.text
            content[key .. "tooltip"] = detail.tooltip
        end

        offset[2] = -(start_height + panel_size[2] * (index - 1) + (index) * (padding / 2))
        --offset[2] = (index - 1) * -(panel_size[2] + (index > 1 and 50 or 0))
        widget.default_offset = table.clone(offset)

        detail_panels[#detail_panels + 1] = widget
    end
    self.detail_panels = detail_panels

    self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

    UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)
end

function VermitannicaDetailsWindow:_start_transition_animation(animation_name, widgets)

    local params = {
        render_settings = self.render_settings
    }

    widgets = widgets or {
        frame_details = self.frame_detail_widgets_by_name,
        detail_panels = self.detail_panels
    }

    local anim_id = self.ui_animator:start_animation(animation_name, widgets, scenegraph_definition, params)
    self.ui_animations[animation_name] = anim_id

end

function VermitannicaDetailsWindow:update(dt, t)

    self:_draw(dt)

end

function VermitannicaDetailsWindow:post_update(dt)

    self:_update_animations(dt)

end

function VermitannicaDetailsWindow:_update_animations(dt)

    local animations = self.ui_animations
    local ui_animator = self.ui_animator

    ui_animator:update(dt)

    for anim_name, anim_id in pairs(animations) do
        if ui_animator:is_animation_completed(anim_id) then
            ui_animator:stop_animation(anim_id)

            animations[anim_name] = nil
        end
    end

    self:_animate_detail_panels(dt)
end

local function update_anim_progress(condition, progress, dt, speed)

    if condition then
        return math.min(progress + dt * (speed or 1), 1)
    else
        return math.max(progress - dt * (speed or 1), 0)
    end

end

function VermitannicaDetailsWindow:_animate_detail_panels(dt)

    local detail_panels = self.detail_panels
    for _, detail_panel in ipairs(detail_panels) do
        local content = detail_panel.content
        local style = detail_panel.style

        local hover_speed = 4

        for i = 1, 3, 1 do
            local key_prefix = string.format("detail_%s_", i)
            local hotspot = content[key_prefix .. "hotspot"]
            local is_hover = hotspot.is_hover
            local hover_progress = hotspot.hover_progress or 0

            hover_progress = update_anim_progress(is_hover, hover_progress, dt, hover_speed)

            local icon_style = style[key_prefix .. "icon"]
            local text_style = style[key_prefix .. "text"]
            Colors.lerp_color_tables(icon_style.default_color, icon_style.hover_color, hover_progress, icon_style.color)
            Colors.lerp_color_tables(text_style.default_color, text_style.hover_color, hover_progress, text_style.text_color)

            hotspot.hover_progress = hover_progress
        end


    end
end

function VermitannicaDetailsWindow:_draw(dt)

    local ui_top_renderer = self.ui_top_renderer
    local ui_scenegraph = self.ui_scenegraph
    local input_service = self:input_service()
    local render_settings = self.render_settings

    UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

    local alpha_multiplier = render_settings.alpha_multiplier or 0

    render_settings.alpha_multiplier = alpha_multiplier

    for _, detail_widget in ipairs(self.frame_detail_widgets) do
        UIRenderer.draw_widget(ui_top_renderer, detail_widget)
    end

    for _, detail_panel in ipairs(self.detail_panels) do
        UIRenderer.draw_widget(ui_top_renderer, detail_panel)
    end

    UIRenderer.draw_widget(ui_top_renderer, self.widgets_by_name.window_background)

    UIRenderer.end_pass(ui_top_renderer)

end

function VermitannicaDetailsWindow:input_service()
    local parent = self.parent
    local params = self._window_params

    -- Use alternative function to retrieve the input service, if provided
    local override_func = params.input_service
    if override_func then
        return override_func(parent)
    end

    return self.parent:input_service()
end