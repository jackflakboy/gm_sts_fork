AddCSLuaFile("bonusround.lua")
AddCSLuaFile("concommands.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("custommenu.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("testhud.lua")
AddCSLuaFile("cubes.lua")
include("bonusround.lua")
include("concommands.lua")
include("custommenu.lua")
include("shared.lua")
include("teamsetup.lua")
include("testhud.lua")
include("cubes.lua")
include("net.lua")
AddCSLuaFile("net.lua")
math.randomseed(os.time())
gameStarted = false

-- determines loadout. returning true means override default, this might be able to be used for minigames.
function GM:PlayerLoadout(ply)
    return true
end

-- TODO: check if currently in a bonus round, then give weapons
-- if bonus round
-- if bonus round == round with gun
-- give guns
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

RunConsoleCommand("sv_gravity", "600") -- reset gravity
RunConsoleCommand("sk_combine_s_kick", "6") -- change combine melee damage
RunConsoleCommand("sbox_noclip", "1") -- disable ability to noclip
RunConsoleCommand("sv_noclipspeed", "50")
RunConsoleCommand("sk_citizen_heal_player_min_pct", "100")
RunConsoleCommand("sk_citizen_heal_player_min_forced", "1")
RunConsoleCommand("sk_citizen_heal_ally", "40")
RunConsoleCommand("sk_citizen_heal_ally_delay", "0.5") -- this might've not been set correctly prior and may cause a buff to medics

CreateConVar("sts_random_teams", "0", {FCVAR_GAMEDLL}, "0 - Allow players to choose teams\n1 - Random two teams\n2 - Random Four teams\n 3 - Random\nIf this is set to anything besides 0, the team selection will be locked. No effect after game start.", 0, 3)

cvars.AddChangeCallback("sts_random_teams", function(convarName, valueOld, valueNew)
    print("TODO: Create team door and open and close it")
end)

CreateConVar("sts_episodic_mobs", "1", {FCVAR_GAMEDLL}, "Whether or not to add episodic mobs to the mob pool. No effect after game start.", 0, 1)

CreateConVar("sts_force_bonus_rounds", "-1", {FCVAR_GAMEDLL}, "1 - Force bonus rounds on\n0 - Force bonus rounds off\n-1 - Force nothing.")

cvars.AddChangeCallback("sts_force_bonus_rounds", function(convarName, valueOld, valueNew)
    print("TODO: Change lever and lock it")
end)

CreateConVar("sts_minimum_players", "2", {FCVAR_GAMEDLL}, "Minimum players required before game can start.")

CreateConVar("sts_allow_playermodel_variation", "0", {FCVAR_GAMEDLL}, "Whether or not players should be able to change their playermodels or not.", 0, 1)

CreateConVar("sts_forbid_dev_room", "0", {FCVAR_GAMEDLL}, "Whether or not to forbid access to the secret dev room.", 0, 1)

CreateConVar("sts_disable_settings_buttons", "0", {FCVAR_GAMEDLL}, "Whether or not the lobby buttons should do anything.", 0, 1)

cvars.AddChangeCallback("sts_disable_settings_buttons", function(convarName, valueOld, valueNew)
    if GetConVar("sts_game_started"):GetInt() == 1 then return end

    if valueNew == "1" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_lobby_ready_door" then
                ent:Fire("open")
            end
        end
    elseif valueNew == "0" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_lobby_ready_door" then
                ent:Fire("close")
            end
        end
    end
end)

CreateConVar("sts_game_started", "0", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Changing this value will cause bugs!!!", 0, 1)

CreateConVar("sts_starting_points", "20", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Starting points, no affect after game start.", 1, 80)

CreateConVar("sts_total_rounds", "5", {FCVAR_GAMEDLL, FCVAR_REPLICATED}, "Amount of rounds to play. No affect after game start.", 1, 24)

function getChosenBonusRounds()
    local lever
    local leverClass
    local leverState
    local bonusRoundDesired

    local bonusRounds = {"waiting_lobby_mapleverb_lake", "waiting_lobby_mapleverb_blue", "waiting_lobby_mapleverb_green", "waiting_lobby_mapleverb_boomstick", "waiting_lobby_mapleverb_ctf", "waiting_lobby_mapleverb_battery", "waiting_lobby_mapleverb_ravsurv", "waiting_lobby_mapleverb_rav", "waiting_lobby_mapleverb_cit", "waiting_lobby_mapleverb_square"}

    local selectedBonusRounds = {}

    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "waiting_lobby_brtoggle_lever" then
            lever = entity
        else
            for _, bonusRoundLever in ipairs(bonusRounds) do
                if entity:GetName() == bonusRoundLever then
                    if entity:GetClass() == "func_door" or entity:GetClass() == "func_door_rotating" then
                        bonusRoundDesired = entity:GetInternalVariable("m_toggle_state") == 0
                    elseif entity:GetClass() == "prop_door_rotating" then
                        bonusRoundDesired = entity:GetInternalVariable("m_eDoorState") ~= 0
                    else
                        bonusRoundDesired = false
                    end

                    if bonusRoundDesired == false then
                        table.insert(selectedBonusRounds, entity:GetName())
                    end
                end
            end
        end
    end

    -- https://wiki.facepunch.com/gmod/Entity:GetInternalVariable
    leverClass = lever:GetClass()

    if leverClass == "func_door" or leverClass == "func_door_rotating" then
        leverState = lever:GetInternalVariable("m_toggle_state") == 0
    elseif leverClass == "prop_door_rotating" then
        leverState = lever:GetInternalVariable("m_eDoorState") ~= 0
    else
        leverState = false
    end

    -- lever up means the door is closed (false) and bonus rounds should be on. 
    if leverState == false then
        return selectedBonusRounds
    else
        return {}
    end
end

function getChosenMaps()
    local mapDesired

    local maps = {"waiting_lobby_maplever_square", "waiting_lobby_maplever_cit", "waiting_lobby_maplever_rav", "waiting_lobby_maplever_rail", "waiting_lobby_maplever_lake", "waiting_lobby_maplever_yellow", "waiting_lobby_maplever_green", "waiting_lobby_maplever_blue"}

    local selectedMaps = {}

    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "waiting_lobby_brtoggle_lever" then
            lever = entity
        else
            for _, bonusRoundLever in ipairs(maps) do
                if entity:GetName() == bonusRoundLever then
                    if entity:GetClass() == "func_door" or entity:GetClass() == "func_door_rotating" then
                        mapDesired = entity:GetInternalVariable("m_toggle_state") == 0
                    elseif entity:GetClass() == "prop_door_rotating" then
                        mapDesired = entity:GetInternalVariable("m_eDoorState") ~= 0
                    else
                        mapDesired = false
                    end

                    if mapDesired == false then
                        table.insert(selectedMaps, entity:GetName())
                    end
                end
            end
        end
    end

    return selectedMaps
end

function GM:PlayerInitialSpawn(ply)
    ply:SetMaxHealth(100)
    ply:SetHealth(100)
    ply:SetRunSpeed(400)
    ply:SetPlayerColor(Vector(0.0, 0.0, 0.0))
    ply:SetNWInt("combat", 0)
    ply:SetNWInt("stsgod", 0)
    ply:ConCommand("set_team " .. 0)

    if GetConVar("sts_disable_settings_buttons"):GetInt() == 0 then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_lobby_ready_door" then
                ent:Fire("close")
            end
        end
    end
end

function GM:PlayerSpawn(ply)
    ply:SetModel("models/player/police.mdl")
    ply:SetupHands()
end

function GM:PlayerSetHandsModel(ply, ent)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)

    if info then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end
end

-- no E's allowed i guess
-- honest to god what does this do
function scrnprint(x)
    local intype = string.sub(x, 1, 2)
    local inamount = string.sub(x, -2, -1)

    if intype == "ro" then
        for _, ply in ipairs(player.GetAll()) do
            ply:SetNWInt("strtround", inamount)
        end
    end

    if intype == "sp" then
        for _, ply in ipairs(player.GetAll()) do
            ply:SetNWInt("strtpnt", inamount)
        end
    end
end

function spawnTeams()
    for _, ply in ipairs(player.GetAll()) do
        ply:Spawn()
    end
end

--PLAYER USING
-- happens when a player uses something
function GM:PlayerUse(ply, ent)
    if ent:GetName() == "waiting_blueteambutt" then
        ply:ConCommand("set_team 1")
    elseif ent:GetName() == "waiting_redteambutt" then
        ply:ConCommand("set_team 2")
    elseif ent:GetName() == "waiting_greenteambutt" then
        ply:ConCommand("set_team 3")
    elseif ent:GetName() == "waiting_yellowteambutt" then
        ply:ConCommand("set_team 4")
    end
end

-- when holding something
function GM:OnPlayerPhysicsPickup(ply, ent)
    local enty = ent:GetName()

    if string.sub(enty, -4, -2) == "box" then
        ply:SetNWInt("pickup", 1)
        local num = string.sub(enty, -1, -1)
        local length = string.len(enty) - 5
        local col = string.sub(enty, 1, length)
        boxprint(ply, num, col)
    end
end

function GM:OnPlayerPhysicsDrop(ply, ent)
    ply:SetNWInt("pickup", 0)
end

-- this has been edited, instead of 4 for loops looping the same things in themselves
function boxprint(ply, boxnum, col)
    local mobrarstr
    local mobrarval
    local mobtype
    local mobnum
    local mobtech

    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == (col .. "_box" .. boxnum .. "_rarity_case") then
            mobrarstr = entity:GetInternalVariable("Case16")
            mobrarval = entity:GetInternalVariable("Case15")
        end

        if mobrarval and entity:GetName() == (col .. "_box" .. boxnum .. "_mobcase_" .. mobrarval) then
            mobtype = entity:GetInternalVariable("Case16")
        end

        if entity:GetName() == (col .. "_box" .. boxnum .. "_amountcounter_rand") then
            mobnum = entity:GetInternalVariable("Case16")
        end

        if entity:GetName() == (col .. "_box" .. boxnum .. "_tech_casein") then
            mobtech = entity:GetInternalVariable("Case16")
        end
    end

    -- essentially making sure these all have a value
    if mobrarstr and mobrarval and mobtype and mobnum and mobtech then
        ply:SetNWInt("pick_type", mobtype)
        ply:SetNWInt("pick_rar", mobrarstr)
        ply:SetNWInt("pick_tech", mobtech)
        ply:SetNWInt("pick_str", mobnum)
        ply:SetNWInt("pick_col", col)
    end
end

-- determine if upgrade affordable
function trigafford(team_entity)
    local col = string.sub(team_entity, 1, -16)
    local points
    local colnum = teamval[col]

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            points = tonumber(ply:GetNWInt("researchPoints"))

            if points >= 1 then
                for k, entity in ipairs(ents.GetAll()) do
                    if entity:GetName() == team_entity then
                        entity:Fire("Enable")
                    end
                end
            else
                ply:PrintMessage(HUD_PRINTTALK, "-------------\nCan't Afford\n-------------")
            end
        end
    end
end

function randomizeboxsub(box)
    -- local num = string.sub(box,-1,-1)
    local length = string.len(box) - 5
    local col = string.sub(box, 1, length)

    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == (box .. "_tech_casein") then
            local subamount = tonumber(entity:GetInternalVariable("Case16")) * 6

            if string.len(tostring(subamount)) == 1 then
                pointsub(tostring(col) .. "0" .. subamount)
            elseif string.len(tostring(subamount)) == 2 then
                pointsub(tostring(col) .. subamount)
            end
        end
    end
end

-- i hate this func. i hate notepad++. i hate hammer.
function randafford(boxname)
    -- local num = string.sub(boxname,-1,-1)
    local length = string.len(boxname) - 5
    local col = string.sub(boxname, 1, length)
    local points = 0
    local mobTechCost
    local techCase
    local levelAvailable
    local maxLevel
    local upgradeCase
    local rarAddTrigger
    local colnum = teamval[col]

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            points = tonumber(ply:GetNWInt("researchPoints"))

            for _, entity in ipairs(ents.GetAll()) do
                if entity:GetName() == (boxname .. "_tech_casein") then
                    techCase = entity
                end

                if entity:GetName() == (boxname .. "_upgrade_case") then
                    upgradeCase = entity
                end

                if entity:GetName() == (col .. "_raradd_trig") then
                    rarAddTrigger = entity
                end
            end

            levelAvailable = tonumber(techCase:GetInternalVariable("Case16"))

            if levelAvailable >= 5 then
                ply:PrintMessage(HUD_PRINTTALK, "-------------\nMax Level\n-------------")

                return
            end

            mobTechCost = levelAvailable * 6
            maxLevel = tonumber(upgradeCase:GetInternalVariable("Case01"))

            if maxLevel == 2 then
                if points >= mobTechCost then
                    rarAddTrigger:Fire("Enable")
                else
                    ply:PrintMessage(HUD_PRINTTALK, "-------------\nCan't Afford\n-------------")
                end
            elseif maxLevel == 1 then
                ply:PrintMessage(HUD_PRINTTALK, "------------------------\nTech Level Not Available\n------------------------")
            else --                                                  ------------------------
                ply:PrintMessage(HUD_PRINTTALK, "Congrats! You've found a bug, please screenshot this and send it along with a description of what you were doing to the developers in the discord.")
            end
        end
    end
end

--RESEARCH POINTS EDITING
-- subtract points from team
function pointsub(teamID)
    local amount = string.sub(teamID, -2, -1)
    local col = string.sub(teamID, 1, string.len(teamID) - 2)
    local colnum = teamval[col]

    for entity, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            ply:SetNWInt("researchPoints", ply:GetNWInt("researchPoints") - tonumber(amount))
        end
    end
end

-- add points to team
function pointadd(teamID)
    local amount = string.sub(teamID, -2, -1)
    local col = string.sub(teamID, 1, string.len(teamID) - 2)
    local colnum = teamval[col]

    for entity, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            ply:SetNWInt("researchPoints", tostring(tonumber(ply:GetNWInt("researchPoints")) + tonumber(amount)))
        end
    end
end

-- adds points per person alive in survival
function survpointadd(teamID)
    for entity, ply in ipairs(player.GetAll()) do
        if ply:Team() == teamID then
            ply:SetNWInt("researchPoints", ply:GetNWInt("researchPoints") + 10)
        end
    end
end

-- toggle the bonus round state
function broundtoggle(state)
    local amount = state

    if tonumber(amount) == 0 then
        print("Bonusrounds Disabled")

        for k, entity in ipairs(ents.GetAll()) do
            if entity:GetName() == "newround_counter" then
                entity:Fire("Disable")
            end

            if entity:GetName() == "bonusround_disable_relay" then
                entity:Fire("Enable")
            end
        end
    elseif tonumber(amount) == 1 then
        print("Bonusrounds Enabled")

        for k, entity in ipairs(ents.GetAll()) do
            if entity:GetName() == "newround_counter" then
                entity:Fire("Enable")
            end

            if entity:GetName() == "bonusround_disable_relay" then
                entity:Fire("Disable")
            end
        end
    else
        print("Invalid Entry")
    end
end

--TIMER STUFF
function roundend()
end

function roundbegin()
end

-- checks to see if server is empty on player disconnects
function GM:PlayerDisconnected(ply)
    print("A player has disconnected")
    print(ply:Name() .. " has left the server.")
    colortest()
    timer.Simple(10, allgonecheck)
end

-- runs endtimerstart() if server is empty
function allgonecheck()
    print(tonumber(player.GetCount()))

    if tonumber(player.GetCount()) == 0 then
        print("Server Empty")
        endtimerstart()
    else
        print("Server Not Empty")
    end
end

-- creates timer to run gamereset
function endtimerstart()
    timer.Create("endtimer", 50, 1, gameReset)
end

-- unknown, timer stuff, might be deprecated
function allgonened()
    if timer.Exists("endtimer") then
        print("Server Reloaded")
        timer.Remove("endtimer")
    end
end

-- resets the game by reloading the map
function gameReset()
    RunConsoleCommand("changelevel", "gm_sts") -- should've done this from the beginning
end

function getTeamIDFromName(teamName1)
    local teamIDs = {"blue", "red", "green", "yellow"}

    for i, name in ipairs(teamIDs) do
        if name == teamName1 then return i end
    end
end

function addTeamPoints(teamName, change)
    local points
    local teamID = getTeamIDFromName(teamName)

    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == (teamName .. "_points") then
            points = entity:GetNwInt("researchPoints")
            entity:SetNWInt("researchPoints", points + change)
            points = points + change
        end
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == teamID then
            ply:SetNWInt("researchPoints", points)
        end
    end
end

hook.Add("OnEntityCreated", "AssignTeams", function(ent)
    if not ent:IsValid() or not ent:IsNPC() then return end
    PrintMessage(HUD_PRINTTALK, "Entity creation")
    AssignTeam(ent, ent:GetName())
    PrintMessage(HUD_PRINTTALK, "Done Entity creation")
    local npcClass = ent:GetClass()

    if npcClass == "npc_poisonzombie" and (ent:EntIndex() ~= 0) then
        local poisonZombieTeam = ent:GetName()
        -- Start a timer that runs every second
        PrintMessage(HUD_PRINTTALK, "Starting poison zombie check" .. ent:EntIndex())

        timer.Create("CheckForHeadcrabs" .. ent:EntIndex(), 0.1, 600, function()
            if not ent:IsValid() or ent:EntIndex() == 0 then
                timer.Remove("CheckForHeadcrabs" .. ent:EntIndex())

                return
            end

            local foundEntities = ents.FindInSphere(ent:GetPos(), 100) -- adjust radius as necessary

            for _, foundEnt in ipairs(foundEntities) do
                if foundEnt:GetClass() == "npc_headcrab_poison" then
                    AssignTeam(foundEnt, poisonZombieTeam)
                    foundEnt:SetKeyValue("rendercolor", "255 30 30")
                    PrintMessage(HUD_PRINTTALK, "Assigned headcrab team.")
                end
            end
        end)
    end
end)

hook.Add("OnNPCKilled", "TrackZombieDeath", function(npc)
    local zombieTypes = {"npc_zombie", "npc_zombie_torso", "npc_fastzombie", "npc_poisonzombie"}

    for _, type in ipairs(zombieTypes) do
        if npc:GetClass() == type then
            local deadZombiePos = npc:GetPos()
            local deadZombieTeam = npc:GetName()

            -- timer might be necessary as headcrab might not exist on same tick
            timer.Create("CheckForHeadcrab" .. npc:EntIndex(), 0, 3, function()
                PrintMessage(HUD_PRINTTALK, "Death headcrab check.")
                local foundEntities = ents.FindInSphere(deadZombiePos, 25) -- radius needs adjusting

                for _, ent in ipairs(foundEntities) do
                    if (ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_headcrab_fast" or ent:GetClass() == "npc_headcrab_black") and ent:GetName() == "" then
                        AssignTeam(ent, deadZombieTeam)
                        ent:SetKeyValue("rendercolor", "255 30 30")
                        PrintMessage(HUD_PRINTTALK, "Assigned headcrab team.")
                        timer.Remove("CheckForHeadcrab" .. npc:EntIndex())

                        return
                    end
                end
            end)
        end
    end
end)

function AssignTeam(ent, team)
    if not ent:IsValid() or not ent:IsNPC() then return end
    team = team or ""

    local npcColors = {"Redteam", "Blueteam", "Greenteam", "Yellowteam"}

    local teamEnts = {}

    -- for some reason which I cannot diagnose or explain despite my best attempts, this is always true. running the same check in game is not always true. i don't get it!
    if ent:GetName() == "" then
        ent:SetName(team)
    end

    for i, teamName in ipairs(npcColors) do
        teamEnts[i] = ents.FindByName(teamName)
    end

    for i, teamName in ipairs(npcColors) do
        if ent:GetName() == teamName then
            for _, sameTeamEnt in ipairs(teamEnts[i]) do
                -- to avoid self-love
                if ent ~= sameTeamEnt then
                    if string.find(ent:GetName(), teamName) then
                        ent:AddEntityRelationship(sameTeamEnt, D_LI, 10)
                    else
                        ent:AddEntityRelationship(sameTeamEnt, D_HT, 10)
                    end
                end
            end
        end
    end
end

function roundLimitChange(amount)
    local roundLimitConvar = GetConVar("sts_total_rounds")
    local roundLimit = roundLimitConvar:GetInt()
    roundLimitConvar:SetInt(roundLimit + amount)
end

function startingPointsChange(amount)
    local startingPointsConvar = GetConVar("sts_starting_points")
    local startingPoints = startingPointsConvar:GetInt()
    startingPointsConvar:SetInt(startingPoints + (amount * 5))
end

function startGame()
end