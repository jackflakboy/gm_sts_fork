function survivalstart()
    for k, u in ipairs(ents.GetAll()) do
        if u:GetName() == "timer_vars" then
            survtime = u:GetInternalVariable("Case15") -- stored in hammer?
        end
    end

    timerset(tonumber(survtime))
    timon(1)

    for i, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("timer", tonumber(survtime))
        ply:SetNWInt("survive", 1)
    end
end

function survivalcheck()
    for i, ply in ipairs(player.GetAll()) do
        if ply:GetNWInt("survive") == 1 then
            survpointadd(ply:Team())
            ply:SetNWInt("survive", 0)
        end
    end
end

function timeset(y, x)
    for k, u in ipairs(ents.GetAll()) do
        if u:GetName() == "timer_vars" then
            u:SetKeyValue("Case1" .. tostring(4 + y), tostring(x))
        end
    end
end

function deathstart()
    for k, u in ipairs(ents.GetAll()) do
        if u:GetName() == "timer_vars" then
            deathtime = u:GetInternalVariable("Case16")
        end
    end

    timerset(tonumber(deathtime))
    timon(1)
    deathmatch(1)
end

-- ???
function timon(x)
    for i, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("timon", x)
    end
end

function timerset(x)
    for i, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("timer", x)
    end
end

function timersub(x)
    for i, ply in ipairs(player.GetAll()) do
        if ply:GetNWInt("timer") == 1 then
            timend()
            break
        end

        ply:SetNWInt("timer", ply:GetNWInt("timer") - x)
    end
end

function timend()
    timon(0)

    for k, u in ipairs(ents.GetAll()) do
        if u:GetName() == "bonusround_deathmatch_end" then
            u:Fire("Trigger")
        end

        if u:GetName() == "bonusround_survival_end" then
            u:Fire("Trigger")
        end
    end
end

--DEATHMATCH	
function deathmatch(x)
    for i, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("combat", x)
    end
end

function deathmatchkill(victim, inflictor, attacker)
    victim:SetNWInt("survive", 0)

    if attacker == victim then
        print("Quit killing yourself")
    elseif attacker:GetNWInt("combat") == 1 then
        print("player died in combat")
        local teamnum = attacker:Team()

        if teamnum == victim:Team() then
            print("Quit Team Killing")
        else
            for i, ply in ipairs(player.GetAll()) do
                if teamnum == 1 then
                    ply:PrintMessage(HUD_PRINTTALK, ".\n\n\n\n\n\n\n\n\n\nBlue Team Gained a Point!\n\n\n\n")
                end

                if teamnum == 2 then
                    ply:PrintMessage(HUD_PRINTTALK, ".\n\n\n\n\n\n\n\n\n\nRed Team Gained a Point!\n\n\n\n")
                end

                if teamnum == 3 then
                    ply:PrintMessage(HUD_PRINTTALK, ".\n\n\n\n\n\n\n\n\n\nGreen Team Gained a Point!\n\n\n\n")
                end

                if teamnum == 4 then
                    ply:PrintMessage(HUD_PRINTTALK, ".\n\n\n\n\n\n\n\n\n\nYellow Team Gained a Point!\n\n\n\n")
                end

                if ply:Team() == teamnum then
                    ply:SetNWInt("researchPoints", ply:GetNWInt("researchPoints") + ply:GetNWInt("dmpnt"))
                end
            end
        end
    end
end

hook.Add("PlayerDeath", "Deathmatch Add Points", deathmatchkill)