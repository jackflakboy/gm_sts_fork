AddCSLuaFile("bonusround.lua")
AddCSLuaFile("concommands.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("custommenu.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("testhud.lua")
AddCSLuaFile("cubes.lua")
AddCSLuaFile("misc.lua")
AddCSLuaFile("mobs.lua")
include("bonusround.lua")
include("concommands.lua")
include("custommenu.lua")
include("shared.lua")
include("teamsetup.lua")
include("testhud.lua")
include("cubes.lua")
include("net.lua")
include("misc.lua")
include("mobs.lua")
AddCSLuaFile("net.lua")
math.randomseed(os.time())

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
        shouldStartLeverBeLocked()
    elseif ent:GetName() == "waiting_redteambutt" then
        ply:ConCommand("set_team 2")
        shouldStartLeverBeLocked()
    elseif ent:GetName() == "waiting_greenteambutt" then
        ply:ConCommand("set_team 3")
        shouldStartLeverBeLocked()
    elseif ent:GetName() == "waiting_yellowteambutt" then
        ply:ConCommand("set_team 4")
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
function trigafford(teamEntity)
    local col = string.sub(teamEntity, 1, -16)
    local points
    local colnum = teamval[col]

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            points = tonumber(ply:GetNWInt("researchPoints"))

            if points >= 1 then
                for k, entity in ipairs(ents.GetAll()) do
                    if entity:GetName() == teamEntity then
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
    print("running randomizeboxsub")
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
-- needs significant testing
hook.Add("OnEntityCreated", "AssignTeams", function(ent)
    if not ent:IsValid() or not ent:IsNPC() or engine.TickCount() < 1980 then return end
    PrintMessage(HUD_PRINTTALK, "Entity creation")
    timer.Simple(1 / 66, function() AssignTeam(ent, ent:GetName()) end )
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
    PrintMessage(HUD_PRINTTALK, "Name is" .. ent:GetName())
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
    PrintMessage(HUD_PRINTCENTER, "Ready!")
    GetConVar("sts_game_started"):SetInt(1)
end

function upgradeABox(cubeName)
    PrintMessage(HUD_PRINTTALK, "Upgrading!!!")
    randomizeABox(cubeName)
    -- a lot of checks can be skipped like team validation as that essentially handled
    -- by the game world itself, and if bypassed (via noclip), its probably for a good reason
    -- only checks required should be checking affordability
end

function randomizeABox(cubeName)
    PrintMessage(HUD_PRINTTALK, "Randomizing!!!")
    local desiredCube
    local availablePoints

    for _, teamName in ipairs(teams) do
        for _, cube in pairs(teamName.cubes) do
            if cube.entity == cubeName then
                desiredCube = cube
                availablePoints = teamName.points
            end
        end
    end

    if availablePoints <= 0 then
        PrintMessage(HUD_PRINTTALK, "Cannot afford")
        return
    end

    if desiredCube then
        desiredCube:randomize()
    else
        PrintMessage(HUD_PRINTTALK, "Could not find cube in random func!")
    end

end

hook.Add("PlayerDeath", "Deathmatch Add Points", deathmatchKill)