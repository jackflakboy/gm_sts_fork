-- This is init.lua for the 'team_indicator' entity
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate025x025.mdl")
    self:SetMaterial("models/debug/debugwhite")
    self:DrawShadow(false)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) 
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end
