local mobPrefixes = {"blue_", "red_", "green_", "yellow_"}
local mobSuffix = "_template"
mobs = {}
-- Define the Mob object
Mob = {}
Mob.__index = Mob
-- Constructor for the Mob
function Mob.new(name, templates, multiplier, delay, amount)
    -- This is the table we will return
    local EmptyMob = {
        name = name or "",
        templates = templates or {},
        multiplier = multiplier or 1,
        delay = delay or 1,
        amount = amount or 1
    }

    setmetatable( EmptyMob, Mob ) -- Set the metatable of 'EmptyMob' to 'Mob'
    return EmptyMob -- Return the 'EmptyMob' table, whose metatable is 'Mob'. This is our object
end

-- Dummy spawn function for the Mob
function Mob:spawn(teamID)
    PrintMessage(HUD_PRINTTALK, "Spawning " .. self.name .. " with a multiplier of " .. self.multiplier)
    for _, ent in ipairs(ents.GetAll()) do
        for _, template in ipairs(self.templates) do
            if ent:GetName() == mobPrefixes[teamID] .. template .. mobSuffix then
                ent:Fire("ForceSpawn")
            end
        end
    end
end


mobs[1] = {
    ["headcrab"] = Mob.new("Headcrab", {"npc_headcrab"}, 1),
    ["blackheadcrab"] = Mob.new("Black Headcrab", {"npc_blackheadcrab"}, 1),
    ["fastheadcrab"] = Mob.new("Fast Headcrab", {"npc_fastheadcrab"}, 1),
    ["manhack"] = Mob.new("Manhack", {"npc_manhack"}, 1),
    ["crowbar"] = Mob.new("Crowbar Guy", {"npc_crowbar"}, 1),
    ["fasttorso"] = Mob.new("Fast Torso", {"npc_fasttorso"}, 1), -- TODO: episodic
    ["stun"] = Mob.new("Stop Resisting", {"npc_stun"}, 1),
    ["torso"] = Mob.new("Zombie Torso", {"npc_torso"}, 1)
}

mobs[2] = {
    ["medic"] = Mob.new("Medic", {"npc_medic"}, 1),
    ["shotgun"] = Mob.new("Shotgun", {"npc_shotgun"}, 1),
    ["combinesmg"] = Mob.new("SMG", {"npc_combinesmg"}, 1),
    ["cop"] = Mob.new("Metrocop", {"npc_cop"}, 1),
    ["zombie"] = Mob.new("Zombie", {"npc_zombie"}, 1),
    ["antlion"] = Mob.new("Antlion", {"npc_antlion"}, 1),
    ["triplefastheadcrab"] = Mob.new("Fast Headcrab (x3)", {"npc_fastheadcrab"}, 3),
    ["doublestun"] = Mob.new("Stop Resisting (x2)", {"npc_stun"}, 2),
    ["triplemanhack"] = Mob.new("Manhack (x3)", {"npc_manhack"}, 3)
}

mobs[3] = {
    ["rocket"] = Mob.new("Rocketeer", {"npc_rocket"}, 1),
    ["barney"] = Mob.new("Barney", {"npc_barney"}, 1),
    ["vort"] = Mob.new("Vortigaunt", {"npc_vort"}, 1),
    ["monk"] = Mob.new("Monk", {"npc_monk"}, 1),
    ["suicide"] = Mob.new("Suicide", {"npc_suicide"}, 1),
    ["brute"] = Mob.new("Brute", {"npc_brute"}, 1), -- TODO: episodic
    ["healer"] = Mob.new("Healer", {"npc_healer"}, 1),
    ["doublezombie"] = Mob.new("Zombie (x2)", {"npc_zombie"}, 1),
    ["beefcake"] = Mob.new("Beefcake", {"npc_beefcake"}, 1)
}

mobs[4] = {
    ["doublerocket"] = Mob.new("Rocketeer (x2)", {"npc_rocket"}, 2),
    ["quinzombie"] = Mob.new("Zombie (x5)", {"npc_zombie"}, 5),
    ["antguard"] = Mob.new("Antlion Guard", {"npc_antguard"}, 1),
    ["valkyrie"] = Mob.new("Valkyrie", {"npc_valkyrie"}, 1),
    ["antlion"] = Mob.new("Antlion (x5)", {"npc_antlion"}, 5),
    ["healer"] = Mob.new("Healer (x3)", {"npc_healer"}, 3),
    ["bombsquad"] = Mob.new("Bombing Squad", {"npc_bombsquad"}, 5),
    ["elitesquad"] = Mob.new("Elite Squad", {"npc_elitesquad_ar", "npc_elitesquad_shotgun"}, 1, 1, 2)
}