--[[
    DontGetErebusd
    Author:
        SleepSoul (Discord: SleepSoul#6006)

    Disable "getting Erebus'd"- a forced god appearing on an Erebus door instead of on a main door.
]]
ModUtil.Mod.Register("DontGetErebusd")

DontGetErebusd.GodKeepsakes = {
    ForceZeusBoonTrait = "ZeusUpgrade",
    ForcePoseidonBoonTrait = "PoseidonUpgrade",
    ForceAphroditeBoonTrait = "AphroditeUpgrade",
    ForceArtemisBoonTrait = "ArtemisUpgrade",
    ForceDionysusBoonTrait = "DionysusUpgrade",
    ForceAthenaBoonTrait = "AthenaUpgrade",
    ForceAresBoonTrait = "AresUpgrade",
    ForceDemeterBoonTrait = "DemeterUpgrade",
}

local config = {
    Enabled = true,
}
DontGetErebusd.config = config
DontGetErebusd.CurrentDoors = {}
DontGetErebusd.ErebusFound = false

function DontGetErebusd.CheckDoors( doors, god )
    DebugPrint({ Text = "Checking if Erebus'd. Looking for "..god })
    local foundGodName = nil
    local foundGodIndex = nil
    local erebusIndex = nil

    for index, door in ipairs( doors ) do
        local room = door.Room
        if room.BiomeName == "Challenge" and room.ChosenRewardType == "Boon" and room.ForceLootName == god then
            foundErebus = true
            erebusIndex = index
            DebugPrint({ Text = "Found Erebus door with "..god.."!" })
        elseif room.BiomeName ~= "Challenge" and room.ChosenRewardType == "Boon" and room.ForceLootName ~= god and not foundGodName then
            foundGodIndex = index
            foundGodName = room.ForceLootName
            DebugPrint({ Text = "Found non-Erebus door with "..foundGodName })
        end
    end

    if foundGodName and erebusIndex then
        DebugPrint({Text = "Erebus'd. Swapping "..god.." and "..foundGodName})
        doors[erebusIndex].Room.ForceLootName = foundGodName
        doors[foundGodIndex].Room.ForceLootName = god
        DontGetErebusd.RefreshDoor( doors[erebusIndex] )
        DontGetErebusd.RefreshDoor( doors[foundGodIndex] )
    end
end

function DontGetErebusd.RefreshDoor( door ) -- Remove and replace a door's icon without playing a breaking animation
    if door.DoorIconId ~= nil then
        SetAlpha({ Id = door.DoorIconId, Fraction = 0, Duration = 0.1 })
        RemoveFromGroup({ Name = "Standing", Id =  door.DoorIconFront })
        AddToGroup({ Name = "FX_Standing", Id = door.DoorIconFront, DrawGroup = true })
        StopAnimation({ Names = { "RoomRewardAvailableRareSparkles", "RoomRewardAvailableGlow", "RoomRewardStreaks" }, DestinationId = door.DoorIconFront })
    end
    if door.AdditionalIcons ~= nil and not IsEmpty( door.AdditionalIcons ) then
        SetAlpha({ Ids = door.AdditionalIcons, Fraction = 0, Duration = 0.1 })
        door.AdditionalIcons = nil
    end
    CreateDoorRewardPreview( door )
end

ModUtil.Path.Wrap("DoUnlockRoomExits", function( baseFunc, run, room )
    baseFunc( run, room )

    if DontGetErebusd.config.Enabled then

        local keepsakeCharges = 0
        local keepsakeGod = DontGetErebusd.GodKeepsakes[GameState.LastAwardTrait] or nil
        if keepsakeGod then
            for k, data in ipairs( CurrentRun.Hero.Traits ) do
                if data.Name == GameState.LastAwardTrait and data.Uses then
                    keepsakeCharges = data.Uses
                end
            end
        end

        if keepsakeCharges > 0 then
            local exitDoorsIPairs = CollapseTableOrdered( OfferedExitDoors )
            DontGetErebusd.CheckDoors( exitDoorsIPairs, keepsakeGod )
        end
    end
end, DontGetErebusd)
