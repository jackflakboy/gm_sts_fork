include("teamsetup.lua")

-- Server side: listens to the "RequestPoints" message and responds with "SyncPoints"
if SERVER then
    util.AddNetworkString("SyncPoints")

    local function PointsRequest(length, client)
        -- Get the team of the player who sent the request
        local playerTeam = client:Team()
        -- Respond to the client's request
        net.Start("SyncPoints")
        net.WriteInt(teams[playerTeam].points, 32) -- Send the current points of the player's team
        net.Send(client) -- Only send to the client that made the request
    end

    net.Receive("RequestPoints", PointsRequest)
end

-- Client side: updating the points when receiving the "SyncPoints" message from the server
if CLIENT then
    local function UpdatePoints(len)
        points = net.ReadInt(32) -- Updating the points variable with the value sent from the server
    end

    net.Receive("SyncPoints", UpdatePoints)
end

-- Server side: function to periodically send the current points to the members of each team
if SERVER then
    function SendPointsToTeamMembers(teamIndex)
        local teamMembers = team.GetPlayers(teamIndex) -- This function should return a table with all the players of the team

        for _, player in ipairs(teamMembers) do
            net.Start("SyncPoints")
            net.WriteInt(teams[teamIndex].points, 32) -- Sending points to the player, using 32 bits to encode it
            net.Send(player) -- Sends the message to the player
        end
    end

    -- Synchronizing points to team members every 10 seconds, will be removed when no longer needed.
    timer.Create("PointsSyncTimer", 10, 0, function()
        for teamIndex = 1, 4 do
            SendPointsToTeamMembers(teamIndex)
        end
    end)
end

if SERVER then
    util.AddNetworkString("SendBoxInfo")

    function SendBoxInfoToPlayer(player, box)
        net.start("SendBoxInfo")
        net.WriteString(box.mob)
        net.WriteInt(box.rarity)
        net.WriteInt(box.strength)
        net.WriteInt(box.level)
        net.send(player)
    end
end

if SERVER then
    util.AddNetworkString("SendGameStartInfo")

    function SendGameStartInfoToPlayer(player, rounds, startPoints)
    end
end