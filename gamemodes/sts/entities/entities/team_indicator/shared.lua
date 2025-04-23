AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Team Indicator"
ENT.Author = "Austin"
ENT.Spawnable = false
ENT.AdminOnly = false
function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "DomeRadius")
    self:NetworkVar("Vector", 0, "DomeColor")
    if SERVER then
        self:SetDomeRadius(30)
        self:SetDomeColor(Vector(1, 0, 0))
    end
end
