include("shared.lua")
local function SphereToCartesian(radius, phiDeg, thetaDeg)
    -- Convert spherical angles (in degrees) to Cartesian coordinates
    -- phi = 0 is top of sphere; phi = 90 is equator
    local phi = math.rad(phiDeg)
    local theta = math.rad(thetaDeg)
    local x = radius * math.sin(phi) * math.cos(theta)
    local y = radius * math.sin(phi) * math.sin(theta)
    local z = radius * math.cos(phi)
    return Vector(x, y, z)
end

-- Build a hemisphere (dome) from [phi=0..90] and [theta=0..360].
local function BuildDomeTriangles(radius, segmentsPhi, segmentsTheta)
    -- We build a table of triangles that Mesh:BuildFromTriangles() will use
    local triangles = {}
    local phiStep = 90 / segmentsPhi -- From top(0°) down to flat(90°)
    local thetaStep = 360 / segmentsTheta -- Full rotation around
    for phiSlice = 0, segmentsPhi - 1 do
        local phi1 = phiSlice * phiStep
        local phi2 = (phiSlice + 1) * phiStep
        for thetaSlice = 0, segmentsTheta - 1 do
            local theta1 = thetaSlice * thetaStep
            local theta2 = (thetaSlice + 1) * thetaStep
            -- The four corners of a "patch" on the sphere
            -- (phi1, theta1), (phi1, theta2), (phi2, theta1), (phi2, theta2).
            local p1 = SphereToCartesian(radius, phi1, theta1)
            local p2 = SphereToCartesian(radius, phi1, theta2)
            local p3 = SphereToCartesian(radius, phi2, theta1)
            local p4 = SphereToCartesian(radius, phi2, theta2)
            -- We form two triangles: (p1, p2, p3) and (p3, p2, p4).
            -- For each triangle, we create three "Vertex" structures:
            -- https://wiki.facepunch.com/gmod/Structures/MeshVertex
            table.insert(triangles, {
                pos = p1,
                normal = p1:GetNormalized(),
                u = 0,
                v = 0,
            })

            table.insert(triangles, {
                pos = p2,
                normal = p2:GetNormalized(),
                u = 1,
                v = 0,
            })

            table.insert(triangles, {
                pos = p3,
                normal = p3:GetNormalized(),
                u = 0,
                v = 1,
            })

            table.insert(triangles, {
                pos = p3,
                normal = p3:GetNormalized(),
                u = 0,
                v = 1,
            })

            table.insert(triangles, {
                pos = p2,
                normal = p2:GetNormalized(),
                u = 1,
                v = 0,
            })

            table.insert(triangles, {
                pos = p4,
                normal = p4:GetNormalized(),
                u = 1,
                v = 1,
            })
        end
    end
    return triangles
end

-- We keep our mesh in ENT.DomeMesh on the client
function ENT:Initialize()
    -- Build the dome mesh
    self.DomeMesh = Mesh()
    local radius = self:GetDomeRadius() or 30
    local triangles = BuildDomeTriangles(radius, 10, 24) -- 10 "stacks", 24 "slices"
    self.DomeMesh:BuildFromTriangles(triangles)
end

function ENT:OnRemove()
    if self.DomeMesh then
        self.DomeMesh:Destroy()
        self.DomeMesh = nil
    end
end

function ENT:Draw()
    -- Late joiners
    if not self.DomeMesh then self:Initialize() end
    -- Position the dome at the entity's feet. The flat part is on the floor.
    -- By default, the dome is centered at the origin (0,0,0). 
    -- So if we want the flat part to be exactly on the floor, we can shift it so
    -- that the "lowest" point is at Z=0. For a hemisphere of radius R, lowest point is R below the center.
    --
    -- One approach: put the entity's "origin" R units above the ground, so that the dome’s bottom touches the ground.
    local radius = self:GetDomeRadius()
    local domePos = self:GetPos() + Vector(0, 0, radius)
    local domeAng = self:GetAngles() -- or just Angle(0,0,0), if you want no rotation
    -- If you want it to face "straight up," you can zero out pitch/roll:
    domeAng.p = 0
    domeAng.r = 0
    -- For a translucent color, adjust alpha < 255
    local colorVec = self:GetDomeColor()
    local domeColor = Color(math.Clamp(colorVec.x * 255, 0, 255), math.Clamp(colorVec.y * 255, 0, 255), math.Clamp(colorVec.z * 255, 0, 255), 150)
    -- alpha for translucency
    -- Draw the mesh
    render.SetColorMaterial()
    render.SuppressEngineLighting(true)
    cam.Start3D2D(domePos, domeAng, 1)
    -- 3D2D won't draw a 3D mesh properly; we only use 3D2D for 2D surfaces.
    -- Instead, we exit 3D2D immediately; actual drawing is done in normal 3D.
    cam.End3D2D()
    -- We do normal 3D draw with render.SetColorMaterial()
    render.SetBlend(domeColor.a / 255) -- sets translucency
    render.SetColorModulation(domeColor.r / 255, domeColor.g / 255, domeColor.b / 255)
    -- Position ourselves with the standard "Entity transform"
    self:SetupBones()
    local mat = Matrix()
    mat:Translate(domePos)
    mat:Rotate(domeAng)
    -- If you want to scale the dome, do mat:Scale(Vector(1,1,1)) here
    render.PushFilterMag(TEXFILTER.LINEAR)
    render.PushFilterMin(TEXFILTER.LINEAR)
    cam.PushModelMatrix(mat)
    self.DomeMesh:Draw()
    cam.PopModelMatrix()
    render.SetBlend(1)
    render.SetColorModulation(1, 1, 1)
    render.SuppressEngineLighting(false)
    render.PopFilterMag()
    render.PopFilterMin()
end
