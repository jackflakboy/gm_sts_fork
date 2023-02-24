AddCSLuaFile("bonusround.lua")
AddCSLuaFile("concommands.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("custommenu.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("teamsetup.lua")
AddCSLuaFile("testhud.lua")
include("bonusround.lua")
include("concommands.lua")
include("custommenu.lua")
include("shared.lua")
include("teamsetup.lua")
include("testhud.lua")

--local beginon = 1
-- Idk what they do but glualint insists they are unused
--local open = false
function GM:PlayerLoadout(ply)
    return true
end

RunConsoleCommand("sv_gravity", "600")
RunConsoleCommand("sk_combine_s_kick", "6")

-- this is a bodge. remove when hammer issues figured out
function setCorrectBonusRoundState()
    local lever
    local counter
    local relay
    local leverClass
    local leverState

    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "newround_counter" then
            counter = entity
        end

        if entity:GetName() == "bonusround_disable_relay" then
            relay = entity
        end

        if entity:GetName() == "waiting_lobby_brtoggle_lever" then
            lever = entity
        end
    end
    -- https://wiki.facepunch.com/gmod/Entity:GetInternalVariable
    leverClass = lever:GetClass()

    if ( leverClass == "func_door" or leverClass == "func_door_rotating" ) then
        leverState = lever:GetInternalVariable( "m_toggle_state" ) == 0
    elseif ( leverClass == "prop_door_rotating" ) then
        leverState = lever:GetInternalVariable( "m_eDoorState" ) ~= 0
    else
        leverState = false
    end
    -- lever up means the door is closed (false) and bonus rounds should be on. 
    if leverState == false then
        counter:Fire("Disable")
        relay:Fire("Enable")
        counter:Fire("Enable")
        relay:Fire("Disable")
    else
        counter:Fire("Disable")
        relay:Fire("Enable")
        counter:Fire("Enable")
        relay:Fire("Disable")
    end
end

function GM:PlayerInitialSpawn(ply)
    allgonened()
    setCorrectBonusRoundState()
    ply:SetMaxHealth(100)
    ply:SetHealth(100)
    ply:SetRunSpeed(400)
    ply:SetModel("models/player/group03m/male_07.mdl")
    ply:SetNWInt("combat", 0)
    ply:SetNWInt("stsgod", 0)
    ply:SetNWInt("dmpnt", 1)
    ply:SetNWInt("pickup", 0)
    ply:SetNWInt("desc", 1)
    ply:SetNWInt("researchPoints", 0)
    ply:ConCommand("set_team " .. 0)
end

function GM:PlayerSpawn(ply)
    checkbegin(ply)
    setCorrectBonusRoundState()
end

function checkbegin(ply)
    for _, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "beginonoff" then
            local var = tonumber(entity:GetInternalVariable("Case16"))
            ply:SetNWInt("beginon", var)
        end

        if entity:GetName() == "waiting_startpnt_case" then
            local var = tonumber(entity:GetInternalVariable("Case16"))
            ply:SetNWInt("strtpnt", var)
        end

        if entity:GetName() == "waiting_score_case" then
            local var = tonumber(entity:GetInternalVariable("Case16"))
            ply:SetNWInt("strtround", var)
        end
    end
end

-- why no e???
function bgin(x)
    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("beginon", tonumber(x))
    end
end

util.AddNetworkString("FMenu")

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

function spawnteams()
    for _, ply in ipairs(player.GetAll()) do
        ply:Spawn()
    end
end

--SCORE
function scoreadd(x)
    team.AddScore(x, 1)
end

function scorereset(x)
    team.SetScore(1, 0)
    team.SetScore(2, 0)
    team.SetScore(3, 0)
    team.SetScore(4, 0)

    for entity, ply in ipairs(player.GetAll()) do
        ply:SetNWInt("researchPoints", x)
    end
end

function begin(x)
    beginon = x
end

--PLAYER USING
-- ? button???
function GM:PlayerUse(ply, ent)
    if ent:GetName() == "waiting_blueteambutt" then
        ply:ConCommand("set_team 1")
        setCorrectBonusRoundState()
    end

    if ent:GetName() == "waiting_redteambutt" then
        ply:ConCommand("set_team 2")
        setCorrectBonusRoundState()
    end

    if ent:GetName() == "waiting_greenteambutt" then
        ply:ConCommand("set_team 3")
        setCorrectBonusRoundState()
    end

    if ent:GetName() == "waiting_yellowteambutt" then
        ply:ConCommand("set_team 4")
        setCorrectBonusRoundState()
    end
end

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

-- trig???? trigonometry???? what does this mean???? trigger?????
function trigafford(y)
    local col = string.sub(y, 1, -16)
    local points
    local colnum = teamval[col]

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            points = tonumber(ply:GetNWInt("researchPoints"))

            if points >= 1 then
                for k, entity in ipairs(ents.GetAll()) do
                    if entity:GetName() == y then
                        entity:Fire("Enable")
                    end
                end
            else
                ply:PrintMessage(HUD_PRINTTALK, "\n\n\n\n\n\n\n\n\n\nCan't Afford\n-------------\n\n\n\n")
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
                ply:PrintMessage(HUD_PRINTTALK, ".\n\n\n\n\n\n\n\n\n\nMax Level\n-------------\n\n\n\n")
                return
            end
            mobTechCost = levelAvailable * 6
            maxLevel = tonumber(upgradeCase:GetInternalVariable("Case01"))
            if maxLevel == 2 then
                if points >= mobTechCost then
                    rarAddTrigger:Fire("Enable")
                else
                    ply:PrintMessage(HUD_PRINTTALK, "\n\n\n\n\n\n\n\n\n\nCan't Afford\n-------------\n\n\n\n")
                end
            elseif maxLevel == 1 then
                ply:PrintMessage(HUD_PRINTTALK, "\n\n\n\n\n\n\n\n\n\nTech Level Not Available\n-------------\n\n\n\n")
            else
                ply:PrintMessage(HUD_PRINTTALK, "\n\n\n\n\n\n\n\n\n\nCongrats! You've found a bug, please screenshot this and send it along with a description of what you were doing to the developers.\n\n\n\n")
            end
        end
    end
end


--RESEARCH POINTS EDITING
function pointsub(x)
    local amount = string.sub(x, -2, -1)
    local col = string.sub(x, 1, string.len(x) - 2)
    local colnum = teamval[col]

    for entity, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            ply:SetNWInt("researchPoints", ply:GetNWInt("researchPoints") - tonumber(amount))
        end
    end
end

function pointadd(x)
    local amount = string.sub(x, -2, -1)
    local col = string.sub(x, 1, string.len(x) - 2)
    local colnum = teamval[col]

    for entity, ply in ipairs(player.GetAll()) do
        if ply:Team() == colnum then
            ply:SetNWInt("researchPoints", tostring(tonumber(ply:GetNWInt("researchPoints")) + tonumber(amount)))
        end
    end
end

function survpointadd(x)
    for entity, ply in ipairs(player.GetAll()) do
        if ply:Team() == x then
            ply:SetNWInt("researchPoints", ply:GetNWInt("researchPoints") + 10)
        end
    end
end

function broundtoggle(x)
    local amount = x
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
    setCorrectBonusRoundState()
end

function roundbegin()
    setCorrectBonusRoundState()
end

function colortest()
    for k, entity in pairs(teamval) do
        if k ~= "empty" then
            if team.NumPlayers(entity) == 0 then
                --print(k.." "..team.NumPlayers(entity))
                for _, l in ipairs(ents.GetAll()) do
                    if l:GetName() == (k .. "_excl_branch_round") then
                        l:Fire("SetValue", "0")
                    elseif l:GetName() == (k .. "_excl_branch_lobby") then
                        l:Fire("SetValue", "0")
                    end
                end
            end

            if team.NumPlayers(entity) ~= 0 then
                --print(k.." "..team.NumPlayers(entity))
                for _, l in ipairs(ents.GetAll()) do
                    if l:GetName() == (k .. "_excl_branch_round") then
                        l:Fire("SetValue", "1")
                    elseif l:GetName() == (k .. "_excl_branch_lobby") then
                        l:Fire("SetValue", "1")
                    end
                end
            end
        end
    end

    for k, entity in ipairs(ents.GetAll()) do
        if entity:GetName() == "colortest_relay" then
            entity:Fire("Trigger")
        end
    end
end

function GM:PlayerDisconnected(ply)
    print("A player has disconnected")
    print(ply:Name() .. " has left the server.")
    colortest()
    timer.Simple(10, allgonecheck)
end

function allgonecheck()
    print(tonumber(player.GetCount()))

    if tonumber(player.GetCount()) == 0 then
        print("Server Empty")
        endtimerstart()
    else
        print("Server Not Empty")
    end
end

function endtimerstart()
    timer.Create("endtimer", 50, 1, gamereset)
end

function allgonened()
    if timer.Exists("endtimer") then
        print("Server Reloaded")
        timer.Remove("endtimer")
    end
end

function gamereset()
    RunConsoleCommand("map", "gm_sts") -- should've done this from the beginning
end