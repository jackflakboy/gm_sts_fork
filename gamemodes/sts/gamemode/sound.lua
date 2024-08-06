LoadedSounds = LoadedSounds or {}

mainTrack = mainTrack or nil
mainTrackSound = 1

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
            LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
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


function beginPlayingMainTrack()
    if not mainTrack then  -- Only create a new mainTrack if it does not already exist
        mainTrack = playGlobalSound("bm_sts_sounds/miami_sky_hq.wav")
        if mainTrackSound == 0 then
            mainTrack:ChangeVolume(0, 0)
        end
        -- Setting up the timer to restart the sound track
        timer.Create("RepeatTrack", 103, 0, function()
            mainTrack:Stop()  -- Stop the current track
            mainTrack:Play()  -- Play the track again
            if mainTrackSound == 0 then
                mainTrack:ChangeVolume(0, 0)
            end
        end)
    end
end

function muteMainTrack()
    mainTrackSound = 0
    if mainTrack then
        mainTrack:ChangeVolume(0, 2)
    end
end

function unmuteMainTrack()
    mainTrackSound = 1
    if mainTrack then
        mainTrack:ChangeVolume(1, 2)
    end
end