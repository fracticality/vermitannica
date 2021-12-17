local mod = get_mod("vermitannica")

mod:dofile("scripts/mods/vermitannica/windows/vermitannica_list_window")
mod:dofile("scripts/mods/vermitannica/windows/vermitannica_details_window")

local definitions = mod:dofile("scripts/mods/bestiary/bestiary_state_overview_definitions")
local scenegraph_definition = definitions.scenegraph_definition
local widget_definitions = definitions.widget_definitions
local area_detail_widget_definitions = definitions.area_detail_widget_definitions
local animation_definitions = definitions.animation_definitions

local detail_panel_settings = definitions.detail_panel_settings
local detail_panel_layouts = detail_panel_settings.detail_panel_layouts

local breed_data_by_name = definitions.breed_data_by_name
local breed_data_sorted = definitions.breed_data_sorted

local default_camera_offset = { x = -0.3, y = 2.8, z = 1.05 }
local camera_offset_by_breed = {
    beastmen_bestigor = { x = -0.3, y = 3.05, z = 1.30 },
    beastmen_minotaur = { x = -0.3, y = 3.80, z = 1.80 },
    beastmen_standard_bearer = { x = -0.3, y = 3.05, z = 1.30 },
    chaos_troll = { x = -0.3, y = 3.95, z = 1.7 },
    chaos_spawn_exalted_champion_norsca = { x = -0.3, y = 3.8, z = 1.55 },
    chaos_exalted_sorcerer = { x = -0.3, y = 3.2, z = 1.3 },
    chaos_exalted_champion_warcamp = { x = -0.3, y = 3.2, z = 1.45 },
    chaos_warrior = { x = -0.3, y = 2.9, z = 1.3 },
    chaos_exalted_champion_norsca = { x = -0.3, y = 3.2, z = 1.45 },
    chaos_exalted_sorcerer_drachenfels = { x = -0.3, y = 3.2, z = 1.3 },
    chaos_spawn = { x = -0.3, y = 3.95, z = 1.7 },
    skaven_stormfiend = { x = -0.3, y = 3.95, z = 1.7 },
    skaven_stormfiend_boss = { x = -0.3, y = 3.95, z = 1.7 },
    skaven_rat_ogre = { x = -0.3, y = 3.45, z = 1.45 },
    skaven_storm_vermin_warlord = { x = -0.3, y = 3.2, z = 1.45 }
}

local blocked_input_service = {
    get = function () return end,
    has = function () return end
}

BestiaryStateOverview = class(BestiaryStateOverview)
BestiaryStateOverview.NAME = "BestiaryStateOverview"

function BestiaryStateOverview:on_enter(state_machine_params)

    mod:debug("[%s] on_enter", self.NAME)

    local ingame_ui_context = state_machine_params.ingame_ui_context
    self.parent = state_machine_params.parent
    self.world_previewer = state_machine_params.world_previewer
    self.wwise_world = state_machine_params.wwise_world
    self.ui_top_renderer = ingame_ui_context.ui_top_renderer
    self.ingame_ui_context = ingame_ui_context

    self.ui_animations = {}
    self.render_settings = {
        alpha_multiplier = 0,
        snap_pixel_positions = true
    }
    local difficulty_index = mod:get("difficulty_index")
    if not difficulty_index then
        local player_manager = ingame_ui_context.player_manager
        local peer_id = ingame_ui_context.peer_id
        local local_player_id = ingame_ui_context.local_player_id
        local player = player_manager:player(peer_id, local_player_id)

        if player:sync_data_active() then
            local difficulty_id = player:get_data("highest_unlocked_difficulty")
            local highest_difficulty = NetworkLookup.difficulties[difficulty_id]
            local highest_difficulty_settings = DifficultySettings[highest_difficulty]
            local highest_difficulty_rank = math.min(highest_difficulty_settings.rank, #DefaultDifficulties)
            difficulty_index = highest_difficulty_rank
        end
    end
    self.difficulty_index = difficulty_index

    self:_create_ui_elements()
    self:_start_transition_animation("on_enter")

    self.initial_wanted_enemy = self.parent:selected_enemy()
end

function BestiaryStateOverview:difficulty_rank()
    local difficulty_name = DefaultDifficulties[self.difficulty_index]
    local difficulty_settings = DifficultySettings[difficulty_name]

    return difficulty_settings.rank
end

function BestiaryStateOverview:_create_ui_elements()

    self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

    self.window_params = {
        parent = self,
        input_service = self.window_input_service,
        ui_top_renderer = self.ui_top_renderer,
        ui_scenegraph = self.ui_scenegraph
    }

    widget_definitions.more_details_button.style.button_hotspot = {}
    local passes = widget_definitions.more_details_button.element.passes
    for i, pass_data in ipairs(passes) do
        if pass_data.style_id and pass_data.style_id == "texture_hover_id" then
            pass_data.texture_id = "selected_texture"

            break
        end
    end

    self.widgets = {}
    self.widgets_by_name = {}
    UIUtils.create_widgets(widget_definitions, self.widgets, self.widgets_by_name)


    self.area_left_detail_widgets = {}
    self.area_left_detail_widgets_by_name = {}
    UIUtils.create_widgets(area_detail_widget_definitions.left, self.area_left_detail_widgets, self.area_left_detail_widgets_by_name)

    self:_create_difficulty_selector()

    self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

    UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

end

function BestiaryStateOverview:_create_difficulty_selector()

    local difficulties = DefaultDifficulties
    local difficulty_selector_widgets = {}
    for i, difficulty_name in ipairs(difficulties) do
        local difficulty_settings = DifficultySettings[difficulty_name]

        local size = scenegraph_definition.difficulty_selector_root.size

        local widget_definition = UIWidgets.create_icon_button("difficulty_selector_root",
            size, nil, nil,
            difficulty_settings.display_image)

        local num_passes = #widget_definition.element.passes
        widget_definition.element.passes[num_passes + 1] = {
            pass_type = "additional_option_tooltip",
            additional_option_id = "tooltip",
            content_passes = {
                "additional_option_info"
            },
            style_id = "tooltip",
            content_check_function = function (content)
                local hotspot = content.button_hotspot
                return hotspot.is_hover
            end
        }

        widget_definition.content.tooltip = {
            title = Localize(difficulty_settings.display_name),
            description = ""
        }

        widget_definition.style.tooltip = {
            vertical_alignment = "top",
            horizontal_alignment = "center",
            grow_downwards = false,
            max_width = 150,
            offset = { 0, 10, 0 }
        }

        widget_definition.style.texture_icon.texture_size = { 75, 75 }

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

        widget_definition.element.passes[num_passes + 2] = {
            pass_type = "texture_frame",
            texture_id = "selection_frame",
            style_id = "selection_frame",
            content_check_function = function (content)
                return content.button_hotspot.is_selected
            end
        }

        widget_definition.content.selection_frame = selection_frame_settings.texture

        widget_definition.style.selection_frame = {
            texture_size = selection_frame_settings.texture_size,
            texture_sizes = selection_frame_settings.texture_sizes,
            color = { 255, 255, 255, 255 },
            size = selection_frame_size,
            offset = selection_frame_offset,
        }

        local widget = UIWidget.init(widget_definition)
        local offset = widget.offset

        offset = {
            (i - 1) * 112,
            offset[2],
            offset[3]
        }
        widget.offset = offset
        widget.default_offset = table.clone(offset)

        difficulty_selector_widgets[#difficulty_selector_widgets + 1] = widget

    end

    self.difficulty_selector_widgets = difficulty_selector_widgets

end

function BestiaryStateOverview:_start_transition_animation(animation_name, widgets)
    local params = {
        render_settings = self.render_settings
    }
    widgets = widgets or {
        widgets_by_name = self.widgets_by_name,
        difficulty_selector_widgets = self.difficulty_selector_widgets
    }
    local anim_id = self.ui_animator:start_animation(animation_name, widgets, scenegraph_definition, params)
    self.ui_animations[animation_name] = anim_id
end

function BestiaryStateOverview:_draw(dt, input_service)
    local ui_top_renderer = self.ui_top_renderer
    local ui_scenegraph = self.ui_scenegraph
    local render_settings = self.render_settings

    UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt, nil, render_settings)

    local alpha_multiplier = render_settings.alpha_multiplier or 0

    render_settings.alpha_multiplier = alpha_multiplier

    for _, widget in ipairs(self.widgets) do
        UIRenderer.draw_widget(ui_top_renderer, widget)
    end

    for _, widget in ipairs(self.area_left_detail_widgets) do
        UIRenderer.draw_widget(ui_top_renderer, widget)
    end

    for _, widget in ipairs(self.difficulty_selector_widgets) do
        UIRenderer.draw_widget(ui_top_renderer, widget)
    end

    render_settings.alpha_multiplier = alpha_multiplier

    UIRenderer.end_pass(ui_top_renderer)

end

function BestiaryStateOverview:play_sound(sound_event)
    self.parent:play_sound(sound_event)
end

function BestiaryStateOverview:input_service()
    return (self._input_blocked and blocked_input_service) or self.parent:input_service()
end

function BestiaryStateOverview:window_input_service()
    return (self._window_input_blocked and blocked_input_service) or self:input_service()
end

function BestiaryStateOverview:update(dt, t)

    local wanted_state = self.parent:wanted_state()
    if wanted_state then
        self.parent:clear_wanted_state()

        return wanted_state
    end

    local input_service = self:input_service()

    local friends_ui_component = self._friends_ui_component
    if friends_ui_component and Managers.account:is_online() then
        friends_ui_component:update(dt, input_service)

        self._window_input_blocked = friends_ui_component:is_active()
    end

    local enemy_list_window = self.enemy_list_window
    if enemy_list_window then

        enemy_list_window:update(dt, t)

        local wanted_enemy = enemy_list_window:selected_item()
        if wanted_enemy ~= self.selected_enemy then
            self:_select_enemy(wanted_enemy)
        end

    end

    if self.enemy_detail_window then
        self.enemy_detail_window:update(dt, t)
    end


    self:_handle_input(dt, t)
    self:_draw(dt, input_service)

end

function BestiaryStateOverview:_select_enemy(wanted_enemy_name)

    self.selected_enemy = wanted_enemy_name

    if not wanted_enemy_name then
        self.enemy_detail_window = nil
    else
        mod:set("last_selected_enemy_name", wanted_enemy_name)

        local enemy = breed_data_by_name[wanted_enemy_name]

        self.enemy_detail_window = VermitannicaDetailsWindow:new()
        self.enemy_detail_window:on_enter(self.window_params, {
            name = enemy.display_name,
            detail_panels = detail_panel_layouts.details(enemy, self:difficulty_rank())
        })

        local parent_selection = self.parent:selected_enemy()
        if not parent_selection or parent_selection ~= wanted_enemy_name then
            self.world_previewer:request_spawn_enemy_unit(wanted_enemy_name, nil, true)

            if self.is_expanded then
                local axis_offset = camera_offset_by_breed[self.selected_enemy] or default_camera_offset
                self.world_previewer:set_camera_axis_offset("x", axis_offset.x, 0.75)
                self.world_previewer:set_camera_axis_offset("y", axis_offset.y, 0.75)
                self.world_previewer:set_camera_axis_offset("z", axis_offset.z, 0.75)
            end
        end

        self.parent:set_selected_enemy(wanted_enemy_name)
    end

end

function BestiaryStateOverview:_handle_input()

    local more_details_button = self.widgets_by_name.more_details_button
    if UIUtils.is_button_hover_enter(more_details_button) then
        self:play_sound("Play_hud_hover")
    end
    if UIUtils.is_button_pressed(more_details_button) then

        if self.enemy_list_window then
            self.enemy_list_window:toggle_size()
        end

        self.is_expanded = not self.is_expanded

        local animation_name = string.format("area_left_%s", self.is_expanded and "collapse" or "expand")
        self:_start_transition_animation(animation_name)

        if self.is_expanded then
            self:play_sound("Play_hud_button_open")
            self.world_previewer:request_browser_mode("enemy_browser")

            local axis_offset = camera_offset_by_breed[self.selected_enemy] or default_camera_offset
            self.world_previewer:set_camera_axis_offset("x", axis_offset.x, 0.75)
            self.world_previewer:set_camera_axis_offset("y", axis_offset.y, 0.75)
            self.world_previewer:set_camera_axis_offset("z", axis_offset.z, 0.75)
        else
            self:play_sound("Play_hud_button_close")
            self.world_previewer:request_browser_mode()
            self.world_previewer:set_camera_axis_offset("x", 0.00, 0.75)
            self.world_previewer:set_camera_axis_offset("y", 4.00, 0.75)
            self.world_previewer:set_camera_axis_offset("z", 1.55, 0.75)
        end
    end

    for i, difficulty_selector in ipairs(self.difficulty_selector_widgets) do
        if UIUtils.is_button_hover_enter(difficulty_selector) then
            self:play_sound("Play_hud_hover")
        end

        if UIUtils.is_button_pressed(difficulty_selector) and i ~= self.difficulty_index then

            self:play_sound("Play_hud_select")

            self.difficulty_index = i
            mod:set("difficulty_index", i)

            local difficulty_rank = self:difficulty_rank()

            local enemy_list_window = ListWindow:new()
            enemy_list_window:on_enter(self.window_params, detail_panel_layouts.list(breed_data_sorted, difficulty_rank))
            enemy_list_window:select_item_by_id(self.selected_enemy)
            if self.is_expanded then
                enemy_list_window:toggle_size()
            end
            self.enemy_list_window = enemy_list_window

            local enemy = breed_data_by_name[self.selected_enemy]
            self.enemy_detail_window:on_enter(self.window_params, {
                name = enemy.display_name,
                detail_panels = detail_panel_layouts.details(enemy, difficulty_rank)
            })
        end

        difficulty_selector.content.button_hotspot.is_selected = i == self.difficulty_index
    end

end

function BestiaryStateOverview:post_update(dt)

    self:_update_animations(dt)

    if self.enemy_list_window then
        self.enemy_list_window:post_update(dt)
    else
        self.enemy_list_window = ListWindow:new()
        self.enemy_list_window:on_enter(self.window_params, detail_panel_layouts.list(breed_data_sorted, self:difficulty_rank()))

        local initial_wanted_enemy = self.initial_wanted_enemy
        if initial_wanted_enemy then
            self.enemy_list_window:select_item_by_id(initial_wanted_enemy)

            self.initial_wanted_enemy = nil
        end
    end

    if self.enemy_detail_window then
        self.enemy_detail_window:post_update(dt)
    end
end

function BestiaryStateOverview:_update_animations(dt)

    local ui_animator = self.ui_animator
    ui_animator:update(dt)

    local animations = self.ui_animations
    for anim_name, anim_id in pairs(animations) do
        if ui_animator:is_animation_completed(anim_id) then
            ui_animator:stop_animation(anim_id)

            animations[anim_name] = nil
        end
    end

    --UIWidgetUtils.animate_icon_button(self.widgets_by_name.more_details_button, dt)
    --self:_animate_text_buttons(dt)
    UIWidgetUtils.animate_arrow_button(self.widgets_by_name.more_details_button, dt)

    for _, widget in ipairs(self.difficulty_selector_widgets) do
        UIWidgetUtils.animate_icon_button(widget, dt)
    end

end

function BestiaryStateOverview:_animate_text_buttons(dt)
    local text_buttons = { }
    for _, text_button in ipairs(text_buttons) do
        local content = text_button.content
        local style = text_button.style
        local hotspot = content.button_hotspot
        local is_hover = hotspot.is_hover
        local is_selected = hotspot.is_selected
        local hover_progress = hotspot.hover_progress or 0
        local selection_progress = hotspot.selection_progress or 0
        local hover_speed = 8
        local selection_speed = 10


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

        local label_text_style = style.label_text
        local label_text_text_color = label_text_style.text_color
        local label_text_default_text_color = label_text_style.default_text_color
        local label_text_hover_text_color = label_text_style.hover_text_color
        local label_text_selected_text_color = label_text_style.selected_text_color
        Colors.lerp_color_tables(label_text_default_text_color, label_text_hover_text_color, hover_progress, label_text_text_color)
        Colors.lerp_color_tables(label_text_text_color, label_text_selected_text_color, selection_progress, label_text_text_color)

        local combined_progress = math.max(hover_progress, selection_progress)
        local texture_hover_style = style.texture_hover
        Colors.lerp_color_tables(texture_hover_style.default_color, texture_hover_style.hover_color, combined_progress, texture_hover_style.color)

        hotspot.hover_progress = hover_progress
        hotspot.selection_progress = selection_progress
    end
end

function BestiaryStateOverview:on_exit()

    mod:debug("[%s] on_exit", self.NAME)

    if self.enemy_list_window then
        self.enemy_list_window:on_exit()
    end

    self.world_previewer:request_browser_mode()

    local friends_ui_component = self._friends_ui_component
    if friends_ui_component and friends_ui_component:is_active() then
        friends_ui_component:deactivate_friends_ui()
    end

end