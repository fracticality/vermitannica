local mod = get_mod("vermitannica")

local definitions = mod:dofile("scripts/mods/armory/armory_state_overview_definitions")
local scenegraph_definition = definitions.scenegraph_definition
local widget_definitions = definitions.widget_definitions
local widget_templates = definitions.widget_templates


ArmoryStateOverview = class(ArmoryStateOverview)
ArmoryStateOverview.NAME = "ArmoryStateOverview"

function ArmoryStateOverview:on_enter(params)

    mod:debug("[%s] (on_enter)", self.NAME)

    local ingame_ui_context = params.ingame_ui_context
    self.ui_top_renderer = ingame_ui_context.ui_top_renderer

    self.parent = params.parent

    self.settings_by_screen = params.settings_by_screen

    self.world_previewer = params.world_previewer

    self:create_ui_elements()

end

function ArmoryStateOverview:create_ui_elements()

    self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

    --self.test_statistic = UIWidget.init(widget_definitions.test_statistic)

    UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

end

function ArmoryStateOverview:update(dt, t)

    local wanted_state = self.parent:wanted_state()
    if wanted_state then
        self.parent:clear_wanted_state()

        return wanted_state
    end

    self:_handle_mouse_input()

    self:_draw(dt)

end

function ArmoryStateOverview:_handle_mouse_input()



end

function ArmoryStateOverview:_draw(dt)

    local ui_top_renderer = self.ui_top_renderer
    local ui_scenegraph = self.ui_scenegraph
    local input_service = self:input_service()

    UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, input_service, dt)

    UIRenderer.end_pass(ui_top_renderer)

end

function ArmoryStateOverview:on_exit()

    mod:debug("[%s] on_exit", self.NAME)

end

function ArmoryStateOverview:input_service()
    return self.parent:input_service()
end