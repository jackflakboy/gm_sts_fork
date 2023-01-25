include ("shared.lua")
include("testhud.lua")
include("custommenu.lua")

local client = LocalPlayer()

surface.CreateFont( "timefont", {
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
} )

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

