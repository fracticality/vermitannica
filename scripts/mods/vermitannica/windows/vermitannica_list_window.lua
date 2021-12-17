local mod = get_mod("vermitannica")

local definitions = mod:dofile("scripts/mods/vermitannica/windows/definitions/vermitannica_list_window_definitions")
local enemy_definitions = definitions.enemy_definitions
local scenegraph_definition = definitions.scenegraph_definition
local list_widget_definitions = definitions.list_widget_definitions
local list_detail_widget_definitions = definitions.list_detail_widget_definitions
local animation_definitions = definitions.animation_definitions
local card_templates = definitions.card_templates
local list_widget_template = definitions.list_widget_template

ListWindow = class(ListWindow)
ListWindow.NAME = "VermitannicaListWindow"

function ListWindow:init(params)

    if not params then
        return
    end

    self.custom_create_func = params.custom_create_func

end

function ListWindow:on_enter(window_params, list_item_data)

    mod:debug("[%s] on_enter", self.NAME)

    self.parent = window_params.parent
    self.ui_top_renderer = window_params.ui_top_renderer
    self._window_params = window_params
    self.list_item_data = list_item_data

    self.ui_animations = {}
    self.render_settings = {
        alpha_multiplier = 0,
        list_alpha_multiplier = 0,
        snap_pixel_positions = true
    }

    scenegraph_definition.list_window.parent = "area_left_large"

    self:_create_ui_elements()
    self:_start_transition_animation("on_enter")

    self:_initialize_scrollbar()
    self:_start_transition_animation("on_list_initialized")

end

function ListWindow:_scroll_to_list_item(id)
    local scrollbar_logic = self.scrollbar_logic
    local enabled = scrollbar_logic:enabled()

    if enabled then
        local scroll_percentage = scrollbar_logic:get_scroll_percentage()
        local scrolled_length = scrollbar_logic:get_scrolled_length()
        local scroll_length = scrollbar_logic:get_scroll_length()
        local list_window_size = self.ui_scenegraph.list_window.size
        local draw_length = list_window_size[2]
        local draw_start_height = scrolled_length
        local draw_end_height = draw_start_height + draw_length
        local list_items = self.list_items

        if list_items then
            local widget
            for i, list_item in ipairs(list_items) do
                if list_item.content.id == id then
                    widget = list_item
                end
            end

            if not widget then
                return
            end

            local content = widget.content
            local offset = widget.offset
            local size = content.size
            local height = size[2]
            local start_position_top = math.abs(offset[2])
            local start_position_bottom = start_position_top + height

            local percentage_difference
            if draw_end_height < start_position_bottom then
                local height_missing = start_position_bottom - draw_end_height
                percentage_difference = math.clamp(height_missing / scroll_length, 0, 1)
            elseif start_position_top < draw_start_height then
                local height_missing = draw_start_height - start_position_top
                percentage_difference = -math.clamp(height_missing / scroll_length, 0, 1)
            end

            if percentage_difference then
                scroll_percentage = math.clamp(scroll_percentage + percentage_difference, 0, 1)

                scrollbar_logic:set_scroll_percentage(scroll_percentage)
            else
                -- This fixes abnormal spacing when toggling size
                scrollbar_logic:set_scroll_percentage(scroll_percentage + 0.00000001)
            end
        end
    end
end

function ListWindow:_create_ui_elements()

    self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
    --self.ui_scenegraph = self._window_params.ui_scenegraph

    local padding = 10
    local widget_pos_x = 0
    local widget_pos_y = 0
    local row = 1
    local col = 1

    local list_window_width = UISceneGraph.get_size(self.ui_scenegraph, "list_window")[1]
    local list_items = {}
    local list_item_data = self.list_item_data
    local content_assignment_func = self.content_assignment_func
    for _, list_item in ipairs(list_item_data) do

        local widget_definition = list_widget_template(scenegraph_definition.item_root.size)
        local widget = UIWidget.init(widget_definition)

        local offset = widget.offset
        local content = widget.content
        local size = content.size

        if content_assignment_func then
            content_assignment_func(content, list_item)
        else
            local current_detail_set = 1
            content.details_content = list_item.details_content
            content.current_detail_set = current_detail_set

            for i, detail in ipairs(list_item.details_content[current_detail_set]) do
                local key = string.format("detail_%s_", i)
                content[key .. "icon"] = detail.icon
                content[key .. "text"] = detail.text
            end

            for key, value in pairs(list_item.content) do
                content[key] = value
            end
        end

        if widget_pos_x + size[1] > list_window_width then
            row = row + 1
            col = 1
            widget_pos_x = 0
            widget_pos_y = widget_pos_y - (size[2] + padding)
        end

        offset[1] = widget_pos_x
        offset[2] = widget_pos_y
        widget.default_offset = table.clone(offset)
        content.row = row
        content.col = col

        widget_pos_x = widget_pos_x + size[1] + padding
        col = col + 1

        list_items[#list_items + 1] = widget
    end
    self.list_items = list_items

    self.total_list_height = math.abs(widget_pos_y - scenegraph_definition.item_root.size[2])

    self.list = UIWidget.init(list_widget_definitions.list)
    self.list_scrollbar = UIWidget.init(list_widget_definitions.list_scrollbar)
    self.scrollbar_logic = ScrollBarLogic:new(self.list_scrollbar)

    self.list_background = UIWidget.init(
            UIWidgets.create_rect_with_outer_frame("list_window", scenegraph_definition[scenegraph_definition.list_window.parent].size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color)
    )

    self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

    UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

end

function ListWindow:toggle_size()

    local parent_scenegraph_id = scenegraph_definition.list_window.parent
    if parent_scenegraph_id == "area_left_large" then
        scenegraph_definition.list_window.parent = "area_left"
        scenegraph_definition.list_window_background.parent = "area_left"
    else
        scenegraph_definition.list_window.parent = "area_left_large"
        scenegraph_definition.list_window_background.parent = "area_left_large"
    end


    self:_create_ui_elements()
    self:_start_transition_animation("on_enter")

    self:_initialize_scrollbar()
    self:_start_transition_animation("on_list_initialized")

    self:select_item_by_id(self.selected_list_item)

end

function ListWindow:_cycle_item_details(target)
    local widgets = target and { target } or self.list_items
    for _, widget in ipairs(widgets) do
        local content = widget.content
        local detail_sets = content.details_content
        local detail_set_num = content.current_detail_set or 1

        detail_set_num = detail_set_num + 1
        if detail_set_num > #detail_sets then
            detail_set_num = 1
        end

        local detail_set = detail_sets[detail_set_num]
        for i, detail in ipairs(detail_set) do
            local key = string.format("detail_%s_", i)
            content[key .. "icon"] = detail.icon
            content[key .. "text"] = detail.text
        end

        content.current_detail_set = detail_set_num
    end
end

function ListWindow:_start_transition_animation(animation_name, widgets)

    local params = {
        render_settings = self.render_settings,
    }

    widgets = widgets or {
        widgets_by_name = { list = self.list },
        list_items = self.list_items
    }

    local anim_id = self.ui_animator:start_animation(animation_name, widgets, scenegraph_definition, params)
    self.ui_animations[animation_name] = anim_id

end

function ListWindow:_draw(dt)

    local ui_top_renderer = self.ui_top_renderer
    local ui_scenegraph = self.ui_scenegraph
    local input_service = self:input_service()
    local render_settings = self.render_settings

    UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

    local alpha_multiplier = render_settings.alpha_multiplier or 0
    local list_alpha_multiplier = render_settings.list_alpha_multiplier or 0

    render_settings.alpha_multiplier = alpha_multiplier

    UIRenderer.draw_widget(ui_top_renderer, self.list)
    UIRenderer.draw_widget(ui_top_renderer, self.list_scrollbar)
    UIRenderer.draw_widget(ui_top_renderer, self.list_background)

    local list_items = self.list_items
    if list_items then

        render_settings.alpha_multiplier = math.min(alpha_multiplier, list_alpha_multiplier)
        local render_all = self:_update_visible_list_entries()

        for i, widget in ipairs(list_items) do
            if render_all or widget.content.visible then
                UIRenderer.draw_widget(ui_top_renderer, widget)
            end
        end

    end

    render_settings.alpha_multiplier = alpha_multiplier

    UIRenderer.end_pass(ui_top_renderer)

end

function ListWindow:input_service()

    local parent = self.parent
    local params = self._window_params

    -- Use alternative function to retrieve the input service, if provided
    local override_func = params.input_service
    if override_func then
        return override_func(parent)
    end

    return self.parent:input_service()

end

function ListWindow:_update_visible_list_entries()

    local scrollbar_logic = self.scrollbar_logic
    local enabled = scrollbar_logic:enabled()

    if not enabled then
        return true
    end

    local scrolled_length = scrollbar_logic:get_scrolled_length()
    local list_window_size = self.ui_scenegraph.list_window.size
    local draw_padding = 20
    local draw_length = list_window_size[2] + draw_padding

    local list_items = self.list_items
    for _, list_item in ipairs(list_items) do
        local offset = list_item.offset
        local content = list_item.content
        local size = content.size
        local position = math.abs(offset[2]) + size[2]
        local is_outside = false

        if position < scrolled_length - draw_padding then
            is_outside = true
        elseif draw_length < math.abs(offset[2]) - scrolled_length then
            is_outside = true
        end

        content.visible = not is_outside
    end

end

function ListWindow:update(dt, t)

    self:_handle_input(dt, t)
    self:_draw(dt)

end

function ListWindow:_initialize_scrollbar()

    local list_window_size = self.ui_scenegraph.list_window.size
    local list_scrollbar_size = scenegraph_definition.list_scrollbar.size
    local draw_height = list_window_size[2]
    local content_height = self.total_list_height
    local scrollbar_height = list_scrollbar_size[2]
    local step_size = 180
    local scroll_step_multiplier = 1
    local scrollbar_logic = self.scrollbar_logic

    scrollbar_logic:set_scrollbar_values(draw_height, content_height, scrollbar_height, step_size, scroll_step_multiplier)
    scrollbar_logic:set_scroll_percentage(0)

end

function ListWindow:hovered_item()
    return self.hovered_list_item
end

function ListWindow:selected_item()
    return self.selected_list_item
end

function ListWindow:_handle_input(dt, t)

    self:_update_scroll_position(dt, t)

    if self:_is_list_hovered() then
        self:_handle_list_item_input(dt, t)
    end

end

function ListWindow:_is_list_hovered()
    local list_mask = self.list

    return list_mask.content.list_hotspot.is_hover or false
end

function ListWindow:_update_scroll_position(dt, t)
    local scrollbar_logic = self.scrollbar_logic
    scrollbar_logic:update(dt, t)

    local length = scrollbar_logic:get_scrolled_length()
    if length ~= self.scrolled_length then
        self.ui_scenegraph.list.local_position[2] = length
        self.scrolled_length = length
    end
end

function ListWindow:select_item_by_id(id)

    for _, list_item in ipairs(self.list_items) do
        local content = list_item.content
        local hotspot = content.button_hotspot
        local is_selected = content.id == id
        hotspot.is_selected = is_selected
    end

    self.selected_list_item = id

    if id then
        self:_scroll_to_list_item(id)
    end
end

function ListWindow:_handle_list_item_input(dt, t)
    for _, list_item in ipairs(self.list_items) do
        local id = list_item.content.id

        if UIUtils.is_button_hover_enter(list_item) and self.selected_list_item ~= id then
            self.parent:play_sound("Play_hud_hover")
            self.hovered_list_item = list_item.content.id
        end

        if list_item.content.button_hotspot.is_hover then
            if self:input_service():get("right_press") then
                self.parent:play_sound("Play_hud_hover")
                self:_cycle_item_details(list_item)
            end
        end

        local is_pressed = UIUtils.is_button_pressed(list_item)
        if is_pressed and id ~= self.selected_list_item then
            self.parent:play_sound("Play_hud_select")

            self:select_item_by_id(id)
        end

        if list_item.content.button_hotspot.on_hover_exit then
            self.hovered_list_item = nil
        end
    end
end

function ListWindow:post_update(dt)

    self:_update_animations(dt)

end

function ListWindow:_update_animations(dt)

    local animations = self.ui_animations
    local ui_animator = self.ui_animator

    ui_animator:update(dt)

    for anim_name, anim_id in pairs(animations) do
        if ui_animator:is_animation_completed(anim_id) then

            if anim_name == "on_exit" then
                self.on_exit_completed = true
            end

            animations[anim_name] = nil
        end
    end

    self:_animate_list_items(dt)

end

local function update_anim_progress(condition, progress, dt, speed)

    if condition then
        return math.min(progress + dt * (speed or 1), 1)
    else
        return math.max(progress - dt * (speed or 1), 0)
    end

end

function ListWindow:_animate_list_items(dt)

    local is_list_hovered = self:_is_list_hovered()

    local list_items = self.list_items
    for i, list_item in ipairs(list_items) do
        local content = list_item.content
        local style = list_item.style

        local hotspot = content.button_hotspot
        local is_hover = is_list_hovered and hotspot.is_hover
        local is_selected = hotspot.is_selected
        local hover_progress = hotspot.hover_progress or 0
        local selection_progress = hotspot.selection_progress or 0

        local hover_speed = 5
        local selection_speed = 10

        hover_progress = update_anim_progress(is_hover, hover_progress, dt, hover_speed)
        selection_progress = update_anim_progress(is_selected, selection_progress, dt, selection_speed)

        style.overlay.color[1] = 80 - 80 * math.max(hover_progress, selection_progress)
        style.selection_frame.color[1] = 255 * selection_progress

        hotspot.hover_progress = hover_progress
        hotspot.selection_progress = selection_progress
    end

end

function ListWindow:on_exit()

    mod:debug("[%s] on_exit", self.NAME)

    self:_start_transition_animation("on_exit")

end