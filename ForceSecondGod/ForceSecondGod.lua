--[[
    ForceSecondGod
    Author:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Force a second god to appear by the point of Tartarus midboss, configurable per aspect.
]]
ModUtil.Mod.Register("ForceSecondGod")

ForceSecondGod.GodKeepsakes = { -- TODO move into RCLib
    ForceZeusBoonTrait = "ZeusUpgrade",
    ForcePoseidonBoonTrait = "PoseidonUpgrade",
    ForceAphroditeBoonTrait = "AphroditeUpgrade",
    ForceArtemisBoonTrait = "ArtemisUpgrade",
    ForceDionysusBoonTrait = "DionysusUpgrade",
    ForceAthenaBoonTrait = "AthenaUpgrade",
    ForceAresBoonTrait = "AresUpgrade",
    ForceDemeterBoonTrait = "DemeterUpgrade",
}
ForceSecondGod.ForceNeeded = false
ForceSecondGod.ErebusChecked = false

function ForceSecondGod.IsGodForceNeeded( godToForce, keepsakeGod ) -- Check if a force is needed- i.e. we don't yet have the desired number of our chosen god, and have yet to force one this room
    local timesForceSeen = CurrentRun.LootTypeHistory[godToForce] or 0
    
    if godToForce == keepsakeGod and CurrentRun.RunDepthCache > 14
    or godToForce == keepsakeGod and timesForceSeen >= 2
    or godToForce ~= keepsakeGod and timesForceSeen >= 1
    or ReachedMaxGods() and timesForceSeen == 0
    then
        return false
    end
    DebugPrint({Text = "Second god is needed"})
    return true
end

function ForceSecondGod.IsGodForceEligible( room, godToForce, keepsakeGod, keepsakeCharges, previousOffers ) -- If a god force is needed, check if it is eligible for a specific door
    if room.ChosenRewardType ~= "Boon"
    or not room.IsMiniBossRoom
    or Contains( previousOffers, godToForce )
    or keepsakeCharges > 0 and not Contains( previousOffers, keepsakeGod )
    then
        return false
    end
    DebugPrint({Text = "Forcing second god..."})
    return true
end

function ForceSecondGod.GetKeepsakeCharges() -- TODO move into RCLib
    local charges = 0
    for k, data in ipairs(CurrentRun.Hero.Traits) do
        if data.Name == GameState.LastAwardTrait and data.Uses then
            charges = data.Uses
        end
    end
    return charges
end

function ForceSecondGod.CheckDoors( doors, god ) -- Iterate through doors to check if our second god has been erebus'd
    DebugPrint({ Text = "Checking if second god has been Erebus'd. Looking for "..god })
    local foundGodName = nil
    local foundGodIndex = nil
    local erebusIndex = nil

    for index, door in ipairs( doors ) do
        local room = door.Room or {}
        if room.BiomeName == "Challenge" and room.ChosenRewardType == "Boon" and room.ForceLootName == god then
            erebusIndex = index
            DebugPrint({ Text = "Found Erebus door with "..god.."!" })
        elseif room.BiomeName ~= "Challenge" and room.IsMiniBossRoom and room.ChosenRewardType == "Boon" and room.ForceLootName ~= god and not foundGodName then
            foundGodIndex = index
            foundGodName = room.ForceLootName
            DebugPrint({ Text = "Found non-Erebus door with "..foundGodName })
        end
    end

    if foundGodName and erebusIndex then
        DebugPrint({Text = "Erebus'd. Swapping "..god.." and "..foundGodName})
        doors[erebusIndex].Room.ForceLootName = foundGodName
        doors[foundGodIndex].Room.ForceLootName = god
        ForceSecondGod.RefreshDoor( doors[erebusIndex] )
        ForceSecondGod.RefreshDoor( doors[foundGodIndex] )
        ForceSecondGod.ForceNeeded = false
    end

    ForceSecondGod.ErebusChecked = true
end

function ForceSecondGod.RefreshDoor( door ) -- Remove and replace a door's icon without playing a breaking animation TODO move into RCLib
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

ModUtil.Path.Wrap( "StartRoom", function( baseFunc, currentRun, currentRoom )
    ForceSecondGod.ForceNeeded = false
    ForceSecondGod.ErebusChecked = false
    baseFunc( currentRun, currentRoom )
end, ForceSecondGod )

ModUtil.Path.Wrap( "SetupRoomReward", function( baseFunc, currentRun, room, previouslyChosenRewards, args )
    args = args or {}
    local keepsakeCharges = 0
    local keepsakeGod = ForceSecondGod.GodKeepsakes[GameState.LastAwardTrait] or nil

    if ForceSecondGod.config.Enabled and ForceSecondGod.ForceNeeded then
        CheckPreviousReward( currentRun, room, previouslyChosenRewards, args )

        local excludeLootNames = {}
        if previouslyChosenRewards ~= nil then -- Same vanilla code that prevents duplicate gods TODO move into RCLib
            for i, data in pairs( previouslyChosenRewards ) do
                if data.RewardType == "Boon" then
                    table.insert( excludeLootNames, data.ForceLootName )
                end
            end
        end
        
        if keepsakeGod then
            keepsakeCharges = ForceSecondGod.GetKeepsakeCharges()
        end

        if ForceSecondGod.IsGodForceEligible( room, ForceSecondGod.GodToForce, keepsakeGod, keepsakeCharges, excludeLootNames ) then
            room.ForceLootName = ForceSecondGod.GodToForce
            ForceSecondGod.ForceNeeded = false
        end

    end
    baseFunc( currentRun, room, previouslyChosenRewards, args )
end, ForceSecondGod )

ModUtil.Path.Wrap( "DoUnlockRoomExits", function( baseFunc, currentRun, currentRoom )
    local keepsakeGod = ForceSecondGod.GodKeepsakes[GameState.LastAwardTrait] or nil
    local currentAspect = RCLib.GetAspectName()
    ForceSecondGod.GodToForce = RCLib.EncodeBoonSet( ForceSecondGod.config.AspectSettings[currentAspect] )
    ForceSecondGod.ForceNeeded = ForceSecondGod.IsGodForceNeeded( ForceSecondGod.GodToForce, keepsakeGod )
    
    baseFunc( currentRun, currentRoom )

    if ForceSecondGod.config.Enabled and ForceSecondGod.config.PreventErebus and ForceSecondGod.ForceNeeded and not ForceSecondGod.ErebusChecked then
        local exitDoorsIPairs = CollapseTableOrdered( OfferedExitDoors )
        ForceSecondGod.CheckDoors( exitDoorsIPairs, ForceSecondGod.GodToForce )
    end
end, ForceSecondGod )
