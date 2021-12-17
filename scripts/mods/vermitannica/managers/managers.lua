local mod = get_mod("vermitannica")

mod:dofile("scripts/mods/vermitannica/managers/vermitannica_view_manager")
mod:dofile("scripts/mods/vermitannica/managers/vermitannica_equipment_manager")

VermitannicaManagers = {
    view = VermitannicaViewManager:new()
}