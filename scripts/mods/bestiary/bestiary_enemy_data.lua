local mod = get_mod("vermitannica")

local breed_textures = UISettings.breed_textures
local skaven_lore_strings = dofile("scripts/mods/bestiary/skaven_enemies_strings")

local stats_data = {
    skaven_warpfire_thrower = {
        {
            stat = "warpfire_kill_before_shooting",
            text = "Killed Before Shooting"
        },
        {
            stat = "warpfire_kill_on_power_cell",
            text = "Power Cells Destroyed"
        },
        {
            stat = "warpfire_enemies_incinerated",
            text = "Enemies Incinerated"
        }
    },
    skaven_poison_wind_globadier = {
        {
            stat = "globadier_kill_before_throwing",
            text = "Killed Before Throwing"
        },
        {
            stat = "globadier_kill_during_suicide",
            text = "Killed During Suicide"
        },
        {
            stat = "globadier_enemies_suffocated",
            text = "Enemies Suffocated"
        }
    },
    skaven_gutter_runner = {
        {
            stat = "gutter_runner_killed_on_pounce",
            text = "Killed Mid-Pounce"
        },
        {
            stat = "gutter_runner_push_on_pounce",
            text = "Pushed Mid-Pounce"
        },
        {
            stat = "gutter_runner_push_on_target_pounced",
            text = "Kills Interrupted"
        }
    },
    skaven_ratling_gunner = {
        {
            stat = "ratling_gunner_killed_by_melee",
            text = "Killed by Melee"
        },
        {
            stat = "ratling_gunner_killed_while_shooting",
            text = "Killed While Shooting"
        },
        {
            stat = "ratling_gunner_blocked_shot",
            text = "Shots Blocked"
        }
    },
    skaven_pack_master = {
        {
            stat = "pack_master_dodged_attack",
            text = "Grabs Dodged"
        },
        {
            stat = "pack_master_kill_abducting_ally",
            text = "Abductions Foiled"
        },
        {
            stat = "pack_master_rescue_hoisted_ally",
            text = "Hoisted Allies Rescued"
        }
    },
    chaos_corruptor_sorcerer = {
        {
            stat = "corruptor_killed_at_teleport_time",
            text = "Killed After Teleporting"
        },
        {
            stat = "corruptor_dodged_attack",
            text = "Projectiles Dodged"
        },
        {
            stat = "corruptor_killed_while_grabbing",
            text = "Leeched Allies Released"
        }
    },
    chaos_vortex_sorcerer = {
        {
            stat = "vortex_sorcerer_killed_while_summoning",
            text = "Killed While Conjuring"
        },
        {
            stat = "vortex_sorcerer_killed_while_ally_in_vortex",
            text = "Allies Grounded"
        },
        {
            stat = "vortex_sorcerer_killed_by_melee",
            text = "Killed by Melee"
        }
    },

    skaven_rat_ogre = {
        {
            stat = "rat_ogre_killed_mid_leap",
            text = "Killed Mid-Leap"
        },
        {
            stat = "rat_ogre_killed_without_dealing_damage",
            text = "Perfect Kill"
        }
    },
    skaven_stormfiend = {
        {
            stat = "stormfiend_killed_without_burn_damage",
            text = "Killed Without Burn Damage"
        },
        {
            stat = "stormfiend_killed_on_controller",
            text = "Controllers Gutted"
        }
    },
    chaos_troll = {
        {
            stat = "chaos_troll_killed_without_regen",
            text = "Killed Without Regenerating"
        },
        {
            stat = "chaos_troll_killed_without_bile_damage",
            text = "Killed Without Bile Damage"
        }
    },
    chaos_spawn = {
        {
            stat = "chaos_spawn_killed_while_grabbing",
            text = "Killed While Grabbing Ally"
        },
        {
            stat = "chaos_spawn_killed_without_having_grabbed",
            text = "Killed Without Being Grabbed"
        }
    }
}

local skaven_icon_slots = {
    {
        breed_textures.skaven_slave,
        "skaven_slave",
    },
    {
        breed_textures.skaven_clan_rat,
        {
            "skaven_clan_rat",
            "skaven_clan_rat_with_shield"
        }
    },
    {
        breed_textures.skaven_plague_monk,
        "skaven_plague_monk"
    },

    {
        breed_textures.skaven_storm_vermin,
        {
            "skaven_storm_vermin",
            "skaven_storm_vermin_with_shield",
        }
    },
    {
        breed_textures.skaven_warpfire_thrower,
        "skaven_warpfire_thrower"
    },
    {
        breed_textures.skaven_poison_wind_globadier,
        "skaven_poison_wind_globadier"
    },
    {
        breed_textures.skaven_gutter_runner,
        "skaven_gutter_runner"
    },
    {
        breed_textures.skaven_ratling_gunner,
        "skaven_ratling_gunner"
    },
    {
        breed_textures.skaven_pack_master,
        "skaven_pack_master"
    },
    {
        breed_textures.skaven_loot_rat,
        "skaven_loot_rat"
    },
    {
        breed_textures.skaven_rat_ogre,
        "skaven_rat_ogre"
    },
    {
        breed_textures.skaven_stormfiend,
        "skaven_stormfiend"
    },
    {
        breed_textures.skaven_storm_vermin_warlord,
        "skaven_storm_vermin_warlord"
    },
    {
        breed_textures.skaven_stormfiend_boss,
        "skaven_stormfiend_boss"
    },
    {
        breed_textures.skaven_grey_seer,
        "skaven_grey_seer"
    }
}

local chaos_icon_slots = {
    {
        breed_textures.chaos_fanatic,
        "chaos_fanatic"
    },
    {
        breed_textures.chaos_marauder,
        {
            "chaos_marauder",
            "chaos_marauder_with_shield"
        }
    },
    {
        breed_textures.chaos_berzerker,
        "chaos_berzerker"
    },
    {
        breed_textures.chaos_raider,
        "chaos_raider"
    },
    {
        breed_textures.chaos_warrior,
        "chaos_warrior",
    },
    {
        breed_textures.chaos_corruptor_sorcerer,
        "chaos_corruptor_sorcerer"
    },
    {
        breed_textures.chaos_vortex_sorcerer,
        "chaos_vortex_sorcerer"
    },
    {
        breed_textures.chaos_troll,
        "chaos_troll"
    },
    {
        breed_textures.chaos_spawn,
        "chaos_spawn"
    },
    {
        breed_textures.chaos_exalted_sorcerer,
        "chaos_exalted_sorcerer"
    },
    {
        breed_textures.chaos_exalted_champion_warcamp,
        "chaos_exalted_champion_warcamp"
    },
    {
        breed_textures.chaos_exalted_champion_norsca,
        {
            "chaos_exalted_champion_norsca",
            "chaos_spawn_exalted_champion_norsca"
        }

    },
    {
        breed_textures.beastmen_ungor,
        {
            "beastmen_ungor",
            "beastmen_ungor_archer"
        }
    },
    {
        breed_textures.beastmen_gor,
        "beastmen_gor"
    },
    {
        breed_textures.beastmen_bestigor,
        "beastmen_bestigor"
    },
    {
        breed_textures.beastmen_standard_bearer,
        "beastmen_standard_bearer"
    },
    {
        breed_textures.beastmen_minotaur,
        "beastmen_minotaur"
    }
}

---@type table<string, vermitannica_breed>
local breeds_by_name = {
    skaven_slave = {},
    skaven_clan_rat = {},
    skaven_clan_rat_with_shield = {},
    skaven_plague_monk = {},
    skaven_loot_rat = {},
    skaven_storm_vermin = {},
    skaven_storm_vermin_with_shield = {},
    skaven_warpfire_thrower = {},
    skaven_poison_wind_globadier = {},
    skaven_gutter_runner = {},
    skaven_ratling_gunner = {},
    skaven_pack_master = {},
    skaven_rat_ogre = {},
    skaven_stormfiend = {},
    skaven_storm_vermin_warlord = {},
    skaven_stormfiend_boss = {},
    skaven_grey_seer = {},
    skaven_explosive_loot_rat = {},
    
    chaos_fanatic = {},
    chaos_marauder = {},
    chaos_marauder_with_shield = {},
    chaos_berzerker = {},
    chaos_raider = {},
    chaos_warrior = {},
    chaos_corruptor_sorcerer = {},
    chaos_vortex_sorcerer = {},
    chaos_troll = {},
    chaos_spawn = {},
    chaos_exalted_sorcerer = {},
    chaos_exalted_champion_warcamp = {},
    chaos_exalted_champion_norsca = {},
    chaos_spawn_exalted_champion_norsca = {},
    chaos_exalted_sorcerer_drachenfels = {},

    beastmen_bestigor = {},
    beastmen_gor = {},
    beastmen_minotaur = {},
    beastmen_standard_bearer = {},
    beastmen_ungor = {},
    beastmen_ungor_archer = {}
}

local breed_types = VermitannicaSettings.breed_types

local difficulties = Difficulties
local function populate_difficulty_table(value)
    if not value then
        return
    end

    local t = {}
    for i, _ in ipairs(difficulties) do
        t[i] = value
    end

    return t
end

---@class vermitannica_breed
---@field id string Breed.name
---@field display_name string localized id
---@field race string
---@field armor_category number
---@field breed_type string
---@field health number[]
---@field hit_mass number[]
---@field block_mass number[]
---@field stagger_resist number[]
---@field linesman_modifier number
---@field heavy_linesman_modifier number
---@field tank_modifier number
---@field inventory_config inventory_config
for breed_name, breed in pairs(breeds_by_name) do

    local breed_data = Breeds[breed_name]

    local name = Localize(breed_name)
    if string.match(name, "<.*>") then
        name = mod:localize(breed_name)
    end

    breed.id = breed_name
    breed.display_name = name
    breed.race = breed_data.race
    breed.armor_category = breed_data.primary_armor_category or breed_data.armor_category

    local breed_type = (breed_data.lord_damage_reduction or breed_data.armored_boss_damage_reduction) and breed_types.lord
            or breed_data.boss and breed_types.boss
            or breed_data.special and breed_types.special
            or breed_data.elite and breed_types.elite
            or breed_types.infantry
    breed.breed_type = breed_type

    breed.health = breed_data.max_health
    breed.hit_mass = breed_data.hit_mass_counts or populate_difficulty_table(breed_data.hit_mass_count) or populate_difficulty_table(1)
    breed.block_mass = breed_data.hit_mass_counts_block or populate_difficulty_table(breed_data.hit_mass_count_block)
    breed.stagger_resist = breed_data.diff_stagger_resist or populate_difficulty_table(breed_data.stagger_resistance) or populate_difficulty_table(2)
    breed.linesman_modifier = LINESMAN_HIT_MASS_COUNT[breed_name]
    breed.tank_modifier = TANK_HIT_MASS_COUNT[breed_name]
    breed.heavy_linesman_modifier = HEAVY_LINESMAN_HIT_MASS_COUNT[breed_name]

    local inventory_template_name = breed_data.default_inventory_template
    local inventory_template_function = AIInventoryTemplates[inventory_template_name]
    if inventory_template_function then
        local config_name = inventory_template_function()
        breed.inventory_config = InventoryConfigurations[config_name]
    end

    breed.lore_strings = skaven_lore_strings[breed_name]
    breed.stats_data = stats_data[breed_name]
end

local sort_directions = {
    ASC = "asc",
    DESC = "desc"
}

---@type vermitannica_breed[]
local breeds = {
    sort_property = "race",
    sort_direction = sort_directions.DESC,

    sort_property_secondary = "display_name",
    sort_direction_secondary = sort_directions.ASC

}
for _, breed in pairs(breeds_by_name) do
    breeds[#breeds + 1] = breed
end
table.sort(breeds, function (breed_a, breed_b)

    local sort_direction = breeds.sort_direction or sort_directions.ASC
    local sort_property = breeds.sort_property or "display_name"
    local a_value = breed_a[sort_property]
    local b_value = breed_b[sort_property]

    if a_value and not b_value then
        return true
    elseif not a_value and b_value then
        return false
    end

    if type(a_value) == "table" or type(b_value) == "table" then
        return false
    end

    if a_value == b_value then
        sort_property = breeds.sort_property_secondary or "display_name"
        sort_direction = breeds.sort_direction_secondary or sort_direction
        a_value = breed_a[sort_property]
        b_value = breed_b[sort_property]

        if a_value and not b_value then
            return true
        elseif not a_value and b_value then
            return false
        end

        if type(a_value) == "table" or type(b_value) == "table" then
            return false
        end

        if sort_direction == sort_directions.DESC then
            return a_value > b_value
        else
            return a_value < b_value
        end
    end

    if sort_direction == sort_directions.DESC then
        return a_value > b_value
    else
        return a_value < b_value
    end

end)

--[[
    Manual Overrides
]]

-- Combine the statistics for the following breeds
breeds_by_name.skaven_storm_vermin.combine_with = "skaven_storm_vermin_commander"
breeds_by_name.skaven_storm_vermin_with_shield.combine_with = "skaven_storm_vermin_commander_with_shield"
breeds_by_name.chaos_exalted_champion_norsca.combine_with = "chaos_spawn_exalted_champion_norsca"
breeds_by_name.chaos_spawn_exalted_champion_norsca.combine_with = "chaos_exalted_champion_norsca"


-- Override Gatekeeper Naglfahr's inventory template to bypass unit spawning issues with his usual axes
breeds_by_name.chaos_exalted_champion_norsca.inventory_config = {
    anim_state_event = "to_spear",
    items = {
        {
            {
                drop_on_hit = true,
                unit_name = "units/weapons/enemy/wpn_chaos_set/wpn_chaos_2h_axe_03",
                attachment_node_linking = AttachmentNodeLinking.ai_2h
            }
        }
    }
}

-- Override Ungor Archer inventory template until config switching is implemented
--breeds_by_name.beastmen_ungor_archer.inventory_config = table.clone(InventoryConfigurations.beastmen_ungor_spear)
--breeds_by_name.beastmen_ungor_archer.inventory_config.anim_state_event = InventoryConfigurations.beastmen_ungor_bow.anim_state_event
--breeds_by_name.beastmen_ungor_archer.inventory_config.items[1] = InventoryConfigurations.beastmen_ungor_bow.items[1]

return {
    skaven_icon_slots = skaven_icon_slots,
    chaos_icon_slots = chaos_icon_slots,
    breed_data_by_name = breeds_by_name,
    breed_data_sorted = breeds
}