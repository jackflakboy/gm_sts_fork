include("shared.lua")

local function BuildArcPoly(radius, startAngle, endAngle, segments)
    local poly = {}
    table.insert(poly, { x = 0, y = 0 })

    for i = 0, segments do
        local frac = i / segments
        local ang = math.rad(Lerp(frac, startAngle, endAngle))
        local x = math.cos(ang) * radius
        local y = math.sin(ang) * radius
        table.insert(poly, { x = x, y = y })
    end
    return poly
end

function ENT:Draw()
    local parent = self:GetParent()
    if not IsValid(parent) then return end

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local maxHealth = owner:GetMaxHealth() or 100
    local currentHealth = owner:Health() or maxHealth
    local healthFrac = math.Clamp(currentHealth / maxHealth, 0, 1)

    local pos = parent:GetPos() + Vector(0, 0, 2)

    local ang = Angle(90, 0, 0)

    local colorVec = self:GetCircleColor()
    local drawColor = Color(
        colorVec.x * 255,
        colorVec.y * 255,
        colorVec.z * 255,
        150  -- translucent
    )

    cam.Start3D2D(pos, ang, 0.1)
        surface.SetDrawColor(drawColor)
        draw.NoTexture()

        local radius = self:GetCircleRadius()
        local startAngle = 0
        local endAngle   = 360 * healthFrac
        local segments   = 64

        local wedge = BuildArcPoly(radius, startAngle, endAngle, segments)
        surface.DrawPoly(wedge)
    cam.End3D2D()
end
