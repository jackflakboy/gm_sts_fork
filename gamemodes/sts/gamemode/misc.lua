CreateConVar("sts_game_started", "0", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "INTERNAL - Changing this value will cause bugs!!!", 0, 1)

CreateConVar("sts_starting_points", "20", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Starting points, no effect after game start.", 1, 80)

CreateConVar("sts_total_rounds", "5", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Amount of rounds to play. No effect after game start.", 1, 24)

CreateConVar("sts_minimum_players", "1", {FCVAR_GAMEDLL}, "Minimum players required before game can start.")

CreateConVar("sts_outfitter_support", "0", {FCVAR_GAMEDLL}, "Change how team recognition is handled if using outfitter.", 0, 1)

CreateConVar("sts_forbid_dev_room", "1", {FCVAR_GAMEDLL}, "Whether or not to forbid access to the secret dev room.", 0, 1)

CreateConVar("sts_disable_settings_buttons", "0", {FCVAR_GAMEDLL}, "Whether or not the lobby buttons should do anything.", 0, 1)

CreateConVar("sts_episodic_mobs", "1", {FCVAR_GAMEDLL}, "Whether or not to add episodic mobs to the mob pool. No effect after game start.", 0, 1)

CreateConVar("sts_force_bonus_rounds", "-1", {FCVAR_GAMEDLL}, "1 - Force bonus rounds on\n0 - Force bonus rounds off\n-1 - Force nothing.", -1, 1)

CreateConVar("sts_random_teams", "0", {FCVAR_GAMEDLL}, "0 - Allow players to choose teams\n1 - Random two teams\n2 - Random Four teams\n3 - Random\nIf this is set to anything besides 0, the team selection will be locked. No effect after game start.", 0, 3)

CreateConVar("sts_classic", "0", {FCVAR_GAMEDLL}, "0 - Use new soundtrack and announcer\n1 - Use old soundtrack and announcer (not royalty free)", 0, 1)

CreateConVar("sts_allow_team_swapping", "0", {FCVAR_GAMEDLL}, "0 - Do not allow swapping teams midgame\n 1 - Allow swapping teams mid game", 0, 1)

CreateConVar("sts_deathmatch_points", "1", {FCVAR_GAMEDLL}, "Determine point reward for kills in bonus rounds.")

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

mapSpawners = {
    ["square"] = {
        ["blue"] = {"square_blue_1", "square_blue_2", "square_blue_3", "square_blue_4", "square_blue_5"},
        ["red"] = {"square_red_1", "square_red_2", "square_red_3", "square_red_4", "square_red_5"},
        ["green"] = {"square_green_1", "square_green_2", "square_green_3", "square_green_4", "square_green_5"},
        ["yellow"] = {"square_yellow_1", "square_yellow_2", "square_yellow_3", "square_yellow_4", "square_yellow_5"}
    },
    ["cit"] = {
        ["blue"] = {"cit_blue_1", "cit_blue_2", "cit_blue_3", "cit_blue_4", "cit_blue_5"},
        ["red"] = {"cit_red_1", "cit_red_2", "cit_red_3", "cit_red_4", "cit_red_5"},
        ["green"] = {"cit_green_1", "cit_green_2", "cit_green_3", "cit_green_4", "cit_green_5"},
        ["yellow"] = {"cit_yellow_1", "cit_yellow_2", "cit_yellow_3", "cit_yellow_4", "cit_yellow_5"}
    },
    ["rav"] = {
        ["blue"] = {"rav_blue_1", "rav_blue_2", "rav_blue_3", "rav_blue_4", "rav_blue_5"},
        ["red"] = {"rav_red_1", "rav_red_2", "rav_red_3", "rav_red_4", "rav_red_5"},
        ["green"] = {"rav_green_1", "rav_green_2", "rav_green_3", "rav_green_4", "rav_green_5"},
        ["yellow"] = {"rav_yellow_1", "rav_yellow_2", "rav_yellow_3", "rav_yellow_4", "rav_yellow_5"}
    },
    ["rail"] = {
        ["blue"] = {"rail_blue_1", "rail_blue_2", "rail_blue_3", "rail_blue_4", "rail_blue_5"},
        ["red"] = {"rail_red_1", "rail_red_2", "rail_red_3", "rail_red_4", "rail_red_5"},
        ["green"] = {"rail_green_1", "rail_green_2", "rail_green_3", "rail_green_4", "rail_green_5"},
        ["yellow"] = {"rail_yellow_1", "rail_yellow_2", "rail_yellow_3", "rail_yellow_4", "rail_yellow_5"}
    },
    ["lake"] = {
        ["blue"] = {"lake_blue_1", "lake_blue_2", "lake_blue_3", "lake_blue_4", "lake_blue_5"},
        ["red"] = {"lake_red_1", "lake_red_2", "lake_red_3", "lake_red_4", "lake_red_5"},
        ["green"] = {"lake_green_1", "lake_green_2", "lake_green_3", "lake_green_4", "lake_green_5"},
        ["yellow"] = {"lake_yellow_1", "lake_yellow_2", "lake_yellow_3", "lake_yellow_4", "lake_yellow_5"}
    },
    ["yellow"] = {
        ["blue"] = {"yellow_blue_1", "yellow_blue_2", "yellow_blue_3", "yellow_blue_4", "yellow_blue_5"},
        ["red"] = {"yellow_red_1", "yellow_red_2", "yellow_red_3", "yellow_red_4", "yellow_red_5"},
        ["green"] = {"yellow_green_1", "yellow_green_2", "yellow_green_3", "yellow_green_4", "yellow_green_5"},
        ["yellow"] = {"yellow_yellow_1", "yellow_yellow_2", "yellow_yellow_3", "yellow_yellow_4", "yellow_yellow_5"}
    },
    ["green"] = {
        ["blue"] = {"green_blue_1", "green_blue_2", "green_blue_3", "green_blue_4", "green_blue_5"},
        ["red"] = {"green_red_1", "green_red_2", "green_red_3", "green_red_4", "green_red_5"},
        ["green"] = {"green_green_1", "green_green_2", "green_green_3", "green_green_4", "green_green_5"},
        ["yellow"] = {"green_yellow_1", "green_yellow_2", "green_yellow_3", "green_yellow_4", "green_yellow_5"}
    },
    ["blue"] = {
        ["blue"] = {"blue_blue_1", "blue_blue_2", "blue_blue_3", "blue_blue_4", "blue_blue_5"},
        ["red"] = {"blue_red_1", "blue_red_2", "blue_red_3", "blue_red_4", "blue_red_5"},
        ["green"] = {"blue_green_1", "blue_green_2", "blue_green_3", "blue_green_4", "blue_green_5"},
        ["yellow"] = {"blue_yellow_1", "blue_yellow_2", "blue_yellow_3", "blue_yellow_4", "blue_yellow_5"}
    }
}