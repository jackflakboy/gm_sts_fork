CreateConVar("sts_game_started", "0", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "INTERNAL - Changing this value will cause bugs!!!", 0, 1)

CreateConVar("sts_starting_points", "20", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Starting points, no effect after game start.", 1, 80)

CreateConVar("sts_total_rounds", "5", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Amount of rounds to play. No effect after game start.", 1, 24)

CreateConVar("sts_minimum_players", "1", {FCVAR_GAMEDLL}, "Minimum players required before game can start.")

CreateConVar("sts_allow_playermodel_variation", "0", {FCVAR_GAMEDLL}, "Whether or not players should be able to change their playermodels or not.", 0, 1)

CreateConVar("sts_forbid_dev_room", "1", {FCVAR_GAMEDLL}, "Whether or not to forbid access to the secret dev room.", 0, 1)

CreateConVar("sts_disable_settings_buttons", "0", {FCVAR_GAMEDLL}, "Whether or not the lobby buttons should do anything.", 0, 1)

CreateConVar("sts_episodic_mobs", "1", {FCVAR_GAMEDLL}, "Whether or not to add episodic mobs to the mob pool. No effect after game start.", 0, 1)

CreateConVar("sts_force_bonus_rounds", "-1", {FCVAR_GAMEDLL}, "1 - Force bonus rounds on\n0 - Force bonus rounds off\n-1 - Force nothing.", -1, 1)

CreateConVar("sts_random_teams", "0", {FCVAR_GAMEDLL}, "0 - Allow players to choose teams\n1 - Random two teams\n2 - Random Four teams\n3 - Random\nIf this is set to anything besides 0, the team selection will be locked. No effect after game start.", 0, 3)

CreateConVar("sts_classic", "0", {FCVAR_GAMEDLL}, "0 - Use new soundtrack and announcer\n1 - Use old soundtrack and announcer (not royalty free)")

CreateConVar("sts_allow_team_swapping", "0", {FCVAR_GAMEDLL}, "0 - Do not allow swapping teams midgame\n 1 - Allow swapping teams mid game")

RunConsoleCommand("sv_gravity", "600") -- reset gravity
RunConsoleCommand("sk_combine_s_kick", "6") -- change combine melee damage
RunConsoleCommand("sbox_noclip", "1") -- disable ability to noclip
RunConsoleCommand("sv_noclipspeed", "50")
RunConsoleCommand("sk_citizen_heal_player_min_pct", "100")
RunConsoleCommand("sk_citizen_heal_player_min_forced", "1")
RunConsoleCommand("sk_citizen_heal_ally", "40")
RunConsoleCommand("sk_citizen_heal_ally_delay", "0.5") -- this might've not been set correctly prior and may cause a buff to medics



function GM:PlayerSpawnProp(ply, model)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnEffect(ply, model)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnNPC(ply, npc_type, weapon)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnObject(ply, model, skin)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnRagdoll(ply, model)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnSENT(ply, class)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnSWEP(ply, weapon, swep)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end

function GM:PlayerSpawnVehicle(ply, model, name, table)
    if ply:GetNWInt("stsgod") == 1 then
        return true
    else
        return false
    end
end