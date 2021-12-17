local mod = get_mod("vermitannica")

local vermitannica_settings = VermitannicaSettings
local view_settings = vermitannica_settings.view_settings
local view_name = view_settings.view_name
local open_transition = view_settings.view_open_transition
local close_transition = view_settings.view_close_transition

local function chat_is_focused()
    return Managers.chat and Managers.chat:chat_is_focused()
end

VermitannicaViewManager = class(VermitannicaViewManager)
VermitannicaViewManager.NAME = "VermitannicaViewManager"

function VermitannicaViewManager:init(ingame_ui_context)
    self.ingame_ui_context = ingame_ui_context
    self._view_states = {}
end

function VermitannicaViewManager:_verify_view_state_data(view_state_data)
    local errors = {}

    local name = view_state_data.name
    local display_name = view_state_data.display_name
    local state_name = view_state_data.state_name

    if not name then
        table.insert(errors, "Missing [name]")
    elseif self._view_states[name] then
        table.insert(errors, string.format("State [\"%s\"] has already been registered", name))
    end

    if not display_name then
        table.insert(errors, "Missing [display_name]")
    end

    if not state_name then
        table.insert(errors, "Missing [state_name]")
    elseif not rawget(_G, state_name) then
        table.insert(errors, string.format("State [\"%s\"] has not been defined", state_name))
    end

    return #errors == 0, errors
end

function VermitannicaViewManager:_create_transition_functions(view_state_data)

    local view_state_name = view_state_data.name
    local state_name = view_state_data.state_name

    local function open()
        if chat_is_focused() then
            return
        end

        mod:handle_transition(open_transition, false, true, {
            menu_state_name = view_state_name
        })
    end

    local function close()
        if chat_is_focused() then
            return
        end

        mod:handle_transition(close_transition, false, true)
    end

    local function toggle()
        local ingame_ui_context = mod.ingame_ui_context
        if not ingame_ui_context or not mod.ingame_ui_context.is_in_inn then
            return
        end

        if chat_is_focused() then
            return
        end

        local ingame_ui = ingame_ui_context.ingame_ui
        if view_name == ingame_ui.current_view then

            local view = ingame_ui.views[view_name]
            if state_name == view:current_state().NAME then
                close()
            else
                view:request_screen_change_by_name(view_state_name)
            end

        elseif ingame_ui.current_view then
            open()
        else
            open()
        end
    end

    return {
        open = open,
        close = close,
        toggle = toggle
    }

end

function VermitannicaViewManager:register_view_state(view_state_data)
    local success, errors = self:_verify_view_state_data(view_state_data)
    if success then
        local transitions = self:_create_transition_functions(view_state_data)
        view_state_data.transitions = transitions
        table.insert(self._view_states, view_state_data)

        return transitions
    else
        mod:error("Malformed view_state_data:")
        for i, error in ipairs(errors) do
            mod:echo("(%s) %s", i, error)
        end
    end
end

function VermitannicaViewManager:unregister_view_state(view_state_name)
    local view_states = self._view_states
    for index, view_state_data in ipairs(view_states) do
        if view_state_name == view_state_data.name then
            table.remove(view_states, index)

            return
        end
    end

    mod:debug("No such state with name [\"%s\"] has been registered", view_state_name)
end

function VermitannicaViewManager:view_state(view_state_name)
    local view_states = self._view_states
    for _, view_state_data in ipairs(view_states) do
        if view_state_name == view_state_data.name then
            return view_state_data
        end
    end

    mod:debug("No such state with name [\"%s\"] has been registered", view_state_name)
end

function VermitannicaViewManager:view_states()
    return self._view_states
end

function VermitannicaViewManager:state_transition_by_name(view_state_name, transition_name)
    local view_states = self._view_states
    for index, view_state_data in ipairs(view_states) do
        if view_state_name == view_state_data.name then
            local transition_func = view_state_data.transitions[transition_name]

            if transition_func then
                transition_func()
            else
                mod:debug("No such transition with name [\"%s\"]", transition_name)
            end
        end
    end
end