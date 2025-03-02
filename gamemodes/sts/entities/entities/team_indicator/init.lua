-- This is init.lua for the 'team_indicator' entity
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate025x025.mdl")
    self:SetMaterial("models/debug/debugwhite")
    -- self:SetMaterial("decals/eye_model")
    -- local myMaterial = Material("decals/eye_model")
    -- -- Modify the texture scale
    -- myMaterial:SetString("$basetexturetransform", "center .5 .5 scale 0.5 0.5 rotate 0 translate 0 0")
    -- self:SetMaterial("!decals/eye_model")
    self:DrawShadow(false)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetRenderMode(RENDERMODE_GLOW)
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then phys:Wake() end
end
