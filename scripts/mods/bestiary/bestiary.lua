local mod = get_mod("vermitannica")
local statistics_list_name = script_data["eac-untrusted"] and "modded_list" or "official_list"
--mod.statistics_list = mod:get(statistics_list_name) or {}

mod.on_unload = function()
    --mod:set(statistics_list_name, mod.statistics_list)
end

------------------------------------------------------------------------------------------------------------------------
--- BESTIARY VIEWSTATE -------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
mod:dofile("scripts/mods/bestiary/bestiary_state_overview")
local view_manager = VermitannicaManagers.view
view_manager:register_view_state({
    name = "bestiary",
    display_name = mod:localize("bestiary"),
    state_name = "BestiaryStateOverview",
    draw_background_world = true,
    draw_hero_unit = false,
    draw_enemy_unit = true,
    camera_position = { 0, 4.0, 1.55 }
})

local function open_bestiary()
    view_manager:state_transition_by_name("bestiary", "toggle")
end

mod.open_bestiary = open_bestiary
mod:command("bestiary", mod:localize("bestiary_command_description"), open_bestiary)

------------------------------------------------------------------------------------------------------------------------
--- DEPRECATED ---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--local player_definitions = StatisticsDefinitions.player
--
--player_definitions.damage_received_per_breed = { value = 0, name = "damage_received_per_breed" }
--player_definitions.times_downed_per_breed = { value = 0, name = "times_downed_per_breed" }
--player_definitions.slain_per_breed = { value = 0, name = "slain_per_breed" }
--player_definitions.headshots_per_breed_ranged = { value = 0, name = "headshots_per_breed_ranged" }
--player_definitions.headshots_per_breed_melee = { value = 0, name = "headshots_per_breed_melee" }
--player_definitions.globadier_enemies_suffocated = { value = 0, name = "globadier_enemies_suffocated" }
--player_definitions.warpfire_enemies_incinerated = { value = 0, name = "warpfire_enemies_incinerated" }
--for breed_name, _ in pairs(PlayerBreeds) do
--    player_definitions.slain_per_breed[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--
--    player_definitions.damage_received_per_breed[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--
--    player_definitions.times_downed_per_breed[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--
--    player_definitions.headshots_per_breed_ranged[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--    player_definitions.headshots_per_breed_melee[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--end
--for breed_name, breed in pairs(Breeds) do
--    player_definitions.slain_per_breed[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--
--    player_definitions.damage_received_per_breed[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--
--    player_definitions.times_downed_per_breed[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--
--    player_definitions.headshots_per_breed_ranged[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--    player_definitions.headshots_per_breed_melee[breed_name] = {
--        value = 0,
--        name = breed_name
--    }
--end
--
--
--local function set_mod_stat (stat, how, ...)
--    if not stat then return end
--    local arg_n = select("#", ...)
--    if not how then arg_n = arg_n - 1 end
--
--    local stat_path = ""
--    for i = 1, arg_n, 1 do
--        local arg_value = select(i, ...)
--        stat = stat[arg_value]
--        stat_path = stat_path..tostring(arg_value)..(i < arg_n and "_" or "")
--    end
--
--    local local_stats = mod.statistics_list
--    local current_value = local_stats[stat_path] or 0
--    local new_value
--    if how == "increment" then
--        new_value = current_value + 1
--    elseif how == "decrement" then
--        new_value = current_value - 1
--    else
--        new_value = current_value + select(arg_n + 1, ...)
--    end
--
--    local_stats[stat_path] = new_value
--    --mod:set(mod.statistics_list, local_stats)
--    mod.statistics_list = local_stats
--end
--
--mod:hook_safe(StatisticsDatabase, "increment_stat", function (self, id, ...)
--    local arg_n = select("#", ...)
--    local args = ""
--    for i = 1, arg_n, 1 do
--        args = args .. select(i, ...) .. (i < arg_n and "_" or "")
--    end
--    set_mod_stat(self.statistics[id], "increment", ...)
--end)
--
--mod:hook_safe(StatisticsDatabase, "decrement_stat", function (self, id, ...)
--    set_mod_stat(self.statistics[id], "decrement", ...)
--end)
--
--mod:hook_safe(StatisticsDatabase, "modify_stat_by_amount", function (self, id, ...)
--    set_mod_stat(self.statistics[id], nil, ...)
--end)
--
--mod:hook_safe(QuestSettings, "check_num_enemies_killed_by_poison", function (unit, unit_extension)
--    set_mod_stat(mod.stats_id, "increment", "globadier_enemies_suffocated")
--end)
--
--mod:hook_safe(QuestSettings, "check_num_enemies_killed_by_warpfire", function (unit, attacker_unit)
--    set_mod_stat(mod.stats_id, "increment", "warpfire_enemies_incinerated")
--end)
--
--mod:hook_safe(DeathSystem, "kill_unit", function (self, unit, killing_blow)
--    local player_manager = Managers.player
--    local player = player_manager:local_player()
--    local player_unit = player.player_unit
--
--    if player_unit == unit then
--        local status_extension = ScriptUnit.extension(player_unit, "status_system")
--
--        if not status_extension:is_knocked_down() then
--            local attacker_unit = killing_blow[DamageDataIndex.ATTACKER]
--            attacker_unit = AiUtils.get_actual_attacker_unit(attacker_unit)
--
--            if AiUtils.unit_alive(attacker_unit) then
--                local breed = ( Unit.has_data(attacker_unit, "breed") == true and Unit.get_data(attacker_unit, "breed") ) or nil
--
--                if breed ~= nil then
--                    local breed_name = breed.name
--                    mod.stats_db:increment_stat(mod.stats_id, "times_downed_per_breed", breed_name)
--                end
--            end
--        end
--    end
--
--end)
--
--mod:hook_safe(PlayerUnitHealthExtension, "knock_down", function (self, unit)
--    local player_manager = Managers.player
--    local player = player_manager:local_player()
--    local player_unit = player.player_unit
--
--    if player_unit == unit then
--        local attacker_unit = mod.attacker_unit
--
--        if AiUtils.unit_alive(attacker_unit) then
--            local breed = ( Unit.has_data(attacker_unit, "breed") == true and Unit.get_data(attacker_unit, "breed") ) or nil
--
--            if breed ~= nil then
--                local breed_name = breed.name
--                mod.stats_db:increment_stat(mod.stats_id, "times_downed_per_breed", breed_name)
--            end
--        end
--
--    end
--end)
--
--mod:hook_safe(StatisticsUtil, "register_kill", function (victim_unit, damage_data, stats_db)
--    local player_manager = Managers.player
--    local player = player_manager:local_player()
--    local player_unit = player.player_unit
--
--    local attacker_unit = AiUtils.get_actual_attacker_unit(damage_data[DamageDataIndex.ATTACKER])
--
--    if AiUtils.unit_alive(attacker_unit) and attacker_unit == player_unit then
--        local breed = (Unit.has_data(victim_unit, "breed") == true and Unit.get_data(victim_unit, "breed") ) or nil
--
--        if breed ~= nil then
--            local breed_name = breed.name
--            local hit_zone = damage_data[DamageDataIndex.HIT_ZONE]
--            local damage_source = damage_data[DamageDataIndex.DAMAGE_SOURCE_NAME]
--            local master_list_item = rawget(ItemMasterList, damage_source)
--
--            stats_db:increment_stat(mod.stats_id, "slain_per_breed", breed_name)
--
--            if master_list_item then
--                local slot_type = master_list_item.slot_type
--
--                if hit_zone == "head" then
--                    if slot_type == "melee" then
--                        stats_db:increment_stat(mod.stats_id, "headshots_per_breed_melee", breed_name)
--                    elseif slot_type == "ranged" then
--                        stats_db:increment_stat(mod.stats_id, "headshots_per_breed_ranged", breed_name)
--                    end
--                end
--            end
--        end
--    end
--end)
--
--mod:hook_safe(StatisticsUtil, "register_damage", function (victim_unit, damage_data, stats_db)
--    local player_manager = Managers.player
--    local player = player_manager:local_player()
--    local player_unit = player.player_unit
--
--    local attacker_unit = damage_data[DamageDataIndex.ATTACKER]
--    attacker_unit = AiUtils.get_actual_attacker_unit(attacker_unit)
--
--    if AiUtils.unit_alive(attacker_unit) and victim_unit == player_unit then
--        local status_extension = ScriptUnit.extension(player_unit, "status_system")
--
--        if not status_extension:is_knocked_down() then
--            mod.attacker_unit = attacker_unit
--            local breed = ( Unit.has_data(attacker_unit, "breed") == true and Unit.get_data(attacker_unit, "breed") ) or nil
--
--            if breed ~= nil then
--                local breed_name = breed.name
--
--                local damage_amount = damage_data[DamageDataIndex.DAMAGE_AMOUNT]
--
--                stats_db:modify_stat_by_amount(mod.stats_id, "damage_received_per_breed", breed_name, damage_amount)
--            end
--        end
--    end
--end)
--
--mod:hook_safe(StateInGameRunning, "update", function (self)
--    mod.ingame_ui_context = self.ingame_ui_context
--    mod.stats_db = self.ingame_ui_context.statistics_db
--    mod.stats_id = self.ingame_ui_context.stats_id
--end)

--mod.init_stats = function ()
--    if not mod:get("stats_initialized") then
--        local local_stats = mod.statistics_list
--
--        for breed_name, breed in pairs(Breeds) do
--            local spb = "slain_per_breed_"..breed_name
--            local kpb = "kills_per_breed_"..breed_name
--            if not local_stats[spb] then
--                local_stats[spb] = local_stats[kpb] or 0
--            else
--                local_stats[spb] = local_stats[spb] + (local_stats[kpb] or 0)
--            end
--        end
--        mod.statistics_list = local_stats
--
--        mod:set("stats_initialized", true)
--    end
--end

--mod.init_stats()

mod:hook_safe(HeroViewStateOverview, "_handle_input", function (self, dt, t)
    local bestiary_button = self._widgets_by_name.bestiary_button
    UIWidgetUtils.animate_default_button(bestiary_button, dt)

    if self:_is_button_hover_enter(bestiary_button) then
        self:play_sound("play_gui_equipment_button_hover")
    end

    if self:_is_button_pressed(bestiary_button) then
        open_bestiary()
    end
end)

mod:hook(HeroViewStateOverview, "create_ui_elements", function (orig_func, self, params)
    mod:hook_enable(UISceneGraph, "init_scenegraph")

    local result = orig_func(self, params)

    local bestiary_button_widget_definition = UIWidgets.create_default_button("bestiary_button", { 380, 42 }, nil, nil, mod:localize("bestiary"), 24, nil, "button_detail_04", 34)
    local bestiary_button_widget = UIWidget.init(bestiary_button_widget_definition)
    self._widgets[#self._widgets + 1] = bestiary_button_widget
    self._widgets_by_name["bestiary_button"] = bestiary_button_widget

    mod:hook_disable(UISceneGraph, "init_scenegraph")

    return result
end)

mod:hook(UISceneGraph, "init_scenegraph", function (orig_func, scenegraph)
    scenegraph.bestiary_button = {
        vertical_alignment = "bottom",
        horizontal_alignment = "right",
        parent = "window",
        size = { 380, 42 },
        position = { -150, -16, 10 }
    }

    return orig_func(scenegraph)
end)
mod:hook_disable(UISceneGraph, "init_scenegraph")
