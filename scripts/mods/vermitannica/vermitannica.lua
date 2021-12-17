local mod = get_mod("vermitannica")

------------------------------------------------------------------------------------------------------------------------
--- INIT ---------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
mod:dofile("scripts/mods/vermitannica/vermitannica_settings")
mod:dofile("scripts/mods/vermitannica/managers/managers")

-- Fill in some extra keymaps
local win32_keymaps = IngameMenuKeymaps and IngameMenuKeymaps.win32
if win32_keymaps then

    if not win32_keymaps.right_hold then
        win32_keymaps.right_hold = {
            "mouse",
            "right",
            "held"
        }
    end

    if not win32_keymaps.shift_hold then
        win32_keymaps.shift_hold = {
            "keyboard",
            "left shift",
            "held"
        }
    end

    if not win32_keymaps.ctrl_hold then
        win32_keymaps.ctrl_hold = {
            "keyboard",
            "left ctrl",
            "held"
        }
    end

    if not win32_keymaps.middle_press then
        win32_keymaps.middle_press = {
            "mouse",
            "middle",
            "pressed"
        }
    end

    if not win32_keymaps.middle_hold then
        win32_keymaps.middle_hold = {
            "mouse",
            "middle",
            "held"
        }
    end
end

------------------------------------------------------------------------------------------------------------------------
--- VERMITANNICA VIEW --------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
mod:dofile("scripts/mods/vermitannica/vermitannica_view/vermitannica_view")

local view_data = {
    view_name = "vermitannica_view",
    view_settings = {
        init_view_function = function (ingame_ui_context)
            mod.ingame_ui_context = ingame_ui_context
            return VermitannicaView:new(ingame_ui_context)
        end,
        active = {
            inn = true,
            ingame = false
        },
        blocked_transitions = {
            inn = {},
            ingame = {}
        }
    },
    view_transitions = {
        open_vermitannica_view = function (ingame_ui, params)
            ingame_ui.current_view = "vermitannica_view"
            ingame_ui.views[ingame_ui.current_view].exit_to_game = true
        end,
        close_vermitannica_view = function (ingame_ui, params)
            ingame_ui.current_view = nil
        end
    }
}
mod:register_view(view_data)

------------------------------------------------------------------------------------------------------------------------
--- VIEWSTATE INIT -----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
local view_manager = VermitannicaManagers.view
view_manager:register_view_state({
    name = "vermitannica",
    display_name = mod:localize("vermitannica"),
    state_name = "VermitannicaStateOverview",
    draw_background_world = true,
    draw_hero_unit = true,
    draw_enemy_unit = true,
    camera_position = { 0, 5.0, 1.55 }
})

local function open_vermitannica()
    view_manager:state_transition_by_name("vermitannica", "toggle")
end
mod.open_vermitannica = open_vermitannica
mod:command("vermitannica", mod:localize("vermitannica"), open_vermitannica)

mod:dofile("scripts/mods/bestiary/bestiary")
mod:dofile("scripts/mods/armory/armory")

------------------------------------------------------------------------------------------------------------------------
--- HOOKS --------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------
--- MOD LIFECYCLE METHODS ----------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
mod.on_unload = function(exit_game)

    --mod.ingame_ui_context = nil
    --
    --local career_equipment = mod.career_equipment
    --mod:set("career_equipment", career_equipment)

end

mod.on_game_state_changed = function(status, state)
    
end

mod.on_setting_changed = function(setting_name)

end

mod.on_disabled = function(is_first_call)

end

mod.on_enabled = function(is_first_call)

end


------------------------------------------------------------------------------------------------------------------------
--- DEPRECATED ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--local weapon_skin_weights = table.clone(WeaponSkins.skin_weights)
--
--weapon_skin_weights.plentiful = 2
--weapon_skin_weights.promo = 3
--
--mod:hook(UITooltipPasses.item_titles, "draw", function (orig_func, ...)
--
--    local pass_data = select(5, ...)
--
--    pass_data.player = nil
--
--    return orig_func(...)
--
--end)
--mod:hook_disable(UITooltipPasses.item_titles, "draw")
--
--UIPasses.vermitannica_tooltip = {
--    init = function (pass_definition, ui_content, ui_style, style_global)
--        local pass_data = {}
--        local pass_definitions = pass_definition.content_passes or {
--            --"equipped_item_title",
--            "item_titles",
--            --"skin_applied",
--            --"deed_mission",
--            --"deed_difficulty",
--            --"mutators",
--            --"deed_rewards",
--            --"ammunition",
--            --"item_power_level",
--            --"properties",
--            --"traits",
--            --"weapon_skin_title",
--            --"item_information_text",
--            --"loot_chest_difficulty",
--            --"loot_chest_power_range",
--            --"unwieldable",
--            --"keywords",
--            "console_item_description",
--            --"light_attack_stats",
--            --"heavy_attack_stats",
--            --"detailed_stats_light",
--            --"detailed_stats_heavy",
--            --"detailed_stats_push",
--            --"detailed_stats_ranged_light",
--            --"detailed_stats_ranged_heavy"
--        }
--        local passes = {}
--
--        for _, pass_name in ipairs(pass_definitions) do
--            passes[#passes + 1] = {
--                data = UITooltipPasses[pass_name].setup_data(),
--                draw = UITooltipPasses[pass_name].draw
--            }
--        end
--
--        pass_data.end_pass = {
--            data = UITooltipPasses.item_background.setup_data(),
--            draw = UITooltipPasses.item_background.draw
--        }
--        pass_data.passes = passes
--        pass_data.size = {
--            400,
--            0
--        }
--        pass_data.alpha_multiplier = 1
--        pass_data.items = {}
--        pass_data.items_alpha_progress = {
--            0,
--            0,
--            0,
--            0
--        }
--        local tooltip_wait_duration = UISettings.tooltip_wait_duration
--        pass_data.alpha_wait_times = {
--            tooltip_wait_duration,
--            tooltip_wait_duration * 2,
--            tooltip_wait_duration * 2,
--            tooltip_wait_duration * 2
--        }
--        pass_data.tooltip_sizes = {}
--        pass_data.equipped_items = {}
--        pass_data.player = nil
--
--        return pass_data
--    end,
--    update = function (ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, input_service, dt, ui_style_global, visible)
--        if not visible then
--            pass_data.player = nil
--            local tooltip_wait_duration = UISettings.tooltip_wait_duration
--            pass_data.alpha_progress = 0
--            pass_data.alpha_wait_time = tooltip_wait_duration
--            local alpha_wait_times = pass_data.alpha_wait_times
--            local items_alpha_progress = pass_data.items_alpha_progress
--
--            if alpha_wait_times then
--                for i = 1, 4, 1 do
--                    alpha_wait_times[i] = tooltip_wait_duration * 2
--                    items_alpha_progress[i] = 0
--                end
--            end
--        end
--    end,
--    draw = function (ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, parent_size, input_service, dt, ui_style_global)
--        if not pass_data.player then
--            pass_data.player = Managers.player:local_player()
--        end
--
--        local preview_item = ui_content[pass_definition.item_id]
--
--        if not preview_item then
--            return
--        end
--
--        local items = pass_data.items
--
--        table.clear(items)
--
--        items[1] = preview_item
--        --local preview_item_backend_id = preview_item.backend_id
--        --local preview_item_data = preview_item.data
--        --local slot_type = preview_item_data.slot_type
--
--        --if slot_type then
--        --    local slot_names = InventorySettings.slot_names_by_type[slot_type]
--        --
--        --    if slot_names then
--        --        local slot_name = slot_names[1]
--        --        local player = pass_data.player
--        --
--        --        if player then
--        --            local equipped_items = pass_data.equipped_items
--        --
--        --            table.clear(equipped_items)
--        --
--        --            local backend_items = Managers.backend:get_interface("items")
--        --            local profile_index = player:profile_index()
--        --            local career_index = player:career_index()
--        --            local hero_data = SPProfiles[profile_index]
--        --            local career_data = hero_data.careers[career_index]
--        --            local career_name = career_data.name
--        --            local loadout = backend_items:get_loadout()[career_name]
--        --
--        --            for _, item_id in pairs(loadout) do
--        --                table.insert(equipped_items, backend_items:get_item_from_id(item_id))
--        --            end
--        --
--        --            local backend_common = Managers.backend:get_interface("common")
--        --            local item_filter = "slot_type == " .. slot_type
--        --            equipped_items = backend_common:filter_items(equipped_items, item_filter)
--        --            pass_data.equipped_items = equipped_items
--        --
--        --            for _, item in ipairs(equipped_items) do
--        --                if item.backend_id ~= preview_item_backend_id then
--        --                    items[#items + 1] = item
--        --                end
--        --            end
--        --        end
--        --    end
--        --end
--
--        local scale = RESOLUTION_LOOKUP.scale
--        local scale_inversed = RESOLUTION_LOOKUP.inv_scale
--        local wanted_max_height = nil
--        local size = pass_data.size
--        local res_w = RESOLUTION_LOOKUP.res_w
--        local res_h = RESOLUTION_LOOKUP.res_h
--        local direction = nil
--
--        if (position[1] + parent_size[1] * 0.5) * scale > res_w * 0.5 then
--            position[1] = position[1] - size[1] - 5
--            direction = -1
--        else
--            position[1] = position[1] + parent_size[1] + 5
--            direction = 1
--        end
--
--        local start_position_x = position[1]
--        local start_position_y = position[2]
--        local start_position_z = position[3]
--        local tooltip_sizes = pass_data.tooltip_sizes
--
--        for index, item in ipairs(items) do
--            local end_pass = pass_data.end_pass
--            local frame_margin = end_pass.data.frame_margin or 0
--            local passes = pass_data.passes
--            local draw = false
--            local draw_downwards = true
--            local loop_func = (draw_downwards and ipairs) or ripairs
--            local tooltip_total_height = 0
--
--            if end_pass then
--                local data = end_pass.data
--                local pass_height = end_pass.draw(data, draw, draw_downwards, ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt, ui_style_global, item)
--                tooltip_total_height = tooltip_total_height + pass_height
--            end
--
--            for _, tooltip_pass in loop_func(passes) do
--                local data = tooltip_pass.data
--                data.frame_margin = frame_margin
--                local pass_height = tooltip_pass.draw(data, draw, draw_downwards, ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt, ui_style_global, item)
--                tooltip_total_height = tooltip_total_height + pass_height
--            end
--
--            tooltip_sizes[index] = tooltip_total_height
--        end
--
--        local top_spacing = 40
--        local equipped_panel_height = 30
--        local num_items = #items
--        local alpha_wait_times = pass_data.alpha_wait_times
--        local items_alpha_progress = pass_data.items_alpha_progress
--
--        for index, item in ipairs(items) do
--            size[2] = 0
--            local draw_downwards = true
--            local loop_func = (draw_downwards and ipairs) or ripairs
--            local passes = pass_data.passes
--            local draw = false
--            local end_pass = pass_data.end_pass
--            local frame_margin = end_pass.data.frame_margin or 0
--            local tooltip_total_height = tooltip_sizes[index]
--            local has_dubble_compares = num_items == 3
--            local first_item = index == 1
--            local alpha_wait_time = alpha_wait_times[index]
--            local alpha_progress = pass_data.alpha_progress
--
--            if alpha_wait_time then
--                if first_item or not alpha_wait_times[1] then
--                    alpha_wait_time = alpha_wait_time - dt
--
--                    if alpha_wait_time <= 0 then
--                        alpha_wait_times[index] = nil
--                    else
--                        alpha_wait_times[index] = alpha_wait_time
--                    end
--
--                    pass_data.alpha_multiplier = 0
--                end
--            else
--                local alpha_progress = items_alpha_progress[index]
--
--                if alpha_progress then
--                    local tooltip_fade_in_speed = UISettings.tooltip_fade_in_speed
--                    local alpha_progress = math.min(alpha_progress + dt * tooltip_fade_in_speed, 1)
--                    pass_data.alpha_multiplier = math.easeOutCubic(alpha_progress)
--
--                    if alpha_progress == 1 then
--                        items_alpha_progress[index] = nil
--                    else
--                        items_alpha_progress[index] = alpha_progress
--                    end
--                else
--                    pass_data.alpha_multiplier = 1
--                end
--
--                if first_item then
--                    position[2] = (position[2] + tooltip_total_height) - frame_margin / 2
--                    local actual_screen_y_position = position[2] * scale + top_spacing
--
--                    if res_h < actual_screen_y_position then
--                        position[2] = position[2] - (actual_screen_y_position - res_h) * scale_inversed
--                    end
--
--                    wanted_max_height = position[2]
--                end
--
--                if not first_item then
--                    if has_dubble_compares and res_h > tooltip_sizes[2] + tooltip_sizes[3] then
--                        position[1] = start_position_x + size[1] * direction
--                        local tooltip_bottom_y_position = wanted_max_height - (tooltip_sizes[2] + tooltip_sizes[3] + equipped_panel_height * 2)
--
--                        if tooltip_bottom_y_position < 0 then
--                            local new_wanted_height = wanted_max_height + math.abs(tooltip_bottom_y_position)
--
--                            if index == 2 then
--                                position[2] = new_wanted_height + equipped_panel_height
--                            else
--                                position[2] = new_wanted_height - (tooltip_sizes[2] + equipped_panel_height)
--                            end
--                        elseif index == 2 then
--                            position[2] = wanted_max_height
--                        else
--                            position[2] = wanted_max_height - (tooltip_sizes[2] + equipped_panel_height * 2)
--                        end
--                    else
--                        position[1] = position[1] + size[1] * direction
--                        local tooltip_bottom_y_position = wanted_max_height - tooltip_total_height
--
--                        if tooltip_bottom_y_position < 0 then
--                            position[2] = wanted_max_height + math.abs(tooltip_bottom_y_position) + equipped_panel_height
--                        else
--                            position[2] = wanted_max_height
--                        end
--                    end
--                end
--
--                local position_x = position[1]
--                local position_y = position[2] + frame_margin / 2 * scale
--                local position_z = position[3]
--                draw = true
--
--                for _, tooltip_pass in loop_func(passes) do
--                    local data = tooltip_pass.data
--                    data.frame_margin = frame_margin
--                    data.equipped_items = pass_data.equipped_items
--                    local pass_height = tooltip_pass.draw(data, draw, draw_downwards, ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt, ui_style_global, item)
--                    size[2] = size[2] + pass_height
--
--                    if draw_downwards then
--                        position[2] = position[2] - pass_height
--                    else
--                        position[2] = position[2] + pass_height
--                    end
--                end
--
--                position[1] = position_x
--                position[2] = position_y
--                position[3] = position_z
--
--                if end_pass then
--                    local data = end_pass.data
--                    slot53 = end_pass.draw(data, draw, draw_downwards, ui_renderer, pass_data, ui_scenegraph, pass_definition, ui_style, ui_content, position, size, input_service, dt, ui_style_global, item)
--                end
--            end
--
--            position[3] = start_position_z
--        end
--    end
--}

--mod:hook_safe(WwiseFlowCallbacks, "wwise_trigger_event", function (t)
--    if t then
--        local name = t.Name or t.name
--        if string.starts_with(name, "ferry") then
--            return
--        end
--
--        for key, value in pairs(t) do
--            mod:echo("%s [%s]", key, value)
--        end
--    end
--end)