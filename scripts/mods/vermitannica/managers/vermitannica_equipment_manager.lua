local mod = get_mod("vermitannica")

VermitannicaEquipmentManager = class(VermitannicaEquipmentManager)
VermitannicaEquipmentManager.NAME = "VermitannicaEquipmentManager"


VermitannicaEquipmentManager.get_career = function (self)
    return self.career
end

VermitannicaEquipmentManager.change_career = function (self, career_name, callback)
    self.wanted_career_data = {
        career_name = career_name,
        callback = callback
    }

    self.career = career_name
end

VermitannicaEquipmentManager.get_hero_skin = function (self)
    local career_name = self.career
    local career_equipment = self.career_equipment[career_name]
    local equipped_hero_skin_name = career_equipment.equipped_hero_skin_name

    return equipped_hero_skin_name
end

VermitannicaEquipmentManager.change_hero_skin = function (self, hero_skin_name, skip_loading)

    if not skip_loading then
        self.wanted_hero_skin_data = {
            hero_skin_name = hero_skin_name
        }
    end

    self.career_equipment[self.career].equipped_hero_skin_name = hero_skin_name
end

VermitannicaEquipmentManager.get_hat = function (self)
    local career_name = self.career
    local career_equipment = self.career_equipment[career_name]
    local equipped_hat_name = career_equipment.equipped_hat_name

    return equipped_hat_name
end

VermitannicaEquipmentManager.change_hat = function (self, hat_name, skip_loading)

    if not skip_loading then
        self.wanted_hat_data = {
            hat_name = hat_name
        }
    end

    self.career_equipment[self.career].equipped_hat_name = hat_name
end

VermitannicaEquipmentManager.get_weapon = function (self)
    local career_name = self.career
    local career_equipment = self.career_equipment[career_name]
    local equipped_weapon_name = career_equipment.equipped_weapon_name

    return equipped_weapon_name
end

VermitannicaEquipmentManager.change_weapon = function (self, weapon_name, skip_loading)

    if not skip_loading then
        self.wanted_weapon_data = {
            weapon_name = weapon_name
        }
    end

    self.career_equipment[self.career].equipped_weapon_name = weapon_name
end

VermitannicaEquipmentManager.get_weapon_skin = function (self)
    local career_name = self.career
    local career_equipment = self.career_equipment[career_name]
    local equipped_weapon_name = career_equipment.equipped_weapon_name
    local weapon_skin_name = career_equipment.weapon_skin_by_weapon_name[equipped_weapon_name]

    return weapon_skin_name
end

VermitannicaEquipmentManager.change_weapon_skin = function (self, weapon_skin_name, skip_loading)

    if not skip_loading then
        self.wanted_weapon_skin_data = {
            weapon_skin_name = weapon_skin_name
        }
    end

    local career_equipment = self.career_equipment[self.career]
    local weapon_name = career_equipment.equipped_weapon_name

    career_equipment.weapon_skin_by_weapon_name[weapon_name] = weapon_skin_name
end


VermitannicaEquipmentManager.get_career_equipment = function (self)
    local career_name = self.career

    return self.career_equipment[career_name]
end

VermitannicaEquipmentManager.init = function (self, params, initial_profile_index, initial_career_index)

    local initial_profile_settings = SPProfiles[initial_profile_index]
    local initial_career_settings = initial_profile_settings.careers[initial_career_index]
    self.career = initial_career_settings.name
    self.world_previewer = params.world_previewer
    self._camera_move_duration = UISettings.console_menu_camera_move_duration

    if mod:get("remember_customizations") and mod.career_equipment then

        self.career_equipment = mod.career_equipment

    else
        self.career_equipment = {}

        for profile_index, profile_abbreviation in pairs(SPProfilesAbbreviation) do
            local profile_settings = SPProfiles[profile_index]

            for career_index, career_settings in pairs(profile_settings.careers) do
                local career_name = career_settings.name

                if initial_profile_index == profile_index and initial_career_index == career_index then
                    self.career = career_name
                end

                local hero_skin = BackendUtils.get_loadout_item(career_name, "slot_skin")
                local melee_weapon = BackendUtils.get_loadout_item(career_name, "slot_melee")
                local hat = BackendUtils.get_loadout_item(career_name, "slot_hat")

                if hero_skin and melee_weapon and hat then
                    self.career_equipment[career_name] = {
                        equipped_weapon_name = melee_weapon.key,
                        equipped_hero_skin_name = hero_skin.data.name,
                        equipped_hat_name = hat.key,
                        hero_skins = {},
                        hats = {},
                        weapon_skins = {},
                        weapon_skin_by_weapon_name = {}
                    }

                    local career_equipment = self.career_equipment[career_name]
                    for item_name, item_settings in pairs(ItemMasterList) do
                        local slot_type = item_settings.slot_type

                        local can_wield = table.contains(item_settings.can_wield, career_name)
                        if can_wield and item_settings.rarity ~= "magic" then
                            if slot_type == "melee" or slot_type == "ranged" then
                                local initial_skin
                                local equipped_weapon_skin = melee_weapon.skin
                                local default_skin = WeaponSkins.default_skins[item_name]

                                initial_skin = (item_name == career_equipment.equipped_weapon_name and equipped_weapon_skin) or default_skin
                                career_equipment.weapon_skin_by_weapon_name[item_name] = initial_skin

                                local skin_combination_table = item_settings.skin_combination_table
                                local skin_tables = WeaponSkins.skin_combinations[skin_combination_table]

                                local weapon_skins = { default_skin }
                                for _, skin_table in pairs(skin_tables or {}) do
                                    for _, weapon_skin_name in ipairs(skin_table) do
                                        if not table.contains(weapon_skins, weapon_skin_name) then
                                            weapon_skins[#weapon_skins + 1] = weapon_skin_name
                                        end
                                    end
                                end

                                career_equipment.weapon_skins[item_name] = weapon_skins
                            elseif slot_type == "skin" then
                                local hero_skins = career_equipment.hero_skins
                                hero_skins[#hero_skins + 1] = item_name

                                -- hats that can be wielded by multiple careers seem to be dummy items?
                            elseif slot_type == "hat" and #item_settings.can_wield == 1 then
                                local hats = career_equipment.hats
                                hats[#hats + 1] = item_name
                            end
                        end

                    end
                end

            end

        end

    end

end

VermitannicaEquipmentManager.update = function (self, dt, t)
    return
end

VermitannicaEquipmentManager.post_update = function (self, dt)
    local world_previewer = self.world_previewer
    if not world_previewer then
        return
    end

    self:_handle_career_change()

    if self.career_unit_spawned then
        self:_handle_hero_skin_change()
        self:_handle_hat_change()
        self:_handle_weapon_change()
        self:_handle_weapon_skin_change()
    end

end

VermitannicaEquipmentManager._handle_career_change = function (self)
    local wanted_career_data = self.wanted_career_data
    if wanted_career_data then
        local wanted_career = wanted_career_data.career_name
        local wanted_career_settings = CareerSettings[wanted_career]
        local profile_name = wanted_career_settings.profile_name
        local profile_index = FindProfileIndex(profile_name)
        local career_index = career_index_from_name(profile_index, wanted_career)

        local career_equipment = self.career_equipment[wanted_career]
        local wanted_skin = career_equipment.equipped_hero_skin_name

        self.career = wanted_career

        local callback = callback(self, "_cb_career_unit_spawned", wanted_career_data.callback)
        self.career_unit_spawned = false

        self.world_previewer:request_spawn_hero_unit(profile_name, career_index, callback, self._camera_move_duration, wanted_skin)

        self.wanted_career_data = nil
    end
end

VermitannicaEquipmentManager._handle_hero_skin_change = function (self)
    local wanted_hero_skin_data = self.wanted_hero_skin_data
    if wanted_hero_skin_data then
        local wanted_hero_skin = wanted_hero_skin_data.hero_skin_name
        local career_name = self.career
        local career_settings = CareerSettings[career_name]
        local profile_name = career_settings.profile_name
        local profile_index = FindProfileIndex(profile_name)
        local career_index = career_index_from_name(profile_index, career_name)

        local career_equipment = self.career_equipment[career_name]
        career_equipment.equipped_hero_skin_name = wanted_hero_skin

        local callback = callback(self, "_cb_career_unit_spawned")
        self.career_unit_spawned = false

        self.world_previewer:request_spawn_hero_unit(profile_name, career_index, callback, self._camera_move_duration, wanted_hero_skin)

        self.wanted_hero_skin_data = nil
    end

end

VermitannicaEquipmentManager._cb_career_unit_spawned = function (self, callback)
    self.career_unit_spawned = true

    local career = self.career
    local career_equipment = self.career_equipment[career]
    local wanted_hat = career_equipment.equipped_hat_name
    local wanted_weapon = career_equipment.equipped_weapon_name

    self.wanted_hat_data = {
        hat_name = wanted_hat
    }

    self.wanted_weapon_data = {
        weapon_name = wanted_weapon
    }

    if callback then
        callback()
    end
end

VermitannicaEquipmentManager._handle_hat_change = function (self)
    if not self.career_unit_spawned then
        return
    end

    local wanted_hat_data = self.wanted_hat_data
    if wanted_hat_data then
        local wanted_hat = wanted_hat_data.hat_name
        local career_name = self.career
        local career_equipment = self.career_equipment[career_name]
        career_equipment.equipped_hat_name = wanted_hat

        local hat_settings = ItemMasterList[wanted_hat]
        local slot_type = hat_settings.slot_type
        local slot_names = InventorySettings.slot_names_by_type[slot_type]
        local slot_name = slot_names[1]
        local slot = InventorySettings.slots_by_name[slot_name]

        self.world_previewer:equip_item(wanted_hat, slot)

        self.wanted_hat_data = nil
    end
end

VermitannicaEquipmentManager._handle_weapon_change = function (self)
    if not self.career_unit_spawned then
        return
    end


    local wanted_weapon_data = self.wanted_weapon_data
    if wanted_weapon_data then
        local wanted_weapon = wanted_weapon_data.weapon_name
        local career_name = self.career
        local career_equipment = self.career_equipment[career_name]
        local wanted_weapon_skin = career_equipment.weapon_skin_by_weapon_name[wanted_weapon]

        local weapon_settings = ItemMasterList[wanted_weapon]
        local slot_type = weapon_settings.slot_type
        local slot_names = InventorySettings.slot_names_by_type[slot_type]
        local slot_name = slot_names[1]
        local slot = InventorySettings.slots_by_name[slot_name]

        self.world_previewer:equip_item(wanted_weapon, slot, wanted_weapon_skin)

        self.wanted_weapon_data = nil
    end
end

VermitannicaEquipmentManager._handle_weapon_skin_change = function (self)
    if not self.career_unit_spawned then
        return
    end

    local wanted_weapon_skin_data = self.wanted_weapon_skin_data
    if wanted_weapon_skin_data then
        local wanted_weapon_skin = wanted_weapon_skin_data.weapon_skin_name
        local callback = wanted_weapon_skin_data.callback
        local career_name = self.career
        local career_equipment = self.career_equipment[career_name]
        local equipped_weapon_name = career_equipment.equipped_weapon_name
        career_equipment.weapon_skin_by_weapon_name[equipped_weapon_name] = wanted_weapon_skin

        local weapon_settings = ItemMasterList[equipped_weapon_name]
        local slot_type = weapon_settings.slot_type
        local slot_names = InventorySettings.slot_names_by_type[slot_type]
        local slot_name = slot_names[1]
        local slot = InventorySettings.slots_by_name[slot_name]

        self.world_previewer:equip_item(equipped_weapon_name, slot, wanted_weapon_skin, callback)

        self.wanted_weapon_skin_data = nil
    end
end

VermitannicaEquipmentManager.destroy = function (self)

    if mod:get("remember_customizations") then
        mod.career_equipment = self.career_equipment
    end

end