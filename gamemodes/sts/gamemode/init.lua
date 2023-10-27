AddCSLuaFile("bonusround.lua")
AddCSLuaFile("concommands.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("testhud.lua")
AddCSLuaFile("cubes.lua")
AddCSLuaFile("misc.lua")
AddCSLuaFile("mobs.lua")
AddCSLuaFile("sound.lua")
include("bonusround.lua")
include("concommands.lua")
include("shared.lua")
include("teamsetup.lua")
include("testhud.lua")
include("cubes.lua")
include("net.lua")
include("misc.lua")
include("mobs.lua")
include("triggers.lua")
include("sound.lua")
AddCSLuaFile("net.lua")
math.randomseed(os.time())
nextMap = ""
nextBR = ""
currentMap = ""
maps = {"square", "cit", "rav", "rail", "lake", "yellow", "green", "blue"}
gameState = 0
-- 0 - game not started
-- 1 - Randomizing
-- 2 - battle
-- 3 - minigame

-- determines loadout. returning true means override default, this might be able to be used for minigames.
function GM:PlayerLoadout(ply)
    return true
end

-- TODO: check if currently in a bonus round, then give weapons
-- if bonus round
-- if bonus round == round with gun
-- give guns

cvars.AddChangeCallback("sts_random_teams", function(convarName, valueOld, valueNew)
    print("TODO: Create team door and open and close it")
end)

cvars.AddChangeCallback("sts_force_bonus_rounds", function(convarName, valueOld, valueNew)
    print("TODO: Change lever and lock it")
end)


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

cvars.AddChangeCallback("sts_starting_points", function(convarName, valueOld, valueNew)
    if valueNew == "80" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_startpnt_up" then
                ent:Fire("lock")
            end
        end
    else
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_startpnt_up" then
                ent:Fire("unlock")
            end
        end
    end
    if valueNew == "5" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_startpnt_down" then
                ent:Fire("lock")
            end
        end
    else
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_startpnt_down" then
                ent:Fire("unlock")
            end
        end
    end
end)

cvars.AddChangeCallback("sts_total_rounds", function(convarName, valueOld, valueNew)
    if valueNew == "24" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_score_up" then
                ent:Fire("lock")
            end
        end
    else
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_score_up" then
                ent:Fire("unlock")
            end
        end
    end
    if valueNew == "1" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_score_down" then
                ent:Fire("lock")
            end
        end
    else
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_score_down" then
                ent:Fire("unlock")
            end
        end
    end
end)

cvars.AddChangeCallback("sts_game_started", function(convarName, valueOld, valueNew)
    if valueNew == "1" then
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "waiting_score_up" then
                ent:Fire("lock")
            elseif ent:GetName() == "waiting_score_down" then
                ent:Fire("lock")
            elseif ent:GetName() == "waiting_startpnt_down" then
                ent:Fire("lock")
            elseif ent:GetName() == "waiting_startpnt_up" then
                ent:Fire("lock")
            end
        end
    end
end)

cvars.AddChangeCallback("sts_forbid_dev_room", function(convarName, valueOld, valueNew)
    if valueNew == "0" then
        print("gyas")
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "dev_secret_button" then
                ent:Fire("unlock")
                break
            end
        end
    else
        for _, ent in ipairs(ents.GetAll()) do
            if ent:GetName() == "dev_secret_button" then
                ent:Fire("lock")
                break
            end
        end
    end
end)

cvars.AddChangeCallback("sts_minimum_players", function(convarName, valueOld, valueNew)
    shouldStartLeverBeLocked()
end)



function getAmountOfTeamedPlayers()
    local teamedPlayers = 0
    for i, teamLoop in ipairs(team.GetAllTeams()) do
        if team.GetName(i) ~= "Spectator" and team.GetName(i) ~= "Empty" then
            for _, _ in ipairs(team.GetPlayers(i)) do
                teamedPlayers = teamedPlayers + 1
            end
        end
    end
    return teamedPlayers
end

function shouldStartLeverBeLocked()
    PrintMessage(HUD_PRINTTALK, "Checking!")
    local teamedPlayers = getAmountOfTeamedPlayers()
    local minimumRequired = GetConVar("sts_minimum_players"):GetInt()
    local gameStarted = GetConVar("sts_game_started"):GetInt()

    for _, ent in ipairs(ents.GetAll()) do
        if ent:GetName() == "waiting_lobby_readylever" then
            if teamedPlayers >= minimumRequired and gameStarted == 0 then
                ent:Fire("Unlock")
                PrintMessage(HUD_PRINTTALK, "Unlocked!")
                return false
            else
                ent:Fire("Lock")
                PrintMessage(HUD_PRINTTALK, "Locked!")
                return true
            end
        end
    end
end

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

    local mapLevers = {"waiting_lobby_maplever_square", "waiting_lobby_maplever_cit", "waiting_lobby_maplever_rav", "waiting_lobby_maplever_rail", "waiting_lobby_maplever_lake", "waiting_lobby_maplever_yellow", "waiting_lobby_maplever_green", "waiting_lobby_maplever_blue"}

    local selectedMaps = {}


    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() ~= "waiting_lobby_brtoggle_lever" then
            for _, bonusRoundLever in ipairs(mapLevers) do
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
    local goodSelectedMaps = {}
    for _, k in ipairs(selectedMaps) do
        table.insert(goodSelectedMaps, getMapFromWhatever(k))
    end

    return goodSelectedMaps
end

function GM:PlayerInitialSpawn(ply)
    ply:SetMaxHealth(100)
    ply:SetHealth(100)
    ply:SetRunSpeed(400)
    ply:SetPlayerColor(Vector(0.0, 0.0, 0.0))
    setTeamFull(ply, 0)

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
    if ply:Team() ~= 0 then
        local teams = {"waiting_bluetp", "waiting_redtp", "waiting_greentp", "waiting_yellowtp"}
        local spawnPoint = teams[ply:Team()]
        if GetConVar("sts_game_started"):GetInt() == 1 then
            for _, ent in ipairs(ents.GetAll()) do
                if ent:GetName() == spawnPoint then
                    ply:SetPos(ent:GetPos())
                    ply:SetEyeAngles(ent:GetAngles())
                    break
                end
            end
        end
    end
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

function spawnTeams()
    for _, ply in ipairs(player.GetAll()) do
        ply:Spawn()
    end
end

function GM:PlayerUse(ply, ent)
    if ent:GetName() == "waiting_blueteambutt" then
        setTeamFull(ply, 1)
        shouldStartLeverBeLocked()
    elseif ent:GetName() == "waiting_redteambutt" then
        setTeamFull(ply, 2)
        shouldStartLeverBeLocked()
    elseif ent:GetName() == "waiting_greenteambutt" then
        setTeamFull(ply, 3)
        shouldStartLeverBeLocked()
    elseif ent:GetName() == "waiting_yellowteambutt" then
        setTeamFull(ply, 4)
        shouldStartLeverBeLocked()
    end
end

-- when holding something
function GM:OnPlayerPhysicsPickup(ply, ent)
    local enty = ent:GetName()
    local boxEnt

    if string.sub(enty, -4, -2) == "box" then
        for _, teamID in pairs(teams) do
            for _, box in pairs(teamID.cubes) do
                if box.entity == enty then
                    boxEnt = box
                end
            end
        end
        if boxEnt then
            PrintMessage(HUD_PRINTTALK, boxEnt.entity)
            SendBoxInfoToPlayer(ply, boxEnt)
        end
    end
end

function GM:OnPlayerPhysicsDrop(ply, ent)
    ClearBox(ply)
end

--TIMER STUFF
function roundend()
end

function roundbegin()
end

-- checks to see if server is empty on player disconnects
function GM:PlayerDisconnected(ply)
    shouldStartLeverBeLocked()
    print("A player has disconnected")
    print(ply:Name() .. " has left the server.")
    timer.Simple(10, allgonecheck)
end

function GM:PlayerConnect(name, ip)
    shouldStartLeverBeLocked()
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

function beginTeamAssignment()
    -- needs significant testing
    -- hook.remove would probably be best for bonus rounds
    hook.Add("OnEntityCreated", "AssignTeams", function(ent)
        if not ent:IsValid() or not ent:IsNPC() or engine.TickCount() < 1980 then return end
        print(ent:GetName() .. " created")
        timer.Simple(1 / 66, function() AssignTeam(ent, ent:GetName()) end )
        local npcClass = ent:GetClass()

        if (npcClass == "npc_headcrab" or npcClass == "npc_headcrab_fast" or npcClass == "npc_headcrab_black") and ent:GetName() == "" then return end

        -- timer.Simple(1 / 66, function()
        --     ent:SetPos(nextMapSpawnLocations[string.sub( ent:GetName(), 1, string.find( ent:GetName(), "_" ) - 1 )][math.random(1, nextMapSpawnLocations[string.sub( ent:GetName(), 1, string.find( ent:GetName(), "_" ) - 1 )])])
        -- end)

        if npcClass == "npc_poisonzombie" and (ent:EntIndex() ~= 0) then
            local poisonZombieTeam = ent:GetName()
            -- Start a timer that runs every second
            print("Starting poison zombie check" .. ent:EntIndex())

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
                        print("Assigned headcrab team.")
                    end
                end
            end)
        end
    end)
end

function endTeamAssignment()
    hook.Remove("OnEntityCreated", "AssignTeams")
end

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

function AssignTeam(ent, teamInput)
    if not ent:IsValid() or not ent:IsNPC() then return end
    teamInput = teamInput or ""

    local npcColors = {"Redteam", "Blueteam", "Greenteam", "Yellowteam"}

    local teamEnts = {}

    -- for some reason which I cannot diagnose or explain despite my best attempts, 
    -- this check is always true. running the same check in game is not always true. i don't get it!
    -- Too Bad!
    if ent:GetName() == "" then
        ent:SetName(teamInput)
    end
    print("Name is" .. ent:GetName())
    for i, teamName in ipairs(npcColors) do
        teamEnts[i] = ents.FindByName(teamName)
    end

    for i, teamName in ipairs(npcColors) do
        for _, teamEntity in ipairs(teamEnts[i]) do
            -- to avoid self-love
            if ent ~= teamEntity and teamEntity:IsNPC() then
                if string.find(ent:GetName(), teamName) then
                    ent:AddEntityRelationship(teamEntity, D_LI, 10)
                    teamEntity:AddEntityRelationship(ent, D_LI, 10)
                    print(ent:GetClass() .. " now likes " .. teamEntity:GetClass() .. "!")
                else
                    ent:AddEntityRelationship(teamEntity, D_HT, 10)
                    teamEntity:AddEntityRelationship(ent, D_HT, 10)
                    print(ent:GetClass() .. " now hates " .. teamEntity:GetClass() .. "!")
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
    PrintMessage(HUD_PRINTCENTER, "Ready!")
    GetConVar("sts_game_started"):SetInt(1)
    nextMap = chooseNextMap()
    nextBR = chooseBonusRound()
    setNextMapScreen(getMapScreen(nextMap))
    beginPlayingMainTrack()
end

function upgradeABox(cubeName)
    -- A lot of checks can be skipped like team validation as that essentially handled
    -- by the game world itself, and if bypassed (i.e. thru noclip), its probably for a good reason.
    -- The only checks required should be checking affordability and tech level
    local desiredCube
    local availablePoints
    local currentTeam

    for _, teamName in ipairs(teams) do
        for _, cube in pairs(teamName.cubes) do
            if cube.entity == cubeName then
                currentTeam = teamName
                desiredCube = cube
                availablePoints = teamName.points
                break
            end
        end
    end

    if desiredCube.level == 5 then
        PrintMessage(HUD_PRINTTALK, "Max tech level reached!")
        return
    end

    for _, cube in pairs(currentTeam.cubes) do
        if cube ~= desiredCube and cube.level < desiredCube.level then
            PrintMessage(HUD_PRINTTALK, "Tech Level not Available!")
            return
        end
    end

    if desiredCube:canUpgrade(availablePoints) then
        desiredCube:upgrade()
        currentTeam.points = currentTeam.points - (desiredCube.level * 6)
    else
        PrintMessage(HUD_PRINTTALK, "Cannot afford")
    end

    if currentTeam.cubes["cube1"].level == currentTeam.cubes["cube2"].level and currentTeam.cubes["cube3"].level == currentTeam.cubes["cube4"].level and currentTeam.cubes["cube2"].level == currentTeam.cubes["cube3"].level then
        PrintMessage(HUD_PRINTTALK, "New Tech Level!")
        local funny = math.random(1, 100)
        if funny == 1 then
            playGlobalSound("sts_sounds_new/newtechlevel_funny.wav", getTeamIDFromName(currentTeam))
        else
            local variant = math.random(1, 3)
            playGlobalSound("sts_sounds_new/newtechlevel" .. variant .. ".wav", getTeamIDFromName(currentTeam))
        end
    end
    -- lazy
    for teamIndex = 1, 4 do
        SendPointsToTeamMembers(teamIndex)
    end
end

function randomizeABox(cubeName)
    PrintMessage(HUD_PRINTTALK, "Randomizing " .. cubeName .. "!")
    local desiredCube
    local availablePoints

    for _, teamName in ipairs(teams) do
        for _, cube in pairs(teamName.cubes) do
            if cube.entity == cubeName then
                desiredCube = cube
                availablePoints = teamName.points
                break
            end
        end
    end

    if availablePoints <= 0 then
        PrintMessage(HUD_PRINTTALK, "Cannot afford")
        return
    end

    if desiredCube then
        desiredCube:randomize()
        for _, teamName in ipairs(teams) do
            for _, cube in pairs(teamName.cubes) do
                if cube.entity == cubeName then
                    teamName.points = teamName.points - 1
                    break
                end
            end
        end
    else
        PrintMessage(HUD_PRINTTALK, "Could not find cube in random func!")
    end
    -- lazy
    for teamIndex = 1, 4 do
        SendPointsToTeamMembers(teamIndex)
    end

end

function chooseNextMap()
    local options = getChosenMaps()
    local map = options[math.random(#options)]
    return map
end

function chooseBonusRound()
    local options = getChosenBonusRounds()
    if options == {} then return {} end
    local bonusRound = options[math.random(#options)]
    return bonusRound
end

function setNextMapScreen(map)
    local waitingScreens = {
        "waiting_screen_mapblue",
        "waiting_screen_mapyellow",
        "waiting_screen_mapgreen",
        "waiting_screen_maplake",
        "waiting_screen_maprail",
        "waiting_screen_maprav",
        "waiting_screen_mapcit",
        "waiting_screen_mapsquare"
    }
    for _, ent in ipairs(ents.GetAll()) do
        for _, mapScreen in ipairs(waitingScreens) do
            if ent:GetName() == map then
                ent:Fire("Alpha", 255)
            elseif ent:GetName() == mapScreen then
                ent:Fire("Alpha", 0)
            end
        end
    end
end

function getMapFromWhatever(whatever)
    local mapLevers = {
        ["waiting_lobby_maplever_square"] = "square",
        ["waiting_lobby_maplever_cit"] =    "cit",
        ["waiting_lobby_maplever_rav"] =    "rav",
        ["waiting_lobby_maplever_rail"] =   "rail",
        ["waiting_lobby_maplever_lake"] =   "lake",
        ["waiting_lobby_maplever_yellow"] = "yellow",
        ["waiting_lobby_maplever_green"] =  "green",
        ["waiting_lobby_maplever_blue"] =   "blue"
    }
    if mapLevers[whatever] then return mapLevers[whatever] end
    local mapScreens = {
        ["waiting_screen_mapblue"] =    "blue",
        ["waiting_screen_mapyellow"] =  "yellow",
        ["waiting_screen_mapgreen"] =   "green",
        ["waiting_screen_maplake"] =    "lake",
        ["waiting_screen_maprail"] =    "rail",
        ["waiting_screen_maprav"] =     "rav",
        ["waiting_screen_mapcit"] =     "cit",
        ["waiting_screen_mapsquare"] =  "square"
    }
    if mapScreens[whatever] then return mapScreens[whatever] end
end

function getMapScreen(map)
    local info = {
        ["blue"] =  "waiting_screen_mapblue",
        ["yellow"] = "waiting_screen_mapyellow",
        ["green"] = "waiting_screen_mapgreen",
        ["lake"] = "waiting_screen_maplake",
        ["rail"] = "waiting_screen_maprail",
        ["rav"] = "waiting_screen_maprav",
        ["cit"] = "waiting_screen_mapcit",
        ["square"] = "waiting_screen_mapsquare"
    }
    return info[map]
end

function ReadyLeverPulled(teamName)
    local levers = {"waiting_blue_ready_lever", "waiting_red_ready_lever", "waiting_green_ready_lever", "waiting_yellow_ready_lever"}
    local pulled = 0
    local required = 0

    playGlobalSound("sts_sounds_new/" .. teamName .. "_ready.wav")

    for i = 1, 4 do
        if #team.GetPlayers(i) > 0 then
            required = required + 1
        end
    end
    for _, ent in ipairs(ents.GetAll()) do
        for _, lever in ipairs(levers) do
            if ent:GetName() == lever and ent:GetInternalVariable("m_toggle_state") == 0 then
                pulled = pulled + 1
            end
        end
    end
    if required == pulled then
        PrintMessage(HUD_PRINTTALK, "All teams ready!")
    end
end

hook.Add("PlayerDeath", "Deathmatch Add Points", deathmatchKill)