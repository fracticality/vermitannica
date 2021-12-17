local mod = get_mod("vermitannica")

mod:dofile("scripts/mods/vermitannica/vermitannica_view/states/vermitannica_state_overview")
mod:dofile("scripts/mods/vermitannica/windows/vermitannica_menu_bar")
mod:dofile("scripts/mods/vermitannica/windows/vermitannica_previewer")

local definitions = mod:dofile("scripts/mods/vermitannica/vermitannica_view/vermitannica_view_definitions")
local widget_definitions = definitions.widgets
local viewport_definition = definitions.viewport_definition
local scenegraph_definition = definitions.scenegraph_definition
local settings_by_screen = definitions.settings_by_screen

local blocked_input_service = {
    get = function () return end,
    has = function () return end
}

---@class VermitannicaView
VermitannicaView = class(VermitannicaView)
VermitannicaView.NAME = "VermitannicaView"

VermitannicaView.init = function (self, ingame_ui_context)
    self.view_manager = VermitannicaManagers.view

    self.world = ingame_ui_context.world
    self.ui_renderer = ingame_ui_context.ui_renderer
    self.ui_top_renderer = ingame_ui_context.ui_top_renderer
    self.ingame_ui = ingame_ui_context.ingame_ui
    self.player_manager = ingame_ui_context.player_manager
    self.profile_synchronizer = ingame_ui_context.profile_synchronizer
    self.peer_id = ingame_ui_context.peer_id
    self.local_player_id = ingame_ui_context.local_player_id
    self.is_server = ingame_ui_context.is_server
    self.is_in_inn = ingame_ui_context.is_in_inn
    self.world_manager = ingame_ui_context.world_manager
    local world = self.world_manager:world("level_world")
    self.wwise_world = Managers.world:wwise_world(world)

    local input_manager = ingame_ui_context.input_manager
    input_manager:create_input_service("vermitannica_view", "IngameMenuKeymaps", "IngameMenuFilters")
    input_manager:map_device_to_service("vermitannica_view", "keyboard")
    input_manager:map_device_to_service("vermitannica_view", "mouse")
    input_manager:map_device_to_service("vermitannica_view", "gamepad")
    self.input_manager = input_manager

    self.units = {}
    self.attachment_units = {}
    self.unit_states = {}
    self.ui_animations = {}

    local state_machine_params = {
        wwise_world = self.wwise_world,
        ingame_ui_context = ingame_ui_context,
        parent = self,
        settings_by_screen = settings_by_screen,
        input_service = blocked_input_service,
    }
    self._state_machine_params = state_machine_params

    self.ingame_ui_context = ingame_ui_context
end

VermitannicaView.initial_profile_view = function (self)
    return self.ingame_ui.initial_profile_view
end

VermitannicaView._setup_state_machine = function (self, state_machine_params, optional_start_state, optional_start_sub_state, optional_params)
    if self._machine then
        self._machine:destroy()

        self._machine = nil
    end

    local start_state = optional_start_state or rawget(_G, settings_by_screen[1].state_name)
    state_machine_params.start_state = optional_start_sub_state
    state_machine_params.state_params = optional_params
    state_machine_params.world_previewer = self.world_previewer
    self._machine = GameStateMachine:new(self, start_state, state_machine_params)
    self._state_machine_params = state_machine_params
    state_machine_params.state_params = nil
end

VermitannicaView.wanted_state = function (self)
    return self._wanted_state
end

VermitannicaView.clear_wanted_state = function (self)
    self._wanted_state = nil
end

function VermitannicaView:input_service()
    return (self._input_blocked and blocked_input_service) or self.input_manager:get_service("vermitannica_view")
end

VermitannicaView.input_blocked = function (self)
    return self._input_blocked
end

VermitannicaView.set_input_blocked = function (self, blocked)
    self._input_blocked = blocked
end

VermitannicaView.play_sound = function (self, event)
    WwiseWorld.trigger_event(self.wwise_world, event)
end

VermitannicaView.create_ui_elements = function (self)
    local widgets = {}
    local widgets_by_name = {}

    self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

    local menu_bar_params = {
        parent = self,
        menu_items = settings_by_screen(),
        ui_top_renderer = self.ui_top_renderer
    }

    self.menu_bar = VermitannicaMenuBar:new(menu_bar_params)

    --for name, definition in pairs(widget_definitions) do
    --    local widget = UIWidget.init(definition)
    --    widgets[#widgets + 1] = widget
    --    widgets_by_name[name] = widget
    --end

    self._widgets = widgets
    self._widgets_by_name = widgets_by_name

    UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

    self.ui_animator = UIAnimator:new(self.ui_scenegraph, definitions.animation_definitions)
end

VermitannicaView.get_background_world = function (self)
    local previewer_pass_data = self.viewport_widget.element.pass_data[1]
    local viewport = previewer_pass_data.viewport
    local world = previewer_pass_data.world

    return world, viewport
end

VermitannicaView.show_player_world = function (self)
    if not self._draw_menu_world then
        self._draw_menu_world = true
        local viewport_name = "player_1"
        local world = Managers.world:world("level_world")
        local viewport = ScriptWorld.viewport(world, viewport_name)

        ScriptWorld.deactivate_viewport(world, viewport)
    end
end

VermitannicaView.hide_player_world = function (self)
    if self._draw_menu_world then
        self._draw_menu_world = false
        local viewport_name = "player_1"
        local world = Managers.world:world("level_world")
        local viewport = ScriptWorld.viewport(world, viewport_name)

        ScriptWorld.activate_viewport(world, viewport)
        ScriptWorld.deactivate_viewport(Managers.world:world("vermitannica_preview"), ScriptWorld.viewport(Managers.world:world("vermitannica_preview"), "vermitannica_preview_viewport"))
    end
end

VermitannicaView.show_hero_panel = function (self)
    self._draw_menu_panel = true

    self:set_input_blocked(false)
end

VermitannicaView.hide_hero_panel = function (self)
    self._draw_menu_panel = false

    self:set_input_blocked(true)
end

VermitannicaView.draw = function (self, dt, input_service)
    local ui_renderer = self.ui_renderer
    local ui_top_renderer = self.ui_top_renderer
    local ui_scenegraph = self.ui_scenegraph
    local input_manager = self.input_manager
    local gamepad_active = input_manager:is_device_active("gamepad")

    UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt)

    --if self._draw_menu_panel then
    --    UIRenderer.draw_widget(ui_top_renderer, self._exit_button_widget)
    --
    --    for _, widget in ipairs(self._static_widgets) do
    --        UIRenderer.draw_widget(ui_top_renderer, widget)
    --    end
    --end



    if self.viewport_widget and self._draw_menu_world then
        UIRenderer.draw_widget(ui_top_renderer, self.viewport_widget)
    end

    UIRenderer.end_pass(ui_top_renderer)
end

VermitannicaView.post_update = function (self, dt, t)
    self.menu_bar:post_update(dt, t)
    self._machine:post_update(dt, t)
    self.world_previewer:post_update(dt, t)
    if self.equipment_manager then
        self.equipment_manager:post_update()
    end
end

VermitannicaView.update = function (self, dt, t)
    if self.suspended or self.waiting_for_post_update_enter then
        return
    end

    local requested_screen_change_data = self._requested_screen_change_data

    if requested_screen_change_data then
        local screen_name = requested_screen_change_data.screen_name
        local sub_screen_name = requested_screen_change_data.sub_screen_name

        self:_change_screen_by_name(screen_name, sub_screen_name)

        self._requested_screen_change_data = nil
    end

    local input_manager = self.input_manager
    local input_blocked = self:input_blocked()
    local input_service = (input_blocked and blocked_input_service) or self:input_service()
    self._state_machine_params.input_service = input_service
    local transitioning = self:transitioning()

    self.ui_animator:update(dt)
    for name, ui_animation in pairs(self.ui_animations) do
        UIAnimation.update(ui_animation, dt)

        if UIAnimation.completed(ui_animation) then
            self.ui_animations[name] = nil
        end
    end

    if not transitioning then
        self:_handle_mouse_input(dt, t, input_service)
        self:_handle_exit(dt, input_service)
    end

    self._machine:update(dt, t)
    self.world_previewer:update(dt, t)
    self.menu_bar:update(dt, t)
    self:draw(dt, input_service)
end

function VermitannicaView:set_selected_enemy(enemy_name)
    self.selected_enemy_name = enemy_name
end

function VermitannicaView:selected_enemy()
    return self.selected_enemy_name
end

VermitannicaView.on_enter = function (self, params)
    ShowCursorStack.push()

    local input_manager = self.input_manager

    input_manager:block_device_except_service("vermitannica_view", "keyboard", 1)
    input_manager:block_device_except_service("vermitannica_view", "mouse", 1)
    input_manager:block_device_except_service("vermitannica_view", "gamepad", 1)

    local state_machine_params = self._state_machine_params
    state_machine_params.initial_state = true

    self:create_ui_elements()

    self.menu_bar:on_enter()

    self.waiting_for_post_update_enter = true
    self._on_enter_transition_params = params

    self:show_hero_panel()

    self.world_previewer = VermitannicaPreviewer:new(self.ingame_ui_context)

    self.world_previewer:force_stream_highest_mip_levels()

    self:play_sound("hud_in_inventory_state_on")

    self._draw_loading = false

end


VermitannicaView.set_current_hero = function (self, profile_index)
    local profile_settings = SPProfiles[profile_index]
    local display_name = profile_settings.display_name
    local character_name = profile_settings.character_name
    self._hero_name = display_name
    local state_machine_params = self._state_machine_params
    state_machine_params.hero_name = display_name

end

VermitannicaView._handle_mouse_input = function (self, dt, t, input_service)
    return
end

VermitannicaView.hotkey_allowed = function (self, input, mapping_data)
    if self:input_blocked() then
        return false
    end

    local transition_state = mapping_data.transition_state
    local transition_sub_state = mapping_data.transition_sub_state
    local state_machine = self._machine

    if state_machine then
        local current_state = state_machine:state()
        local current_state_name = current_state.NAME
        local current_screen_settings = self:_get_screen_settings_by_state_name(current_state_name)
        local name = current_screen_settings.name

        if name == transition_state then
            local active_sub_settings_name = current_state.active_settings_name and current_state:active_settings_name()

            if not transition_sub_state or transition_sub_state == active_sub_settings_name then
                return true
            elseif transition_sub_state then
                current_state:request_screen_change_by_name(transition_sub_state)
            end
        elseif transition_state then
            self:request_screen_change_by_name(transition_state, transition_sub_state)
        else
            return true
        end
    end

    return false
end

VermitannicaView._get_screen_settings_by_state_name = function (self, state_name)
    for index, screen_settings in ipairs(settings_by_screen()) do
        if screen_settings.state_name == state_name then
            return screen_settings
        end
    end
end

function VermitannicaView:request_screen_change_by_name(screen_name, sub_screen_name)

    if self:current_screen_name() ~= screen_name then
        self._requested_screen_change_data = {
            screen_name = screen_name,
            sub_screen_name = sub_screen_name
        }
    end


end

VermitannicaView._change_screen_by_name = function (self, screen_name, sub_screen_name, optional_params)

    local screen_settings = settings_by_screen()
    local settings
    for _, screen_settings in ipairs(screen_settings) do
        if screen_settings.name == screen_name then
            settings = screen_settings

            break
        end
    end

    --if not settings then
    --    local view_states = self.view_manager:view_states()
    --    for _, state_settings in ipairs(view_states) do
    --        if state_settings.name == screen_name then
    --            settings = state_settings
    --
    --            break
    --        end
    --    end
    --end

    if not settings then
        mod:error("No such state [%s]", screen_name)

        self:_change_screen_by_index(1)
        return
    end

    self.menu_bar:select_menu_item_by_name(screen_name)

    local state_name = settings.state_name
    local state = rawget(_G, state_name)

    if self._machine and not sub_screen_name then
        self._wanted_state = state
    else
        self:_setup_state_machine(self._state_machine_params, state, sub_screen_name, optional_params)
    end

    if settings.draw_background_world then
        self:show_player_world()
    else
        self:hide_player_world()
    end

    local camera_position = settings.camera_position
    if camera_position then
        self.world_previewer:set_camera_axis_offset("x", camera_position[1], 0.75, math.easeOutCubic)
        self.world_previewer:set_camera_axis_offset("y", camera_position[2], 0.75, math.easeOutCubic)
        self.world_previewer:set_camera_axis_offset("z", camera_position[3], 0.75, math.easeOutCubic)
    end

    local camera_rotation = settings.camera_rotation
    if camera_rotation then
        self.world_previewer:set_camera_rotation_axis_offset("x", camera_rotation[1], 0.75, math.easeOutCubic)
        self.world_previewer:set_camera_rotation_axis_offset("y", camera_rotation[2], 0.75, math.easeOutCubic)
        self.world_previewer:set_camera_rotation_axis_offset("z", camera_rotation[3], 0.75, math.easeOutCubic)
    end

    self.world_previewer:_set_hero_visibility(settings.draw_hero_unit or false)
    self.world_previewer:_set_enemy_visibility(settings.draw_enemy_unit or false)
end

VermitannicaView._change_screen_by_index = function (self, index)
    local screen_settings = settings_by_screen[index]
    local settings_name = screen_settings.name

    self:_change_screen_by_name(settings_name)
end

VermitannicaView.post_update_on_enter = function (self)
    self.viewport_widget = UIWidget.init(viewport_definition)
    self.waiting_for_post_update_enter = nil

    self.world_previewer:on_enter(self.viewport_widget, self._hero_name)

    local last_selected_enemy_name = mod:get("last_selected_enemy_name") or "skaven_clan_rat"
    self.world_previewer:request_spawn_enemy_unit(last_selected_enemy_name)
    self:set_selected_enemy(last_selected_enemy_name)

    local last_selected_career_name = mod:get("last_selected_career_name")
    if not last_selected_career_name then
        local player = self.player_manager:player(self.peer_id, self.local_player_id)
        local profile_index = player:profile_index()
        --local career_index = player:career_index()
        local profile_name = SPProfiles[profile_index].display_name
        self.equipment_manager = VermitannicaEquipmentManager:new({
            world_previewer = self.world_previewer
        }, player:profile_index(), player:career_index())
        self.equipment_manager:change_career(self.equipment_manager:get_career())
        --self.world_previewer:request_spawn_hero_unit(profile_name, career_index)
    end

    local on_enter_transition_params = self._on_enter_transition_params
    if on_enter_transition_params and on_enter_transition_params.menu_state_name then
        local menu_state_name = on_enter_transition_params.menu_state_name
        local menu_sub_state_name = on_enter_transition_params.menu_sub_state_name

        self:_change_screen_by_name(menu_state_name, menu_sub_state_name, on_enter_transition_params)

        self._on_enter_transition_params = nil
    else
        self:_change_screen_by_index(1)
    end
end

VermitannicaView.post_update_on_exit = function (self)
    if self.world_previewer then
        self.world_previewer:prepare_exit()
        self.world_previewer:on_exit()
        self.world_previewer = nil
    end

    if self.viewport_widget then
        UIWidget.destroy(self.ui_top_renderer, self.viewport_widget)

        self.viewport_widget = nil
    end
end

VermitannicaView.on_exit = function (self)
    self.input_manager:device_unblock_all_services("keyboard", 1)
    self.input_manager:device_unblock_all_services("mouse", 1)
    self.input_manager:device_unblock_all_services("gamepad", 1)

    if ShowCursorStack.stack_depth > 0 then
        ShowCursorStack.pop()
    end

    self.exiting = nil

    if self._machine then
        self._machine:destroy()

        self._machine = nil
    end

    self.menu_bar:on_exit()
    self.menu_bar = nil

    self:hide_player_world()
    self:play_sound("hud_in_inventory_state_off")
    self:play_sound("play_gui_amb_hero_screen_loop_end")
end

VermitannicaView.exit = function (self)
    local exit_transition = "exit_menu"

    self.ingame_ui:transition_with_fade(exit_transition)
    self:play_sound("play_hud_button_close")

    self.exiting = true
end

VermitannicaView.transitioning = function (self)
    return self.exiting or false
end

VermitannicaView.suspend = function (self)
    self.input_manager:device_unblock_all_services("keyboard", 1)
    self.input_manager:device_unblock_all_services("mouse", 1)
    self.input_manager:device_unblock_all_services("gamepad", 1)

    self.suspended = true
    local viewport_name = "player_1"
    local world = Managers.world:world("level_world")
    local viewport = ScriptWorld.viewport(world, viewport_name)

    ScriptWorld.activate_viewport(world, viewport)

    local previewer_pass_data = self.viewport_widget.element.pass_data[1]
    viewport = previewer_pass_data.viewport
    world = previewer_pass_data.world

    ScriptWorld.deactivate_viewport(world, viewport)
end

VermitannicaView.unsuspend = function (self)
    self.input_manager:block_device_except_service("vermitannica_view", "keyboard", 1)
    self.input_manager:block_device_except_service("vermitannica_view", "mouse", 1)
    self.input_manager:block_device_except_service("vermitannica_view", "gamepad", 1)

    self.suspended = nil

    if self.viewport_widget then
        local viewport_name = "player_1"
        local world = Managers.world:world("level_world")
        local viewport = ScriptWorld.viewport(world, viewport_name)

        ScriptWorld.deactivate_viewport(world, viewport)

        local previewer_pass_data = self.viewport_widget.element.pass_data[1]
        viewport = previewer_pass_data.viewport
        world = previewer_pass_data.world

        ScriptWorld.activate_viewport(world, viewport)
    end
end

VermitannicaView._handle_exit = function (self, dt, input_service)
    local esc_pressed = input_service:get("toggle_menu")
    local exit_button = self._widgets_by_name.exit_button

    if esc_pressed or self:_is_button_pressed(exit_button) then
        self:play_sound("Play_hud_hover")
        self:exit()

        return
    end

end

VermitannicaView.close_menu = function (self, return_to_main_screen)
    local return_to_game = not return_to_main_screen

    self:exit(return_to_game)
end

VermitannicaView.destroy = function (self)
    if self.viewport_widget then
        UIWidget.destroy(self.ui_top_renderer, self.viewport_widget)

        self.viewport_widget = nil
    end

    self.ingame_ui_context = nil
    self.ui_animator = nil
    local viewport_name = "player_1"
    local world = Managers.world:world("level_world")
    local viewport = ScriptWorld.viewport(world, viewport_name)

    ScriptWorld.activate_viewport(world, viewport)

    if self._machine then
        self._machine:destroy()

        self._machine = nil
    end
end

VermitannicaView._is_button_pressed = function (self, widget)
    if not widget then
        return
    end

    local button_hotspot = widget.content.button_hotspot

    if button_hotspot.on_release then
        button_hotspot.on_release = false

        return true
    end
end

VermitannicaView.current_state = function (self)
    return self._machine:state()
end

function VermitannicaView:current_screen_name()
    local current_state = self:current_state()
    local current_state_name = current_state and current_state.NAME
    local current_screen_settings = self:_get_screen_settings_by_state_name(current_state_name)
    local current_screen_name = current_screen_settings and current_screen_settings.name

    return current_screen_name
end