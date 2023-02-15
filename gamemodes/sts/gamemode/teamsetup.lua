local ply = FindMetaTable("Player")
local teams = {}
local models = {"models/player/group01/female_01.mdl", "models/player/group01/female_02.mdl", "models/player/group01/female_03.mdl", "models/player/group01/female_04.mdl", "models/player/group01/female_05.mdl", "models/player/group01/female_06.mdl", "models/player/group01/male_01.mdl", "models/player/group01/male_02.mdl", "models/player/group01/male_03.mdl", "models/player/group01/male_04.mdl", "models/player/group01/male_05.mdl", "models/player/group01/male_06.mdl", "models/player/group01/male_07.mdl", "models/player/group01/male_08.mdl", "models/player/group01/male_09.mdl", "models/player/group02/male_02.mdl", "models/player/group02/male_04.mdl", "models/player/group02/male_06.mdl", "models/player/group02/male_08.mdl", "models/player/group03/female_01.mdl", "models/player/group03/female_02.mdl", "models/player/group03/female_03.mdl", "models/player/group03/female_04.mdl", "models/player/group03/female_05.mdl", "models/player/group03/female_06.mdl", "models/player/group03/male_01.mdl", "models/player/group03/male_02.mdl", "models/player/group03/male_03.mdl", "models/player/group03/male_04.mdl", "models/player/group03/male_05.mdl", "models/player/group03/male_06.mdl", "models/player/group03/male_07.mdl", "models/player/group03/male_08.mdl", "models/player/group03/male_09.mdl", "models/player/group03m/female_01.mdl", "models/player/group03m/female_02.mdl", "models/player/group03m/female_03.mdl", "models/player/group03m/female_04.mdl", "models/player/group03m/female_05.mdl", "models/player/group03m/female_06.mdl", "models/player/group03m/male_01.mdl", "models/player/group03m/male_02.mdl", "models/player/group03m/male_03.mdl", "models/player/group03m/male_04.mdl", "models/player/group03m/male_05.mdl", "models/player/group03m/male_06.mdl", "models/player/group03m/male_07.mdl", "models/player/group03m/male_08.mdl", "models/player/group03m/male_09.mdl"}

teams[1] = {
    name = "Blue",
    color = Vector(0.2, 0.2, 1.0)
}

teams[2] = {
    name = "Red",
    color = Vector(1.0, 0, 0)
}

teams[3] = {
    name = "Green",
    color = Vector(0.0, 1.0, 0.0)
}

teams[4] = {
    name = "Yellow",
    color = Vector(1.0, 1.0, 0.0)
}

teams[0] = {
    name = "Empty",
    color = Vector(1.0, 1.0, 1.0)
}

function ply:SetupTeam(n)
    if not teams[n] then return end
    self:SetTeam(n)
    self:SetPlayerColor(teams[n].color)
    self:SetModel(models[math.random(#models)])
end