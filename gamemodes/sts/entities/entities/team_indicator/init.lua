AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    -- Dummy model
    self:SetModel("models/props_junk/PopCan01a.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)
    self:SetNoDraw(false)
    self:SetPos(Vector(0, 0, 0))
end

function ENT:AttachToEntity(parentEnt)
    if not IsValid(parentEnt) then return end
    self:SetParent(parentEnt)
    self:SetPos(parentEnt:GetPos())
    self:SetOwner(parentEnt)
end
