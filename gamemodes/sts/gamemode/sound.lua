local LoadedSounds
if CLIENT then
    LoadedSounds = {} -- this table caches existing CSoundPatches
end

function playGlobalSound( FileName, teamID )
    local sound
    local filter
    teamID = teamID or -1
    if SERVER then
        filter = RecipientFilter()
        if teamID == -1 then
            filter:AddAllPlayers()
        else
            filter:AddRecipientsByTeam( teamID )
        end
    end
    if SERVER or LoadedSounds[FileName] == nil then
        -- The sound is always re-created serverside because of the RecipientFilter.
        sound = CreateSound( game.GetWorld(), FileName, filter ) -- create the new sound, parented to the worldspawn (which always exists)
        if sound then
            sound:SetSoundLevel( 0 ) -- play everywhere
            if CLIENT then
                LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
            end
        end
    else
        sound = LoadedSounds[FileName][1]
        filter = LoadedSounds[FileName][2]
    end
    if sound then
        if CLIENT then
            sound:Stop() -- it won't play again otherwise
        end
        sound:Play()
    end
    return sound -- useful if you want to stop the sound yourself
end