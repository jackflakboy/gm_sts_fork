AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Bubble Shield"
ENT.Spawnable = true 



function ENT:Initialize()
    self:SetModel("models/props_phx/construct/metal_dome360.mdl")
    self:SetMaterial("models/props_combine/portalball001_sheet")
    self:SetColor(Color(0, 100, 255, 100))
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetModelScale(2.3, 0.001)
    --self:PhysicsInitBox(Vector(-100, -100, -100), Vector(100, 100, 100))

    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) -- So NPCs can walk through

    
    --self:SetCollisionBounds(Vector(-100, -100, -100), Vector(100, 100, 100))
end
--[[
function ENT:OnTakeDamage(dmginfo)
    local attacker = dmginfo:GetAttacker()

    if attacker:IsNPC() or attacker:IsPlayer() then
        if attacker.TeamID and attacker:TeamID() == self.Team then
            return -- Let team bullets pass through
        end
    end

    self:SetHealth(self:Health() - dmginfo:GetDamage())

    if self:Health() <= 0 then
        self:Remove()
    end
end
]]--

function ENT:SetTeamName(name)
    self:SetNWString("TeamName", name)
end

function ENT:GetTeamName()
    return self:GetNWString("TeamName")
end