AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Team Indicator"
ENT.Author = "me"
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "CircleRadius", {
        KeyName = "circleradius",
        Edit = {
            type = "Float",
            order = 1,
            min = 1,
            max = 200
        }
    })

    self:NetworkVar("Vector", 0, "CircleColor")
end
