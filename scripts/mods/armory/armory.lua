local mod = get_mod("vermitannica")

------------------------------------------------------------------------------------------------------------------------
--- ARMORY VIEWSTATE -------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
mod:dofile("scripts/mods/armory/armory_state_overview")
local view_manager = VermitannicaManagers.view
view_manager:register_view_state({
    name = "armory",
    display_name = mod:localize("armory"),
    state_name = "ArmoryStateOverview",
    draw_background_world = true,
    draw_hero_unit = true,
    draw_enemy_unit = false,
    camera_position = { 0, 3.5, 1.55 }
})

local function open_armory()
    view_manager:state_transition_by_name("armory", "toggle")
end

mod.open_armory = open_armory
mod:command("armory", mod:localize("armory_command_description"), open_armory)

--mod:hook_safe(HeroViewStateOverview, "_handle_input", function (self, dt, t)
--    local armory_button = self._widgets_by_name.armory_button
--    UIWidgetUtils.animate_default_button(armory_button, dt)
--
--    if self:_is_button_hover_enter(armory_button) then
--        self:play_sound("play_gui_equipment_button_hover")
--    end
--
--    if self:_is_button_pressed(armory_button) then
--        open_armory()
--    end
--end)

--mod:hook(HeroViewStateOverview, "create_ui_elements", function (orig_func, self, params)
--    mod:hook_enable(UISceneGraph, "init_scenegraph")
--
--    local result = orig_func(self, params)
--
--    local armory_button_widget_definition = UIWidgets.create_default_button("armory_button", { 380, 42 }, nil, nil, mod:localize("armory"), 24, nil, "button_detail_04", 34)
--    local armory_button_widget = UIWidget.init(armory_button_widget_definition)
--    self._widgets[#self._widgets + 1] = armory_button_widget
--    self._widgets_by_name.armory_button = armory_button_widget
--
--    mod:hook_disable(UISceneGraph, "init_scenegraph")
--
--    return result
--end)
--
--mod:hook(UISceneGraph, "init_scenegraph", function (orig_func, scenegraph)
--    scenegraph.armory_button = {
--        vertical_alignment = "bottom",
--        horizontal_alignment = "left",
--        parent = "window",
--        size = { 380, 42 },
--        position = { 150, -16, 10 }
--    }
--
--    return orig_func(scenegraph)
--end)
--mod:hook_disable(UISceneGraph, "init_scenegraph")
