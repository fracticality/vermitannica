local mod = get_mod("vermitannica")

local Unit_alive = Unit.alive
local Unit_set_unit_visibility = Unit.set_unit_visibility

local pi_2 = math.pi * 2

local DEFAULT_ANGLE = -math.degrees_to_radians(45)

local default_unit_look_target = { 0, 5, 1 }
local focus_unit_home = { 0, 0, 0 }
local hero_unit_home = { 1.25, 0, 0 }
local enemy_unit_home = { -1.25, 0, 0 }
local look_target_home = { 0, 5, 1 }

VermitannicaPreviewer = class(VermitannicaPreviewer)
VermitannicaPreviewer.NAME = "VermitannicaPreviewer"
------------------------------------------------------------------------------------------------------------------------
--- LIFECYCLE METHODS --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
function VermitannicaPreviewer:init()

    local slots_by_name = InventorySettings.slots_by_name
    local equipment_data = {}
    equipment_data[slots_by_name.slot_melee] = {}
    equipment_data[slots_by_name.slot_ranged] = {}
    equipment_data[slots_by_name.slot_skin] = {}
    equipment_data[slots_by_name.slot_hat] = {}

    self._hero_data = {
        unit = nil,
        equipment_data = equipment_data,
        hidden_units = {},
        requested_mip_streaming_units = {},
        params = {
            xy_angle = DEFAULT_ANGLE,
            xy_angle_target = DEFAULT_ANGLE,
            look = table.shallow_copy(look_target_home),
            look_target = table.shallow_copy(look_target_home),
            spawn_home = hero_unit_home
        }
    }

    self._enemy_data = {
        unit = nil,
        inventory_data = {},
        hidden_units = {},
        requested_mip_streaming_units = {},
        params = {
            xy_angle = -DEFAULT_ANGLE,
            xy_angle_target = -DEFAULT_ANGLE,
            look = table.shallow_copy(look_target_home),
            look_target = table.shallow_copy(look_target_home),
            spawn_home = enemy_unit_home
        }
    }

    self._hero_weapon_data = {
        unit = nil,
        hidden_units = {}
    }

    self._units_data = {
        self._hero_data,
        self._enemy_data,
        self._hero_weapon_data
    }

    self._default_camera_params = {
        x_pan = 0,
        x_pan_target = 0,
        z_pan = 0,
        z_pan_target = 0,
        zoom = 1,
        zoom_target = 1,
    }

    self._default_camera_look_target = { x = 0, y = 0, z = 0.9 }
    self._default_camera_animation_data = {
        x = { value = 0 },
        y = { value = 0 },
        z = { value = 0 }
    }

    self:_load_packages({"resource_packages/inventory"})
end

VermitannicaPreviewer.init = function (self, ingame_ui_context)
    self.profile_synchronizer = ingame_ui_context.profile_synchronizer
    self.input_manager = ingame_ui_context.input_manager
    self.ui_renderer = ingame_ui_context.ui_renderer

    self.hero_unit = nil
    self._item_info_by_slot = {}
    self._hero_equipment_units = {}
    self._hero_equipment_units[InventorySettings.slots_by_name.slot_melee.slot_index] = {}
    self._hero_equipment_units[InventorySettings.slots_by_name.slot_ranged.slot_index] = {}
    self._hero_equipment_units_data = {}
    self._hero_equipment_units_data[InventorySettings.slots_by_name.slot_melee.slot_index] = {}
    self._hero_equipment_units_data[InventorySettings.slots_by_name.slot_ranged.slot_index] = {}
    self._hidden_hero_units = {}

    self.enemy_unit = nil
    self.enemy_weapon_units = {}
    self._hidden_enemy_units = {}

    self._requested_mip_streaming_units = {}

    self._default_look_target = { x = 0, y = 0, z = 0.9 }

    self._camera_default_position = { x = 0, y = 0, z = 0 }
    self._unit_browser_positions = {
        hero_browser = { 0, 0, 0 },
        enemy_browser = { 0, 0, 0 }
    }

    self._default_animation_data = {
        x = {
            value = 0
        },
        y = {
            value = 0
        },
        z = {
            value = 0
        }
    }
    self._camera_position_animation_data = table.clone(self._default_animation_data)
    self._camera_rotation_animation_data = table.clone(self._default_animation_data)
    self._camera_gamepad_offset_data = { 0, 0, 0 }

    self:_load_packages({"resource_packages/inventory"})
end

VermitannicaPreviewer.destroy = function (self)
    Renderer.set_automatic_streaming(true)
    GarbageLeakDetector.register_object(self, self.NAME)
end

function VermitannicaPreviewer:on_enter(viewport_widget)

    table.clear(self._hero_data.hidden_units)
    table.clear(self._enemy_data.hidden_units)
    table.clear(self._requested_mip_streaming_units)

    local preview_pass_data = viewport_widget.element.pass_data[1]
    self.viewport_fov = viewport_widget.style.viewport.fov
    self.world = preview_pass_data.world
    self.level = preview_pass_data.level
    self.viewport = preview_pass_data.viewport

    self.camera_data = {
        camera = ScriptViewport.camera(self.viewport),
        params = table.shallow_copy(self._default_camera_params),
        position_animation_data = table.shallow_copy(self._default_camera_animation_data),
        rotation_animation_data = table.shallow_copy(self._default_camera_animation_data)
    }

    Application.set_render_setting("max_shadow_casting_lights", 16)

end

VermitannicaPreviewer.on_enter = function (self, viewport_widget)

    table.clear(self._requested_mip_streaming_units)
    table.clear(self._hidden_hero_units)
    table.clear(self._hidden_enemy_units)

    self.viewport_widget = viewport_widget
    local preview_pass_data = viewport_widget.element.pass_data[1]
    self.viewport_fov = viewport_widget.style.viewport.fov
    self.world = preview_pass_data.world
    self.physics_world = World.get_data(self.world, "physics_world")
    self.level = preview_pass_data.level
    self.viewport = preview_pass_data.viewport
    self.camera = ScriptViewport.camera(self.viewport)

    Application.set_render_setting("max_shadow_casting_lights", 16)

    self.camera_params = {
        x_pan = 0,
        x_pan_target = 0,
        z_pan = 0,
        z_pan_target = 0,
        zoom = 1,
        zoom_target = 1
    }

    self.unit_params = {
        hero = {
            xy_angle = DEFAULT_ANGLE,
            xy_angle_target = DEFAULT_ANGLE,
            look = table.shallow_copy(look_target_home),
            look_target = table.shallow_copy(look_target_home)
        },
        enemy = {
            xy_angle = -DEFAULT_ANGLE,
            xy_angle_target = -DEFAULT_ANGLE,
            look = table.shallow_copy(look_target_home),
            look_target = table.shallow_copy(look_target_home)
        }
    }

    local level_name = viewport_widget.style.viewport.level_name
    local object_set_names = LevelResource.object_set_names(level_name)

    for _, object_set_name in ipairs(object_set_names) do
        local unit_indices = LevelResource.unit_indices_in_object_set(level_name, object_set_name)
        self:show_level_units(unit_indices, false)
    end
end

function VermitannicaPreviewer:trigger_level_event(event_name)
    Level.trigger_event(self.level, event_name)
end

function VermitannicaPreviewer:show_level_units(unit_indices, visibility)
    local level = self.level

    for _, unit_index in pairs(unit_indices) do
        local unit = Level.unit_by_index(level, unit_index)

        if Unit.alive(unit) then
            Unit.set_unit_visibility(unit, visibility)

            if visibility then
                Unit.flow_event(unit, "unit_object_set_enabled")
            else
                Unit.flow_event(unit, "unit_object_set_disabled")
            end
        end
    end
end

function VermitannicaPreviewer:prepare_exit()
    self:_clear_all_units()
end

VermitannicaPreviewer.on_exit = function (self)
    self:_unload_all_packages()

    self._hero_loading_package_data = nil
    self._enemy_loading_package_data = nil

    local max_shadow_casting_lights = Application.user_setting("render_settings", "max_shadow_casting_lights")
    Application.set_render_setting("max_shadow_casting_lights", max_shadow_casting_lights)

    Renderer.set_automatic_streaming(true)
end

function VermitannicaPreviewer:_clear_all_units()
    table.clear(self._requested_mip_streaming_units)

    self:_clear_enemy_units()
    self:_clear_hero_units()
end

VermitannicaPreviewer._clear_hero_units = function (self)
    local world = self.world

    for i = 1, 6, 1 do
        if type(self._hero_equipment_units[i]) == "table" then
            if self._hero_equipment_units[i].left then
                World.destroy_unit(world, self._hero_equipment_units[i].left)

                self._hero_equipment_units[i].left = nil
            end

            if self._hero_equipment_units[i].right then
                World.destroy_unit(world, self._hero_equipment_units[i].right)

                self._hero_equipment_units[i].right = nil
            end
        elseif self._hero_equipment_units[i] then
            World.destroy_unit(world, self._hero_equipment_units[i])

            self._hero_equipment_units[i] = nil
        end
    end

    if self.hero_unit ~= nil then
        World.destroy_unit(world, self.hero_unit)

        self.hero_unit = nil
    end
end

VermitannicaPreviewer.trigger_unit_flow_event = function (self, unit, event_name)
    if unit and Unit.alive(unit) then
        Unit.flow_event(unit, event_name)
    end
end

VermitannicaPreviewer._clear_enemy_units = function (self)
    local world = self.world

    for i, unit_data in pairs(self.enemy_weapon_units) do
        World.destroy_unit(world, unit_data.weapon_unit)
        self.enemy_weapon_units[i] = nil
    end

    if self.enemy_unit then
        World.destroy_unit(world, self.enemy_unit)
        self.enemy_unit = nil
    end

    self._done_linking_units = false
end

function VermitannicaPreviewer:_load_packages(package_names)
    local reference_name = self.NAME
    local package_manager = Managers.package

    for _, package_name in ipairs(package_names) do
        package_manager:load(package_name, reference_name, nil, true)
    end
end

function VermitannicaPreviewer:_unload_all_packages()
    self:_unload_item_packages()
    self:_unload_hero_packages()
    self:_unload_enemy_packages()
end

function VermitannicaPreviewer:_unload_item_packages()
    local item_info_by_slot = self._item_info_by_slot

    for slot_type, _ in pairs(item_info_by_slot) do
        self:_unload_item_packages_by_slot(slot_type)
    end
end

function VermitannicaPreviewer:_unload_hero_packages()
    local reference_name = self.NAME
    local package_manager = Managers.package
    local package_names

    if self._hero_loading_package_data then
        package_names = self._hero_loading_package_data.package_names
        for _, package_name in pairs(package_names) do
            if package_manager:can_unload(package_name) then
                package_manager:unload(package_name, reference_name)
            end
        end

        self._hero_loading_package_data = nil
    end

    if self._hero_weapons_loading_package_data then
        package_names = self._hero_weapons_loading_package_data.package_names
        for _, package_name in pairs(package_names) do
            if package_manager:can_unload(package_name) then
                package_manager:unload(package_name, reference_name)
            end
        end

        self._hero_weapons_loading_package_data = nil
    end
end

function VermitannicaPreviewer:_unload_enemy_packages()
    local reference_name = self.NAME
    local package_manager = Managers.package
    local package_names

    if self._enemy_loading_package_data then
        package_names = self._enemy_loading_package_data.package_names
        for _, package_name in pairs(package_names) do
            if package_manager:can_unload(package_name) then
                package_manager:unload(package_name, reference_name)
            end
        end

        self._enemy_loading_package_data = nil
    end

    if self._enemy_weapons_loading_package_data then
        package_names = self._enemy_weapons_loading_package_data.package_names
        for _, package_name in pairs(package_names) do
            package_manager:unload(package_name, reference_name)
        end

        self._enemy_weapons_loading_package_data = nil
    end
end

function VermitannicaPreviewer:update(dt, t, input_disabled)

    self:_update_hero_unit(dt, t)
    self:_update_enemy_unit(dt, t)
    self:_update_camera(dt, t)

    local input_service = self.input_manager:get_service("vermitannica_view")
    if not input_disabled then
        self:_handle_mouse_input(input_service, dt)
        self:_handle_controller_input(input_service, dt)
    end

end

local constraint_target_names = {
    "aim_constraint_target",
    "aim_target"
}
function VermitannicaPreviewer:_update_units(dt, t)
    local units_data = self._units_data
    for _, unit_data in ipairs(units_data) do
        local unit = unit_data.unit
        if unit and Unit_alive(unit) then
            local position = Unit.local_position(unit, 0)
            local position_target = Unit.has_data(unit, "spawn_home") and Unit.get_data(unit, "spawn_home") or { 0, 0, 0 }
            local position_new = Vector3(
                math.lerp(position.x, position_target[1], 0.1),
                math.lerp(position.y, position_target[2], 0.1),
                math.lerp(position.z, position_target[3], 0.1)
            )
            Unit.set_local_position(unit, 0, position_new)

            local params = unit_data.params
            local xy_angle = params.camera_xy_angle
            local xy_angle_target = params.camera_xy_angle_target
            if xy_angle_target > pi_2 then
                xy_angle = xy_angle - pi_2
                xy_angle_target = xy_angle_target - pi_2
            elseif xy_angle_target < -pi_2 then
                xy_angle = xy_angle + pi_2
                xy_angle_target = xy_angle_target + pi_2
            end

            local xy_angle_new = math.lerp(xy_angle, xy_angle_target, 0.1)
            local rotation = Quaternion.axis_angle(Vector3(0, 0, 1), -xy_angle_new)
            Unit.set_local_rotation(unit, 0, rotation)
            params.xy_angle = xy_angle
            params.xy_angle_target = xy_angle_target

            for _, constraint_target_name in ipairs(constraint_target_names) do
                if Unit.animation_has_constraint_target(unit, constraint_target_name) then
                    local look_target = Unit.has_data(unit, "look_target") and Unit.get_data(unit, "look_target") or default_unit_look_target
                    local aim_constraint_anim_var = Unit.animation_find_constraint_target(unit, constraint_target_name)
                    local rotated_constraint_position = Quaternion.rotate(rotation, look_target)
                    Unit.animation_set_constraint_target(unit, aim_constraint_anim_var, rotated_constraint_position)
                end
            end

        end
    end

end

function VermitannicaPreviewer:_update_hero_unit()
    local hero_data = self._hero_data
    local hero_unit = hero_data and hero_data.unit or self.hero_unit
    if Unit_alive(hero_unit) then
        local position = Unit.local_position(hero_unit, 0)
        local position_target = hero_unit_home
        local position_new = Vector3(
            math.lerp(position.x, position_target[1], 0.1),
            math.lerp(position.y, position_target[2], 0.1),
            math.lerp(position.z, position_target[3], 0.1)
        )
        Unit.set_local_position(hero_unit, 0, position_new)

        local params = self.unit_params.hero
        local xy_angle = params.xy_angle
        local xy_angle_target = params.xy_angle_target
        if xy_angle_target > pi_2 then
            xy_angle = xy_angle - pi_2
            xy_angle_target = xy_angle_target - pi_2
        elseif xy_angle_target < -pi_2 then
            xy_angle = xy_angle + pi_2
            xy_angle_target = xy_angle_target + pi_2
        end

        local xy_angle_new = math.lerp(xy_angle, xy_angle_target, 0.1)
        local player_rotation = Quaternion.axis_angle(Vector3(0, 0, 1), -xy_angle_new)
        params.xy_angle = xy_angle_new
        params.xy_angle_target = xy_angle_target
        Unit.set_local_rotation(hero_unit, 0, player_rotation)

        local look_target = Vector3Aux.unbox(params.look_target)
        local aim_constraint_anim_var = Unit.animation_find_constraint_target(hero_unit, "aim_constraint_target")
        local rotated_constraint_position = Quaternion.rotate(player_rotation, look_target)
        Unit.animation_set_constraint_target(hero_unit, aim_constraint_anim_var, rotated_constraint_position)
    end
end

function VermitannicaPreviewer:_update_enemy_unit(dt, t)
    local enemy_data = self._enemy_data
    local enemy_unit = enemy_data and enemy_data.unit or self.enemy_unit
    if Unit_alive(enemy_unit) then
        --if self._browser_mode and self._browser_mode ~= "enemy_browser" then
        --    Unit.set_unit_visibility(enemy_unit, false)
        --    local weapon_unit_data = self.enemy_weapon_units or {}
        --    for i, datum in ipairs(weapon_unit_data) do
        --        Unit.set_unit_visibility(datum.weapon_unit, false)
        --    end
        --
        --    local flow_unit_attachments = Unit.get_data(enemy_unit, "flow_unit_attachments") or {}
        --
        --    for _, unit in pairs(flow_unit_attachments) do
        --        Unit.set_unit_visibility(unit, false)
        --    end
        --
        --    Unit.flow_event(enemy_unit, "lua_attachment_hidden")
        --else
        --    Unit.set_unit_visibility(enemy_unit, true)
        --
        --    local flow_unit_attachments = Unit.get_data(enemy_unit, "flow_unit_attachments") or {}
        --
        --    for _, unit in pairs(flow_unit_attachments) do
        --        Unit.set_unit_visibility(unit, true)
        --    end
        --
        --    Unit.flow_event(enemy_unit, "lua_attachment_unhidden")
        --
        --    if self.enemy_weapon_units ~= nil and self._done_linking_units then
        --        local weapon_unit_data = self.enemy_weapon_units
        --        for i, datum in ipairs(weapon_unit_data) do
        --            Unit.set_unit_visibility(datum.weapon_unit, true)
        --        end
        --    end
        --end

        local is_enemy_focused = self.focused_unit == enemy_unit
        local position = Unit.local_position(enemy_unit, 0)
        local position_target = is_enemy_focused and focus_unit_home or enemy_unit_home
        local position_new = Vector3(
            math.lerp(position.x, position_target[1], 0.075),
            math.lerp(position.y, position_target[2], 0.075),
            math.lerp(position.z, position_target[3], 0.075)
        )
        Unit.set_local_position(enemy_unit, 0, position_new)

        local params = self.unit_params.enemy
        local xy_angle = params.xy_angle
        local xy_angle_target = params.xy_angle_target
        if xy_angle_target > pi_2 then
            xy_angle = xy_angle - pi_2
            xy_angle_target = xy_angle_target - pi_2
        elseif xy_angle_target < -pi_2 then
            xy_angle = xy_angle + pi_2
            xy_angle_target = xy_angle_target + pi_2
        end

        local xy_angle_new = math.lerp(xy_angle, xy_angle_target, 0.1)
        local rotation = Quaternion.axis_angle(Vector3(0, 0, 1), -xy_angle_new)
        params.xy_angle = xy_angle_new
        params.xy_angle_target = xy_angle_target
        Unit.set_local_rotation(enemy_unit, 0, rotation)
    end
end

local function update_camera_target(current, target, min, max)
    if min ~= nil and max ~= nil then
        target = math.clamp(target, min, max)
    elseif min == nil then
        target = math.min(target, max)
    elseif max == nil then
        target = math.max(target, min)
    end

    current = math.lerp(current, target, 0.1)
    return current, target
end

function VermitannicaPreviewer:_update_camera(dt, t)
    local camera_data = self.camera_data
    local camera = camera_data and camera_data.camera or self.camera
    local params = camera_data and camera_data.params or self.camera_params

    local viewport_fov = self.viewport_fov
    local zoom_min = -35
    local zoom_max = 35
    local zoom_new, zoom_target = update_camera_target(params.zoom, params.zoom_target, zoom_min, zoom_max)
    local viewport_fov_new = viewport_fov - zoom_new
    params.zoom = zoom_new
    params.zoom_target = zoom_target
    Camera.set_vertical_fov(camera, (math.pi * viewport_fov_new) / 180)

    local percent_change = math.round_with_precision(viewport_fov_new / viewport_fov, 1)
    local x_pan_new, x_pan_target = update_camera_target(params.x_pan, params.x_pan_target, -percent_change, percent_change)
    params.x_pan = x_pan_new
    params.x_pan_target = x_pan_target

    local z_pan_new, z_pan_target = update_camera_target(params.z_pan, params.z_pan_target, -1, 1)
    params.z_pan = z_pan_new
    params.z_pan_target = z_pan_target

    local camera_position_animation_data = camera_data and camera_data.position_animation_data or self._camera_position_animation_data
    self:_update_camera_animation_data(camera_position_animation_data, dt)

    local camera_gamepad_offset_data = self._camera_gamepad_offset_data
    local camera_default_position = self._camera_default_position
    local camera_position_new = Vector3(
            camera_default_position.x + camera_position_animation_data.x.value + camera_gamepad_offset_data[1] - x_pan_new,
            camera_default_position.y + camera_position_animation_data.y.value + camera_gamepad_offset_data[2],
            camera_default_position.z + camera_position_animation_data.z.value + camera_gamepad_offset_data[3] + z_pan_new
    )
    ScriptCamera.set_local_position(camera, camera_position_new)

    local camera_rotation_animation_data = camera_data and camera_data.rotation_animation_data or self._camera_rotation_animation_data
    self:_update_camera_animation_data(camera_rotation_animation_data, dt)

    local look_target = self._default_look_target
    local direction = Vector3(camera_position_new.x, look_target.y, camera_position_new.z)
    local direction_normalized = Vector3.normalize(direction - camera_position_new)
    local direction_new = Vector3(
            direction_normalized.x + camera_rotation_animation_data.x.value,
            direction_normalized.y + camera_rotation_animation_data.y.value,
            direction_normalized.z + camera_rotation_animation_data.z.value
    )
    local rotation = Quaternion.look(direction_new)
    ScriptCamera.set_local_rotation(camera, rotation)
end

function VermitannicaPreviewer:post_update()
    self:_update_units_visibility()
    self:_handle_unit_animation_requests()
    self:_poll_packages_loading()
    self:_handle_spawn_requests()
end

function VermitannicaPreviewer:_handle_unit_animation_requests()

    local units_data = self._units_data
    for _, data in ipairs(units_data) do
        local unit = data.unit
        if unit and Unit_alive(unit) then
            if data.wait_for_state_machine then
                if not Unit.has_animation_state_machine(unit) then
                    Unit.enable_animation_state_machine(unit)

                    data.wait_for_state_machine = nil
                elseif data.requested_animation then
                    Unit.animation_event(unit, data.requested_animation)

                    data.requested_animation = nil
                end
            end
        end
    end
end

VermitannicaPreviewer.post_update = function (self)
    if not self:_is_unit_mip_streaming() then
        self:_update_units_visibility()
    end
    self:_poll_packages_loading()
    self:_handle_spawn_requests()

    local enemy_unit = self.enemy_unit
    if enemy_unit and Unit_alive(enemy_unit) and self._done_linking_units then
        if self.waiting_for_state_machine and not Unit.has_animation_state_machine(enemy_unit) then
            Unit.enable_animation_state_machine(enemy_unit)

            self.waiting_for_state_machine = nil
        end

        if self._requested_animation then
            Unit.animation_event(enemy_unit, self._requested_animation)

            self._requested_animation = nil
        end
    end
end

VermitannicaPreviewer.force_stream_highest_mip_levels = function (self)
    self._use_highest_mip_levels = true
end

function VermitannicaPreviewer:_update_unit_visibility(unit_data)
    if not unit_data then
        return
    end

    local unit = unit_data.unit
    if not unit or not Unit_alive(unit) then
        return
    end

    if unit_data.wait_for_state_machine then
        return
    end

    local hidden_units = unit_data.hidden_units or {}
    if unit_data.unit_hidden_after_spawn then
        unit_data.unit_hidden_after_spawn = nil

        Unit.flow_event(unit, "lua_spawn_attachments")

        local draw_unit = unit_data.draw_unit and true or false
        self:_set_unit_visibility(unit_data, draw_unit)

        table.clear(hidden_units)
    else
        for hidden_unit, _ in pairs(hidden_units) do
            if Unit_alive(hidden_unit) then
                Unit_set_unit_visibility(hidden_unit, true)
            end

            hidden_units[hidden_unit] = nil
        end
    end

end

function VermitannicaPreviewer:_update_units_visibility()

    local units_data = self._units_data
    for _, unit_data in ipairs(units_data) do
        local packages_to_load = unit_data.packages_to_load
        if not packages_to_load or self:_is_item_packages_loaded(packages_to_load) then
            self:_update_unit_visibility(unit_data)
        end
    end

end

function VermitannicaPreviewer:_update_hero_visibility()
    local hero_unit = self.hero_unit
    if not Unit_alive(hero_unit) then
        return
    end

    local is_items_loaded = self:_is_all_items_loaded()

    if not is_items_loaded then
        return
    end

    if self._stored_hero_animation then
        local force_play_animation = true

        self:play_hero_animation(self._stored_hero_animation, force_play_animation)

        self._stored_hero_animation = nil

        return
    end

    if self.hero_unit_hidden_after_spawn then
        self.hero_unit_hidden_after_spawn = false

        Unit.flow_event(hero_unit, "lua_spawn_attachments")

        if self._draw_hero == false then
            self:_set_hero_visibility(false)
        else
            self:_set_hero_visibility(true)
        end

        table.clear(self._hidden_hero_units)
    else
        for unit, _ in pairs(self._hidden_hero_units) do
            if Unit_alive(unit) then
                Unit_set_unit_visibility(unit, true)
            end

            self._hidden_hero_units[unit] = nil
        end
    end
end

local function link_unit(attachment_node_linking, world, target, source)
    for i, attachment_nodes in ipairs(attachment_node_linking) do
        local source_node = attachment_nodes.source
        local target_node = attachment_nodes.target
        local source_node_index = (type(source_node) == "string" and Unit.node(source, source_node)) or source_node
        local target_node_index = (type(target_node) == "string" and Unit.node(target, target_node)) or target_node

        World.link_unit(world, target, target_node_index, source, source_node_index)
    end
end

function VermitannicaPreviewer:_update_enemy_visibility()
    local enemy_unit = self.enemy_unit
    if not Unit_alive(enemy_unit) then
        return
    end

    if self.enemy_weapon_units ~= nil and not self._done_linking_units then
        for _, unit_data in pairs(self.enemy_weapon_units) do
            local wielded = unit_data.attachment_node_linking.wielded
            local unwielded = unit_data.attachment_node_linking.unwielded
            local linking_data = wielded or unwielded

            link_unit(linking_data, self.world, unit_data.weapon_unit, self.enemy_unit)
        end

        self._done_linking_units = true
    end

    local flow_event = self._draw_enemy and "lua_attachment_unhidden" or "lua_attachment_hidden"
    Unit.flow_event(enemy_unit, flow_event)

    local flow_unit_attachments = Unit.get_data(enemy_unit, "flow_unit_attachments") or {}

    for _, unit in pairs(flow_unit_attachments) do
        Unit.set_unit_visibility(unit, self._draw_enemy)
    end

    if self.waiting_for_state_machine or not self._done_linking_units or not self._draw_enemy then
        return
    end

    local unit_visibility_frame_delay = self.unit_visibility_frame_delay
    if unit_visibility_frame_delay and unit_visibility_frame_delay > 0 then
        self.unit_visibility_frame_delay = unit_visibility_frame_delay - 1

        return
    end



    for unit, _ in pairs(self._hidden_enemy_units) do
        if Unit_alive(unit) then
            Unit_set_unit_visibility(unit, true)
        end

        self._hidden_enemy_units[unit] = nil
    end

    self.force_unhide_character = false
end

VermitannicaPreviewer._update_units_visibility = function (self)
    self:_update_hero_visibility()
    self:_update_enemy_visibility()
end

function VermitannicaPreviewer:_is_unit_mip_streaming()
    local mip_streaming_completed = true
    local num_units_handled = 0
    local requested_mip_streaming_units = self._requested_mip_streaming_units

    for unit, _ in pairs(requested_mip_streaming_units) do
        local unit_mip_streaming_completed = Renderer.is_all_mips_loaded_for_unit(unit)

        if unit_mip_streaming_completed then
            requested_mip_streaming_units[unit] = nil
        else
            mip_streaming_completed = false
        end

        num_units_handled = num_units_handled + 1
    end

    if not mip_streaming_completed then
        return true
    elseif num_units_handled > 0 then
        Renderer.set_automatic_streaming(true)
    end
end

VermitannicaPreviewer._request_mip_streaming_for_unit = function (self, unit)
    local requested_mip_streaming_units = self._requested_mip_streaming_units
    requested_mip_streaming_units[unit] = true

    Renderer.set_automatic_streaming(false)

    for unit, _ in pairs(requested_mip_streaming_units) do
        Renderer.request_to_stream_all_mips_for_unit(unit)
    end
end

function VermitannicaPreviewer:_set_unit_visibility(unit_data, visible)
    unit_data.draw_unit = visible

    local unit = unit_data.unit
    if not unit or not Unit_alive(unit) then
        return
    end

    Unit_set_unit_visibility(unit, visible)

    local flow_unit_attachments = Unit.has_data(unit, "flow_unit_attachments") and Unit.get_data(unit, "flow_unit_attachments")
    if flow_unit_attachments then
        for _, attachment_unit in pairs(flow_unit_attachments) do
            Unit_set_unit_visibility(attachment_unit, visible)
        end
    end
end

VermitannicaPreviewer._set_enemy_visibility = function (self, visible)
    self._draw_enemy = visible

    local enemy_unit = self.enemy_unit
    if Unit_alive(enemy_unit) then
        Unit.set_unit_visibility(enemy_unit, visible)

        local flow_unit_attachments = Unit.get_data(enemy_unit, "flow_unit_attachments") or {}
        for _, unit in pairs(flow_unit_attachments) do
            Unit_set_unit_visibility(unit, visible)
        end

        for _, unit_data in pairs(self.enemy_weapon_units) do
            Unit_set_unit_visibility(unit_data.weapon_unit, visible)
        end

    end
end

VermitannicaPreviewer._set_hero_visibility = function (self, visible)
    self._draw_hero = visible

    local hero_unit = self.hero_unit
    if Unit.alive(hero_unit) then
        Unit.set_unit_visibility(hero_unit, visible)

        local flow_unit_attachments = Unit.get_data(hero_unit, "flow_unit_attachments") or {}

        for _, unit in pairs(flow_unit_attachments) do
            Unit.set_unit_visibility(unit, visible)
        end

        local slots_by_slot_index = InventorySettings.slots_by_slot_index
        local attachment_lua_event = (visible and "lua_attachment_unhidden") or "lua_attachment_hidden"

        Unit.flow_event(hero_unit, attachment_lua_event)

        local hero_equipment_units = self._hero_equipment_units

        for slot_index, data in pairs(hero_equipment_units) do
            local slot = slots_by_slot_index[slot_index]
            local category = slot.category
            local slot_type = slot.type
            local is_weapon = category == "weapon"
            local show_unit

            if is_weapon then
                show_unit = visible and slot_type == self._wielded_slot_type
            else
                show_unit = visible
            end

            local weapon_lua_event = (show_unit and "lua_wield") or "lua_unwield"

            if type(data) == "table" then
                local left_unit = data.left
                local right_unit = data.right

                if Unit.alive(left_unit) then
                    Unit.flow_event(left_unit, weapon_lua_event)
                    Unit.set_unit_visibility(left_unit, show_unit)
                end

                if Unit.alive(right_unit) then
                    Unit.flow_event(right_unit, weapon_lua_event)
                    Unit.set_unit_visibility(right_unit, show_unit)
                end
            elseif Unit.alive(data) then
                if not is_weapon then
                    attachment_lua_event = (show_unit and "lua_attachment_unhidden") or "lua_attachment_hidden"

                    Unit.flow_event(data, attachment_lua_event)
                end

                Unit.flow_event(data, weapon_lua_event)
                Unit.set_unit_visibility(data, show_unit)
            end
        end

        if visible then
            local skin_data = self.hero_unit_skin_data
            local material_changes = skin_data.material_changes

            if material_changes then
                local third_person_changes = material_changes.third_person

                for slot_name, material_name in pairs(third_person_changes) do
                    for _, unit in pairs(flow_unit_attachments) do
                        Unit.set_material(unit, slot_name, material_name)
                    end
                end
            end

            for slot_name, data in pairs(self._item_info_by_slot) do
                if data.loaded then
                    local item_name = data.name
                    local item_template = ItemHelper.get_template_by_item_name(item_name)
                    local show_attachments_event = item_template.show_attachments_event

                    if show_attachments_event then
                        Unit.flow_event(hero_unit, show_attachments_event)
                    end
                end
            end
        end

        self.hero_unit_visible = visible
    end
end

VermitannicaPreviewer.hero_visible = function (self)
    return self.hero_unit_visible and Unit.alive(self.hero_unit)
end

VermitannicaPreviewer._update_camera_animation_data = function (self, animation_data, dt)
    for axis, data in pairs(animation_data) do
        if data.total_time then
            local old_time = data.time
            data.time = math.min(old_time + dt, data.total_time)
            local progress = math.min(1, data.time / data.total_time)
            local func = data.func
            data.value = (data.to - data.from) * ((func and func(progress)) or progress) + data.from

            if progress == 1 then
                data.total_time = nil
            end

        end
    end
end

VermitannicaPreviewer.set_camera_axis_offset = function (self, axis, value, animation_time, func_ptr, fixed_position)
    local data = self._camera_position_animation_data[axis]
    local camera_default_position = self._camera_default_position
    data.from = (animation_time and data.value) or value
    data.to = (fixed_position and value - camera_default_position[axis]) or value
    data.total_time = animation_time
    data.time = 0
    data.func = func_ptr or math.easeOutCubic
    data.value = data.from
end

VermitannicaPreviewer.set_camera_gamepad_offset = function (self, value)
    self._camera_gamepad_offset_data = value
end

VermitannicaPreviewer.set_camera_rotation_axis_offset = function (self, axis, value, animation_time, func_ptr)
    local data = self._camera_rotation_animation_data[axis]
    data.from = (animation_time and data.value) or value
    data.to = value
    data.total_time = animation_time
    data.time = 0
    data.func = func_ptr
    data.value = data.from
end

local mouse_pos_temp = {}
VermitannicaPreviewer._handle_mouse_input = function (self, input_service, dt)
    local hero_unit = self.hero_unit
    local enemy_unit = self.enemy_unit

    if hero_unit == nil and enemy_unit == nil then
        return
    end

    if not self.input_manager:is_device_active("mouse") then
        return
    end

    local mouse = input_service:get("cursor")

    if not mouse then
        return
    end

    local viewport_widget = self.viewport_widget
    local content = viewport_widget.content
    local button_hotspot = content.button_hotspot
    local is_hover = button_hotspot and button_hotspot.is_hover

    if is_hover and self._browser_mode ~= nil then
        local from = Camera.screen_to_world(self.camera, Vector3(mouse.x, mouse.y, 0), 0)
        local to = Camera.screen_to_world(self.camera, Vector3(mouse.x, mouse.y, 0), 1)
        local direction = to - from

        local hero_hit
        local enemy_hit
        if input_service:get("left_press") or input_service:get("right_press") then
            if hero_unit and self._draw_hero then
                local hero_unit_box, hero_box_dimension = Unit.box(hero_unit)
                hero_box_dimension[1] = hero_box_dimension[1] * 0.25
                hero_box_dimension[2] = hero_box_dimension[2] * 0.25

                hero_hit = Intersect.ray_box(from, direction, hero_unit_box, hero_box_dimension)
            end

            if enemy_unit and self._browser_mode == "enemy_browser" then
                local enemy_unit_box, enemy_box_dimension = Unit.box(enemy_unit)
                enemy_box_dimension[1] = enemy_box_dimension[1] * 0.25
                enemy_box_dimension[2] = enemy_box_dimension[2] * 0.25
                enemy_hit = Intersect.ray_box(from, direction, enemy_unit_box, enemy_box_dimension)
            end

            self.selected_unit = (hero_hit and hero_unit) or (enemy_hit and enemy_unit) or nil
            self.is_moving_camera = true
            self.last_mouse_position = nil
        end

        if input_service:get("scroll_axis") then
            self.is_moving_camera = true
        end

        local is_moving_camera = self.is_moving_camera
        local left_mouse_hold = input_service:get("left_hold")
        local right_mouse_hold = input_service:get("right_hold")
        local shift_hold = input_service:get("shift_hold")
        local scroll_wheel = input_service:get("scroll_axis")
        local middle_mouse_hold = input_service:get("middle_hold")

        if is_moving_camera and (left_mouse_hold or right_mouse_hold or scroll_wheel) then
            local camera_params = self.camera_params
            local unit_params = self.unit_params
            local hero_params = unit_params.hero
            local enemy_params = unit_params.enemy

            local last_mouse_position = self.last_mouse_position
            if last_mouse_position then
                if left_mouse_hold then

                    if self.selected_unit == hero_unit then
                        hero_params.xy_angle_target = hero_params.xy_angle_target - (mouse.x - last_mouse_position[1]) * 0.01
                    elseif self.selected_unit == enemy_unit then
                        enemy_params.xy_angle_target = enemy_params.xy_angle_target - (mouse.x - last_mouse_position[1]) * 0.01
                    end

                end

                if right_mouse_hold then
                    if last_mouse_position then
                        camera_params.z_pan_target = camera_params.z_pan_target - (mouse.y - self.last_mouse_position[2]) * 0.005
                        camera_params.x_pan_target = camera_params.x_pan_target - (mouse.x - self.last_mouse_position[1]) * 0.005
                    end

                    mouse_pos_temp[1] = mouse.x
                    mouse_pos_temp[2] = mouse.y
                    self.last_mouse_position = mouse_pos_temp
                end
            end

            if is_moving_camera and scroll_wheel and self._browser_mode ~= nil then
                camera_params.zoom_target = camera_params.zoom_target + (scroll_wheel[2]) * 5
            end

            mouse_pos_temp[1] = mouse.x
            mouse_pos_temp[2] = mouse.y
            self.last_mouse_position = mouse_pos_temp

        elseif is_moving_camera then
            self.is_moving_camera = false
            self.selected_unit = nil
        end
    end


end

VermitannicaPreviewer._handle_controller_input = function (self, input_service, dt)
    local hero_unit = self.hero_unit

    if hero_unit == nil then
        return
    end

    if not self.input_manager:is_device_active("gamepad") then
        return
    end

    local hero_params = self.unit_params.hero
    local camera_move = input_service:get("gamepad_right_axis")
    if camera_move and Vector3.length(camera_move) > 0.01 then
        hero_params.xy_angle_target = hero_params.xy_angle_target - camera_move.x * dt * 5
    end
end

VermitannicaPreviewer.start_hero_rotation = function (self, direction)
    if direction then
        self.rotation_direction = direction
    end
end

VermitannicaPreviewer.end_hero_rotation = function (self)

end

VermitannicaPreviewer.play_hero_animation = function (self, animation_event, force_play_animation)
    local hero_unit = self.hero_unit

    if hero_unit == nil then
        return
    end

    if not self.hero_unit_visible and not force_play_animation then
        self._stored_hero_animation = animation_event
    else
        Unit.animation_event(hero_unit, animation_event)
    end
end

function VermitannicaPreviewer:_is_item_packages_loaded(package_names)

    local package_manager = Managers.package
    local packages_n = #package_names

    for i = 1, packages_n, 1 do
        local package_name = package_names[i]
        if not package_manager:has_loaded(package_name) then
            return false
        end
    end

    return true
end

VermitannicaPreviewer._is_all_items_loaded = function (self)
    local item_info_by_slot = self._item_info_by_slot
    local all_loaded = true

    for slot_name, data in pairs(item_info_by_slot) do
        if not data.loaded then
            all_loaded = false

            break
        end
    end

    return all_loaded
end

VermitannicaPreviewer._spawn_item = function (self, item_name, spawn_data)
    local world = self.world
    local hero_unit = self.hero_unit
    local scenegraph_links = {}
    local item_template = ItemHelper.get_template_by_item_name(item_name)
    local hero_material_changed = false

    for _, unit_spawn_data in ipairs(spawn_data) do
        local unit_name = unit_spawn_data.unit_name
        local item_slot_type = unit_spawn_data.item_slot_type
        local slot_index = unit_spawn_data.slot_index
        local unit_attachment_node_linking = unit_spawn_data.unit_attachment_node_linking
        local hero_material_changes = unit_spawn_data.hero_material_changes
        local material_settings = unit_spawn_data.material_settings

        if item_slot_type == "melee" or item_slot_type == "ranged" then
            local unit = World.spawn_unit(world, unit_name)

            self:_spawn_item_unit(unit, item_slot_type, item_template, unit_attachment_node_linking, scenegraph_links, material_settings)

            if unit_spawn_data.right_hand then
                self._hero_equipment_units[slot_index].right = unit
                self._hero_equipment_units_data[slot_index].right = {
                    unit_attachment_node_linking = unit_attachment_node_linking,
                    scenegraph_links = scenegraph_links
                }
            elseif unit_spawn_data.left_hand then
                self._hero_equipment_units[slot_index].left = unit
                self._hero_equipment_units_data[slot_index].left = {
                    unit_attachment_node_linking = unit_attachment_node_linking,
                    scenegraph_links = scenegraph_links
                }
            end
        else
            local unit = World.spawn_unit(world, unit_name)
            self._hero_equipment_units[slot_index] = unit
            self._hero_equipment_units_data[slot_index] = {
                unit_attachment_node_linking = unit_attachment_node_linking,
                scenegraph_links = scenegraph_links
            }

            self:_spawn_item_unit(unit, item_slot_type, item_template, unit_attachment_node_linking, scenegraph_links)

        end

        local show_attachments_event = item_template.show_attachments_event

        if show_attachments_event and self.hero_unit_visible then
            Unit.flow_event(hero_unit, show_attachments_event)
        end

        if hero_material_changes then
            local third_person_changes = hero_material_changes.third_person
            local flow_unit_attachments = Unit.get_data(hero_unit, "flow_unit_attachments") or {}

            for slot_name, material_name in pairs(third_person_changes) do
                for _, unit in pairs(flow_unit_attachments) do
                    Unit.set_material(unit, slot_name, material_name)
                end

                Unit.set_material(hero_unit, slot_name, material_name)

                hero_material_changed = true
            end
        end
    end

    if hero_material_changed and (self._use_highest_mip_levels or UISettings.wait_for_mip_streaming_character) then
        self:_request_mip_streaming_for_unit(hero_unit)
    end
end

VermitannicaPreviewer._spawn_item_unit = function (self, unit, item_slot_type, item_template, unit_attachment_node_linking, scene_graph_links, material_settings)
    local world = self.world
    local hero_unit = self.hero_unit
    local hero_visible = self:hero_visible()

    if item_slot_type == "melee" or item_slot_type == "ranged" then
        if self._wielded_slot_type == item_slot_type then
            unit_attachment_node_linking = unit_attachment_node_linking.wielded

            if item_template.wield_anim then
                Unit.animation_event(hero_unit, item_template.wield_anim)
            end

            self._hidden_hero_units[unit] = true
            local flow_event = (hero_visible and "lua_wield") or "lua_unwield"

            Unit.flow_event(unit, flow_event)
        else
            --unit_attachment_node_linking = unit_attachment_node_linking.unwielded
            --
            --Unit.flow_event(unit, "lua_unwield")
        end
    else
        local attachment_lua_event = (hero_visible and "lua_attachment_unhidden") or "lua_attachment_hidden"

        Unit.flow_event(unit, attachment_lua_event)

        self._hidden_hero_units[unit] = true
    end

    Unit.set_unit_visibility(unit, false)

    if Unit.has_lod_object(unit, "lod") then
        local lod_object = Unit.lod_object(unit, "lod")

        LODObject.set_static_height(lod_object, 1)
    end

    GearUtils.link(world, unit_attachment_node_linking, scene_graph_links, hero_unit, unit)

    if material_settings then
        GearUtils.apply_material_settings(unit, material_settings)
    end

    if self._use_highest_mip_levels or UISettings.wait_for_mip_streaming_items then
        self:_request_mip_streaming_for_unit(unit)
    end
end

VermitannicaPreviewer._destroy_item_units_by_slot = function (self, slot_type)
    local world = self.world
    local hidden_units = self._hidden_hero_units
    local requested_mip_streaming_units = self._requested_mip_streaming_units
    local item_info_by_slot = self._item_info_by_slot
    local data = item_info_by_slot[slot_type]
    local spawn_data = data.spawn_data

    if spawn_data then
        for _, unit_spawn_data in ipairs(spawn_data) do
            local item_slot_type = unit_spawn_data.item_slot_type
            local slot_index = unit_spawn_data.slot_index

            if item_slot_type == "melee" or item_slot_type == "ranged" then
                if unit_spawn_data.right_hand or unit_spawn_data.despawn_both_hands_units then
                    local old_unit_right = self._hero_equipment_units[slot_index].right

                    if old_unit_right ~= nil then
                        hidden_units[old_unit_right] = nil
                        requested_mip_streaming_units[old_unit_right] = nil

                        World.destroy_unit(world, old_unit_right)

                        self._hero_equipment_units[slot_index].right = nil
                    end
                end

                if unit_spawn_data.left_hand or unit_spawn_data.despawn_both_hands_units then
                    local old_unit_left = self._hero_equipment_units[slot_index].left

                    if old_unit_left ~= nil then
                        hidden_units[old_unit_left] = nil
                        requested_mip_streaming_units[old_unit_left] = nil

                        World.destroy_unit(world, old_unit_left)

                        self._hero_equipment_units[slot_index].left = nil
                    end
                end
            else
                local old_unit = self._hero_equipment_units[slot_index]

                if old_unit ~= nil then
                    hidden_units[old_unit] = nil
                    requested_mip_streaming_units[old_unit] = nil

                    World.destroy_unit(world, old_unit)

                    self._hero_equipment_units[slot_index] = nil
                end
            end
        end
    end
end

VermitannicaPreviewer.item_name_by_slot_type = function (self, item_slot_type)
    local item_info = self._item_info_by_slot[item_slot_type]

    return item_info and item_info.name
end

VermitannicaPreviewer.wielded_slot_type = function (self)
    return self._wielded_slot_type
end

VermitannicaPreviewer._poll_packages_loading = function (self)
    self:_poll_hero_packages_loading()
    self:_poll_enemy_packages_loading()
    self:_poll_item_package_loading()
end

VermitannicaPreviewer._poll_hero_packages_loading = function (self)
    local data = self._hero_loading_package_data

    if not data or data.loaded then
        return
    end

    if self._requested_hero_spawn_data then
        return
    end

    local reference_name = self.NAME
    local package_manager = Managers.package
    local package_names = data.package_names

    local all_packages_loaded = true
    for i = 1, #package_names, 1 do
        local package_name = package_names[i]

        if not package_manager:has_loaded(package_name, reference_name) then
            all_packages_loaded = false

            break
        end
    end

    if all_packages_loaded then
        local skin_data = data.skin_data
        local optional_scale = data.optional_scale
        local career_index = data.career_index
        local camera_move_duration = data.camera_move_duration

        self:_spawn_hero_unit(skin_data, optional_scale, career_index, camera_move_duration)

        local callback = data.callback
        if callback then
            callback()
        end

        data.loaded = true
    end
end

VermitannicaPreviewer._poll_enemy_packages_loading = function (self)
    local data = self._enemy_loading_package_data

    if not data or data.loaded then
        return
    end

    if self._requested_enemy_spawn_data then
        return
    end

    local reference_name = self.NAME
    local package_manager = Managers.package
    local package_names = data.package_names

    local all_packages_loaded = true
    for i = 1, #package_names, 1 do
        local package_name = package_names[i]

        if not package_manager:has_loaded(package_name, reference_name) then
            all_packages_loaded = false

            break
        end
    end

    if all_packages_loaded then
        local enemy_name = data.enemy_name

        self:_spawn_enemy_unit(enemy_name)

        local callback = data.callback

        if callback then
            callback()
        end

        data.loaded = true
    end
end

function VermitannicaPreviewer:request_animation(requested_animation)
    self._requested_animation = requested_animation
end

local ignore_multiple_configs_by_breed_name = {
    skaven_storm_vermin_warlord = true,
    beastmen_ungor_archer = true
}
VermitannicaPreviewer._spawn_enemy_weapon_units = function (self, inventory_config)
    if not inventory_config or not Managers.package:has_loaded("resource_packages/inventory", self.NAME) then
        return
    end

    local anim_state_event
    local equip_anim
    local categories = {}
    if inventory_config.multiple_configurations then
        local index = 1
        if not ignore_multiple_configs_by_breed_name[self.enemy_name] then
            index = math.random(1, #inventory_config.multiple_configurations)
        end

        local config = InventoryConfigurations[inventory_config.multiple_configurations[index]]
        anim_state_event = config.anim_state_event
        equip_anim = config.equip_anim
        categories = config.items

    else
        categories = inventory_config.items
    end

    if self._current_enemy_name == "skaven_warpfire_thrower" or self._current_enemy_name == "skaven_ratling_gunner" then
        Unit.animation_event(self.enemy_unit, "attack_shoot_align")
    end

    local weapon_unit_definitions = {}
    for i, category in ipairs(categories) do
        local target_index = math.random(1, #category)
        weapon_unit_definitions[#weapon_unit_definitions + 1] = category[target_index]
    end

    local weapon_units = {}
    for i, weapon_unit_definition in ipairs(weapon_unit_definitions) do

        local weapon_unit = World.spawn_unit(self.world, weapon_unit_definition.unit_name)
        Unit.set_unit_visibility(weapon_unit, false)

        anim_state_event = anim_state_event or inventory_config.anim_state_event
        if anim_state_event then
            Unit.animation_event(self.enemy_unit, anim_state_event)
        end

        equip_anim = equip_anim or inventory_config.equip_anim
        if equip_anim then
            self:request_animation(equip_anim)
        end

        self._hidden_enemy_units[weapon_unit] = true

        weapon_units[#weapon_units + 1] = {
            weapon_unit = weapon_unit,
            attachment_node_linking = weapon_unit_definition.attachment_node_linking
        }
    end
    self.enemy_weapon_units = weapon_units
end

local wait_for_state_machine = {
    chaos_exalted_sorcerer = true,
    chaos_exalted_sorcerer_drachenfels = true,
    chaos_corruptor_sorcerer = true,
    chaos_vortex_sorcerer = true
}
VermitannicaPreviewer._spawn_enemy_unit = function (self, enemy_name)
    local world = self.world

    self.enemy_name = enemy_name

    enemy_name = EnemyPackageLoaderSettings[enemy_name] or enemy_name

    local unit_name = Breeds[enemy_name].base_unit
    local enemy_unit = World.spawn_unit(world, unit_name)
    self.enemy_unit = enemy_unit

    local size_variation_range = Breeds[enemy_name].size_variation_range
    if size_variation_range then
        local size_normalized = Math.random()
        local size = math.lerp(size_variation_range[1], size_variation_range[2], size_normalized)
        Unit.set_local_scale(enemy_unit, 0, Vector3(size, size, size))
    end

    Unit.set_unit_visibility(enemy_unit, false)

    local is_focus_mode = self.is_focus_mode
    local spawn_position = is_focus_mode and focus_unit_home or enemy_unit_home
    Unit.set_local_position(enemy_unit, 0, Vector3(spawn_position[1], spawn_position[2], spawn_position[3]))

    local enemy_unit_params = self.unit_params.enemy
    enemy_unit_params.xy_angle_target = not is_focus_mode and -DEFAULT_ANGLE or 0

    self._hidden_enemy_units[enemy_unit] = true
    self.enemy_unit_hidden = true

    local template_name = Breeds[enemy_name].default_inventory_template
    if type(template_name) == "table" then
        local random_index = math.random(1, #template_name)
        template_name = template_name[random_index]
    end

    local template_function = AIInventoryTemplates[template_name]
    if template_function then
        local config_name = template_function()
        local inventory_config = InventoryConfigurations[config_name]

        if enemy_name == "chaos_exalted_champion_norsca" then
            inventory_config = {
                anim_state_event = "to_spear",
                items = {
                    {
                        {
                            unit_name = "units/weapons/enemy/wpn_chaos_set/wpn_chaos_2h_axe_03",
                            attachment_node_linking = AttachmentNodeLinking.ai_2h
                        }
                    }
                }
            }
        end

        self:_spawn_enemy_weapon_units(inventory_config)
    end

    self.unit_visibility_frame_delay = 5

    if Unit.has_lod_object(enemy_unit, "lod") then
        local lod_object = Unit.lod_object(enemy_unit, "lod")

        LODObject.set_static_select(lod_object, 0)
    end

    --local enemy_camera_positions = self._character_camera_positions

    --self._camera_current_position = enemy_camera_positions[enemy_name] or self.camera_default_position

    --local look_target = Vector3Aux.unbox(self.enemy_look_target)
    --
    --local aim_constraint_target = Breeds[enemy_name].aim_constraint_target
    --if aim_constraint_target then
    --    if type(aim_constraint_target) == "table" then
    --        aim_constraint_target = aim_constraint_target[1]
    --    end
    --
    --    local aim_constraint_anim_var = Unit.animation_find_constraint_target(enemy_unit, aim_constraint_target)
    --
    --    Unit.animation_set_constraint_target(enemy_unit, aim_constraint_anim_var, look_target)
    --end
end

VermitannicaPreviewer._spawn_hero_unit = function (self, skin_data, optional_scale, career_index)
    local world = self.world
    local unit_name = skin_data.third_person
    local tint_data = skin_data.color_tint
    local material_changes = skin_data.material_changes
    local hero_unit = World.spawn_unit(world, unit_name)

    if material_changes then
        local third_person_changes = material_changes.third_person

        for slot_name, material_name in pairs(third_person_changes) do
            Unit.set_material(hero_unit, slot_name, material_name)
        end
    end

    if tint_data then
        local gradient_variation = tint_data.gradient_variation
        local gradient_value = tint_data.gradient_value

        CosmeticUtils.color_tint_unit(hero_unit, self._current_profile_name, gradient_variation, gradient_value)
    end

    Unit.set_unit_visibility(hero_unit, false)
    Unit.set_local_position(hero_unit, 0, Vector3(1.25, 0.9, 0))

    self.hero_unit = hero_unit
    self.hero_unit_hidden_after_spawn = true
    self.hero_unit_visible = false
    self.hero_unit_skin_data = skin_data
    self._stored_hero_animation = nil

    if Unit.has_lod_object(hero_unit, "lod") then
        local lod_object = Unit.lod_object(hero_unit, "lod")

        LODObject.set_static_height(lod_object, 1)
    end

    if optional_scale then
        local scale = Vector3(optional_scale, optional_scale, optional_scale)

        Unit.set_local_scale(hero_unit, 0, scale)
    end

    if self._use_highest_mip_levels or UISettings.wait_for_mip_streaming_character then
        self:_request_mip_streaming_for_unit(hero_unit)
    end

    if Unit.animation_has_variable(hero_unit, "career_index") then
        local variable_index = Unit.animation_find_variable(hero_unit, "career_index")

        Unit.animation_set_variable(hero_unit, variable_index, career_index)
    end

end

VermitannicaPreviewer.respawn_hero_unit = function (self, profile_name, career_index, callback)
    local reset_camera = true

    self:request_spawn_hero_unit(profile_name, career_index, callback, reset_camera)
end

VermitannicaPreviewer.get_equipped_item_info = function (self, slot)
    local item_slot_type = slot.type
    local item_info_by_slot = self._item_info_by_slot

    return item_info_by_slot[item_slot_type]
end

VermitannicaPreviewer.equip_item = function (self, item_name, slot, skin_name)

    local skin_data = self.hero_unit_skin_data

    if skin_data and skin_data.always_hide_attachment_slots then
        local hide_slot = false

        for _, slot_name in ipairs(skin_data.always_hide_attachment_slots) do
            if slot.name == slot_name then
                hide_slot = true

                break
            end
        end

        if hide_slot then
            return
        end
    end

    local item_slot_type = slot.type
    local slot_index = slot.slot_index
    local item_data = ItemMasterList[item_name]
    local item_units = BackendUtils.get_item_units(item_data, nil, skin_name)
    local item_template = ItemHelper.get_template_by_item_name(item_name)
    local spawn_data = {}
    local package_names = {}

    if item_slot_type == "melee" or item_slot_type == "ranged" then
        self._wielded_slot_type = item_slot_type
        local left_hand_unit = item_units.left_hand_unit
        local right_hand_unit = item_units.right_hand_unit
        local material_settings = item_units.material_settings
        local despawn_both_hands_units = right_hand_unit == nil or left_hand_unit == nil

        if left_hand_unit then
            local left_unit = left_hand_unit .. "_3p"
            spawn_data[#spawn_data + 1] = {
                left_hand = true,
                despawn_both_hands_units = despawn_both_hands_units,
                unit_name = left_unit,
                item_slot_type = item_slot_type,
                slot_index = slot_index,
                unit_attachment_node_linking = item_template.left_hand_attachment_node_linking.third_person,
                material_settings = material_settings
            }
            package_names[#package_names + 1] = left_unit
        end

        if right_hand_unit then
            local right_unit = right_hand_unit .. "_3p"
            if string.match(item_name, "dr_1h_throwing_axes") then
                right_unit = item_units.ammo_unit .. "_3p"
            end
            spawn_data[#spawn_data + 1] = {
                right_hand = true,
                despawn_both_hands_units = despawn_both_hands_units,
                unit_name = right_unit,
                item_slot_type = item_slot_type,
                slot_index = slot_index,
                unit_attachment_node_linking = item_template.right_hand_attachment_node_linking.third_person,
                material_settings = material_settings
            }

            if right_hand_unit ~= left_hand_unit then
                package_names[#package_names + 1] = right_unit
            end
        end
    elseif item_slot_type == "hat" then
        local unit = item_units.unit

        if unit then
            local attachment_slot_lookup_index = 1

            local attachment_slot_name = item_template.slots[attachment_slot_lookup_index]
            local hero_material_changes = item_template.character_material_changes
            spawn_data[#spawn_data + 1] = {
                unit_name = unit,
                item_slot_type = item_slot_type,
                slot_index = slot_index,
                unit_attachment_node_linking = item_template.attachment_node_linking[attachment_slot_name],
                hero_material_changes = hero_material_changes
            }
            package_names[#package_names + 1] = unit

            if hero_material_changes then
                package_names[#package_names + 1] = hero_material_changes.package_name
            end
        end
    end

    if #package_names > 0 then
        local item_info_by_slot = self._item_info_by_slot
        local previous_slot_data = item_info_by_slot[item_slot_type]

        if previous_slot_data then
            self:_destroy_item_units_by_slot(item_slot_type)
            self:_unload_item_packages_by_slot(item_slot_type)
        end

        item_info_by_slot[item_slot_type] = {
            name = item_name,
            package_names = package_names,
            spawn_data = spawn_data
        }

        self:_load_packages(package_names)
    end
end

VermitannicaPreviewer._unload_item_packages_by_slot = function (self, slot_type)
    local item_info_by_slot = self._item_info_by_slot

    if item_info_by_slot[slot_type] then
        local slot_type_data = item_info_by_slot[slot_type]
        local package_names = slot_type_data.package_names
        local reference_name = self.NAME
        local package_manager = Managers.package

        for _, package_name in ipairs(package_names) do
            if package_manager:can_unload(package_name) then
                package_manager:unload(package_name, reference_name)
            end
        end

        item_info_by_slot[slot_type] = nil
    end
end

VermitannicaPreviewer._poll_item_package_loading = function (self)
    local hero_unit = self.hero_unit

    if not Unit.alive(hero_unit) then
        return
    end

    if self._requested_hero_spawn_data then
        return
    end

    local reference_name = self.NAME
    local package_manager = Managers.package
    local item_info_by_slot = self._item_info_by_slot

    for slot_name, data in pairs(item_info_by_slot) do
        if not data.loaded then
            local package_names = data.package_names
            local all_packages_loaded = true

            for i = 1, #package_names, 1 do
                local package_name = package_names[i]

                if not package_manager:has_loaded(package_name, reference_name) then
                    all_packages_loaded = false

                    break
                end
            end

            if all_packages_loaded then
                data.loaded = true
                local item_name = data.name
                local spawn_data = data.spawn_data

                self:_spawn_item(item_name, spawn_data)
            end
        end
    end
end

function VermitannicaPreviewer:_handle_spawn_requests()
    local requested_units_spawn_data = self._requested_units_spawn_data
    if requested_units_spawn_data then
        for index, spawn_data in pairs(requested_units_spawn_data) do
            local frame_delay = spawn_data.frame_delay
            if frame_delay == 0 then
                self:_load_unit(spawn_data.unit_data)

                requested_units_spawn_data[index] = nil
            else
                spawn_data.frame_delay = frame_delay - 1
            end
        end
    end
end

VermitannicaPreviewer._handle_spawn_requests = function (self)
    if self._requested_hero_spawn_data then
        local data = self._requested_hero_spawn_data
        local frame_delay = data.frame_delay

        if frame_delay == 0 then
            local profile_name = data.profile_name
            local career_index = data.career_index
            local callback = data.callback
            local skin_name = data.skin_name

            self:_load_hero_unit(profile_name, career_index, callback, skin_name)

            self._requested_hero_spawn_data = nil
        else
            data.frame_delay = frame_delay - 1
        end
    end

    if self._requested_enemy_spawn_data then
        local data = self._requested_enemy_spawn_data
        local frame_delay = data.frame_delay


        if frame_delay == 0 then
            local enemy_name = data.enemy_name
            local callback = data.callback
            local camera_move_duration = data.camera_move_duration

            self:_load_enemy_unit(enemy_name, callback, camera_move_duration)

            self._requested_enemy_spawn_data = nil
        else
            data.frame_delay = frame_delay - 1
        end
    end
end

VermitannicaPreviewer._load_enemy_unit = function (self, enemy_name, callback, camera_move_duration)
    self:_unload_enemy_packages()

    camera_move_duration = camera_move_duration or 0.01

    self._camera_move_duration = camera_move_duration
    self._current_enemy_name = enemy_name

    local package_names = {}
    local enemy_alias = EnemyPackageLoaderSettings.alias_to_breed[enemy_name] or enemy_name

    local unit_name = "resource_packages/breeds/" .. enemy_alias
    package_names[#package_names + 1] = unit_name

    local data = {
        num_loaded_packages = 0,
        package_names = package_names,
        num_packages = #package_names,
        callback = callback,
        enemy_name = enemy_name
    }

    self:_load_packages(package_names)
    self._enemy_loading_package_data = data
end

function VermitannicaPreviewer:_load_unit(unit_data)

end

VermitannicaPreviewer._load_hero_unit = function (self, profile_name, career_index, callback, skin_name)
    self.unit_params.hero.xy_angle_target = DEFAULT_ANGLE

    self:_unload_item_packages()
    self:_unload_hero_packages()

    self._current_profile_name = profile_name

    local profile_index = FindProfileIndex(profile_name)
    local profile = SPProfiles[profile_index]
    local career = profile.careers[career_index]
    local career_name = career.name
    local skin_item = BackendUtils.get_loadout_item(career_name, "slot_skin")
    local item_data = skin_item and skin_item.data
    skin_name = skin_name or (item_data and item_data.name) or career.base_skin

    self._current_career_name = career_name
    self.hero_unit_skin_data = nil

    local skin_data = Cosmetics[skin_name]
    local unit_name = skin_data.third_person

    local package_names = {}
    package_names[#package_names + 1] = unit_name

    local material_changes = skin_data.material_changes
    if material_changes then
        local material_package = material_changes.package_name
        package_names[#package_names + 1] = material_package
    end

    local data = {
        num_loaded_packages = 0,
        career_name = career_name,
        skin_data = skin_data,
        career_index = career_index,
        package_names = package_names,
        num_packages = #package_names,
        callback = callback
    }

    self:_load_packages(package_names)

    self._hero_loading_package_data = data
end

function VermitannicaPreviewer:request_spawn_hero_unit(params, reset_camera)
    self._requested_hero_spawn_data = {
        frame_delay = 1,
        profile_name = params.profile_name,
        career_index = params.career_index,
        skin_name = params.skin_name,
        callback = params.callback
    }

    self:_clear_hero_units()

    if reset_camera then
        self:_reset_camera()
    end
end

VermitannicaPreviewer.request_spawn_hero_unit = function (self, profile_name, career_index, callback, camera_move_duration, skin_name, reset_camera)
    self._requested_hero_spawn_data = {
        frame_delay = 1,
        profile_name = profile_name,
        career_index = career_index,
        callback = callback,
        skin_name = skin_name,
        camera_move_duration = camera_move_duration
    }

    self:_clear_hero_units(reset_camera)
end

function VermitannicaPreviewer:request_spawn_enemy_unit(params, reset_camera)
    self._requested_enemy_spawn_data = {
        frame_delay = 1,
        enemy_name = params.enemy_name,
        wait_for_state_machine = wait_for_state_machine[params.enemy_name],
        callback = params.callback
    }

    self:_clear_enemy_units()

    if reset_camera then
        self:_reset_camera()
    end

end

VermitannicaPreviewer.request_spawn_enemy_unit = function (self, enemy_name, callback, reset_camera)
    self._requested_enemy_spawn_data = {
        frame_delay = 1,
        enemy_name = enemy_name,
        callback = callback
    }

    self.waiting_for_state_machine = wait_for_state_machine[enemy_name]

    self:_clear_enemy_units()

    if reset_camera then
        local camera_params = self.camera_params
        local unit_params = self.unit_params
        local enemy_params = unit_params.enemy
        local hero_params = unit_params.hero

        hero_params.xy_angle_target = DEFAULT_ANGLE
        enemy_params.xy_angle_target = -DEFAULT_ANGLE
        camera_params.zoom_target = 0
        camera_params.z_pan_target = 0
        camera_params.x_pan_target = 0
    end
end

function VermitannicaPreviewer:_reset_camera()
    local camera_params = self.camera_params
    local unit_params = self.unit_params
    local enemy_params = unit_params.enemy
    local hero_params = unit_params.hero

    hero_params.xy_angle_target = DEFAULT_ANGLE
    enemy_params.xy_angle_target = -DEFAULT_ANGLE
    camera_params.zoom_target = 0
    camera_params.z_pan_target = 0
    camera_params.x_pan_target = 0
end

VermitannicaPreviewer.request_browser_mode = function (self, browser_mode)
    self._browser_mode = browser_mode
    local camera_params = self.camera_params
    local unit_params = self.unit_params
    local hero_params = unit_params.hero
    local enemy_params = unit_params.enemy
    if not browser_mode then
        enemy_params.xy_angle_target = -DEFAULT_ANGLE
        hero_params.xy_angle_target = DEFAULT_ANGLE
        camera_params.zoom_target = 0
        camera_params.z_pan_target = 0
        camera_params.x_pan_target = 0
        --self:_set_hero_visibility(true)
    elseif browser_mode == "enemy_browser" then
        enemy_params.xy_angle_target = 0
        --self:_set_hero_visibility(false)
    elseif browser_mode == "hero_browser" then
        hero_params.xy_angle_target = (DEFAULT_ANGLE / 2)
        --self:_set_hero_visibility(true)
    end
end