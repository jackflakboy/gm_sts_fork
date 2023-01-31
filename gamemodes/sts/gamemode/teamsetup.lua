local ply = FindMetaTable("Player")
local teams = {}

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
    self:SetModel("models/player/group03m/male_07.mdl")
end