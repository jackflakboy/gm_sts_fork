function survivalstart()
    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "timer_vars" then
            survtime = entity:GetInternalVariable("Case15") -- stored in hammer?
        end
    end

    timerset(tonumber(survtime))
    timon(1)

    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("timer", tonumber(survtime))
        ply:SetNWInt("survive", 1)
    end
end

function survivalcheck()
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetNWInt("survive") == 1 then
            awardSurvival(ply:Team())
            ply:SetNWInt("survive", 0)
        end
    end
end

function timeset(y, x)
    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "timer_vars" then
            entity:SetKeyValue("Case1" .. tostring(4 + y), tostring(x))
        end
    end
end

--DEATHMATCH	
function deathmatch(x)
    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("combat", x)
    end
end

function deathmatchKill(victim, inflictor, attacker)
    victim:SetNWInt("survive", 0)

    if attacker == victim then
        print("Quit killing yourself")
    elseif attacker:IsPlayer() then
        local teamnum = attacker:Team()

        if teamnum == victim:Team() then
            print("Quit Team Killing")
        else
            if teamnum == 1 then
                PrintMessage(HUD_PRINTTALK, "Blue Team Gained a Point!")
            elseif teamnum == 2 then
                PrintMessage(HUD_PRINTTALK, "Red Team Gained a Point!")
            elseif teamnum == 3 then
                PrintMessage(HUD_PRINTTALK, "Green Team Gained a Point!")
            elseif teamnum == 4 then
                PrintMessage(HUD_PRINTTALK, "Yellow Team Gained a Point!")
            end
            return teamnum
        end
    end
    return 0
end