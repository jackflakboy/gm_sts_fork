function deathmatchKill(victim, inflictor, attacker)
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