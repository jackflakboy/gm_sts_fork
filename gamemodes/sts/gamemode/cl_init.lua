include("shared.lua")
include("testhud.lua")
include("custommenu.lua")
include("net.lua")
include("cubes.lua")
include("mobs.lua")
local client = LocalPlayer()
points = 0
startingPoints = 20
startingRounds = 5
gameStarted = false
CreateClientConVar("sts_use_descriptions", "1", true, true, "Enables mob descriptions", 0, 1)

surface.CreateFont("timefont", {
    font = "Default", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 60,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

function GM:SpawnMenuOpen()
    if client:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:OnContextMenuOpen()
    if client:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

boxMob = ""
boxName = ""
boxRarity = 0
boxStrength = 0
boxLevel = 0

hook.Add("PlayerSpawnProp", "RestrictSpawningProps", function(ply)
    return false
end)