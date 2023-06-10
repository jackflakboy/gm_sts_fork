include("descriptions.lua")
AddCSLuaFile("descriptions.lua")

function HUD()
    local client = LocalPlayer()
    descrip = client:GetNWInt("desc")
    if client:Alive() == false then return end
    draw.RoundedBox(5, 0, ScrH() - 140, 250, 240, Color(20, 20, 20, 225))
    --Health
    draw.SimpleText("Health: " .. client:Health() .. "%", "DermaDefaultBold", 10, ScrH() - 65, Color(255, 255, 255, 255), 0, 0)
    draw.RoundedBox(3, 10, ScrH() - 50, 100 * 2.25, 15, Color(250, 0, 0, 30))
    draw.RoundedBox(3, 10, ScrH() - 50, math.Clamp(client:Health(), 0, 100) * 2.25, 15, Color(255, 0, 0, 255))
    draw.RoundedBox(3, 10, ScrH() - 50, math.Clamp(client:Health(), 0, 100) * 2.25, 4, Color(255, 50, 50, 255))

    --Beginning
    if client:GetNWInt("beginon") == 1 then
        local sp = tostring(client:GetNWInt("strtpnt"))
        local ro = tostring(client:GetNWInt("strtround"))
        draw.RoundedBox(5, ScrW() / 2 - 225, 75, 450, 60, Color(10, 10, 10, 230))
        draw.SimpleText("Starting Points: " .. sp, "CloseCaption_Bold", ScrW() / 2, 90, Color(255, 255, 255, 255), 0, 0)
        draw.SimpleText("Rounds: " .. ro, "CloseCaption_Bold", ScrW() / 2 - 180, 90, Color(255, 255, 255, 255), 0, 0)
    end

    --Timer
    if client:GetNWInt("timon") == 1 then
        local timy = client:GetNWInt("timer")
        draw.RoundedBox(5, ScrW() / 2 - 80, 75, 150, 60, Color(10, 10, 10, 230))

        if timy > 60 then
            if timy < 70 then
                draw.SimpleText("1:0" .. (tonumber(timy) - 60), "timefont", ScrW() / 2 - 50, 73, Color(255, 255, 255, 255), 0, 0)
            else
                draw.SimpleText("1:" .. (tonumber(timy) - 60), "timefont", ScrW() / 2 - 50, 73, Color(255, 255, 255, 255), 0, 0)
            end
        elseif timy < 60 then
            if timy < 10 then
                draw.SimpleText("0:0" .. timy, "timefont", ScrW() / 2 - 50, 73, Color(255, 255, 255, 255), 0, 0)
            else
                draw.SimpleText("0:" .. timy, "timefont", ScrW() / 2 - 50, 73, Color(255, 255, 255, 255), 0, 0)
            end
        elseif timy == 60 then
            draw.SimpleText("1:00", "timefont", ScrW() / 2 - 50, 73, Color(255, 255, 255, 255), 0, 0)
        end
    end

    --Research/Score/Team
    --Research
    draw.RoundedBox(25, ScrW() - 350, ScrH() - (250 + 250 * descrip), 350, 250 + 250 * descrip, Color(20, 20, 20, 230))
    draw.SimpleText("Research Points:  " .. client:GetNWInt("researchPoints"), "ChatFont", ScrW() - 330, (3.90 * ScrH() / 5) - 250 * descrip, Color(255, 255, 255, 255), 0, 0)
    draw.SimpleText("Mob Info: ", "ChatFont", ScrW() - 330, (3.2 * ScrH() / 4) - 250 * descrip, Color(255, 255, 255, 255), 0, 0)

    --Mobstuff
    if client:GetNWInt("pickup") ~= 0 then
        draw.SimpleText(" Tech Level:   " .. client:GetNWInt("pick_tech"), "ChatFont", ScrW() - 300, (2.913 * ScrH() / 5) + 275 - 250 * descrip, Color(255, 255, 255, 255, 255), 0, 0)
        draw.SimpleText("  Mob Type:   " .. client:GetNWInt("pick_type"), "ChatFont", ScrW() - 300, (2.913 * ScrH() / 5) + 305 - 250 * descrip, Color(255, 255, 255, 255, 255), 0, 0)
        draw.SimpleText("        Rarity:   " .. client:GetNWInt("pick_rar"), "ChatFont", ScrW() - 300, (2.913 * ScrH() / 5) + 335 - 250 * descrip, Color(255, 255, 255, 255, 255), 0, 0)
        draw.SimpleText("    Strength:   " .. client:GetNWInt("pick_str"), "ChatFont", ScrW() - 300, (2.913 * ScrH() / 5) + 365 - 250 * descrip, Color(255, 255, 255, 255, 255), 0, 0)
        local mobd = client:GetNWInt("pick_type")

        if descrip == 1 then
            for i = 1, 15 do
                draw.SimpleText(GetGlobalString(mobd .. "_" .. i), "ChatFont", ScrW() - 330, (2.913 * ScrH() / 5) + 155 + 20 * i, Color(255, 255, 255, 255, 255), 0, 0)
            end
        end
    end

    --Score
    draw.RoundedBox(5, ScrW() / 2 - 400, 5, 800, 56, Color(10, 10, 10, 250))
    draw.SimpleText("Blue ", "CloseCaption_Bold", ScrW() / 2 - 370, 20, Color(0, 80, 255, 255), 0, 0)
    draw.SimpleText(team.GetScore(1), "CloseCaption_Bold", ScrW() / 2 - 300, 20, Color(255, 255, 255, 255), 0, 0)
    draw.SimpleText("Red ", "CloseCaption_Bold", ScrW() / 2 - 170, 20, Color(255, 50, 0, 255), 0, 0)
    draw.SimpleText(team.GetScore(2), "CloseCaption_Bold", ScrW() / 2 - 105, 20, Color(255, 255, 255, 255), 0, 0)
    draw.SimpleText("Green ", "CloseCaption_Bold", ScrW() / 2 + 30, 20, Color(0, 255, 0, 255), 0, 0)
    draw.SimpleText(team.GetScore(3), "CloseCaption_Bold", ScrW() / 2 + 120, 20, Color(255, 255, 255, 255), 0, 0)
    draw.SimpleText("Yellow ", "CloseCaption_Bold", ScrW() / 2 + 230, 20, Color(255, 255, 0, 255), 0, 0)
    draw.SimpleText(team.GetScore(4), "CloseCaption_Bold", ScrW() / 2 + 330, 20, Color(255, 255, 255, 255), 0, 0)

    --Team
    if client:Team() == 1 then
        draw.RoundedBox(5, 5, ScrH() - 130, 140, 50, Color(10, 10, 10, 100))
        draw.SimpleText("Blue Team", "CloseCaption_Bold", 20, ScrH() - 120, Color(0, 80, 255, 255), 0, 0)
    elseif client:Team() == 2 then
        draw.RoundedBox(5, 5, ScrH() - 130, 135, 50, Color(10, 10, 10, 100))
        draw.SimpleText("Red Team", "CloseCaption_Bold", 20, ScrH() - 120, Color(255, 0, 0, 255), 0, 0)
    elseif client:Team() == 3 then
        draw.RoundedBox(5, 5, ScrH() - 130, 155, 50, Color(10, 10, 10, 100))
        draw.SimpleText("Green Team", "CloseCaption_Bold", 20, ScrH() - 120, Color(0, 255, 0, 255), 0, 0)
    elseif client:Team() == 4 then
        draw.RoundedBox(5, 5, ScrH() - 130, 165, 50, Color(10, 10, 10, 100))
        draw.SimpleText("Yellow Team", "CloseCaption_Bold", 20, ScrH() - 120, Color(255, 255, 0, 255), 0, 0)
    else
        draw.RoundedBox(5, 5, ScrH() - 130, 140, 50, Color(10, 10, 10, 100))
        draw.SimpleText("Pick Team", "CloseCaption_Bold", 20, ScrH() - 120, Color(130, 130, 130, 255), 0, 0)
    end
end

hook.Add("HUDPaint", "TestHud", HUD)

function HideHud(name)
    for _, element in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
        if name == element then return false end
    end
end

hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)