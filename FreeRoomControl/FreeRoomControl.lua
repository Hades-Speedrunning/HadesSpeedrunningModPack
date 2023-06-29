--[[
    FreeRoomControl
    Author:
        SleepSoul (Discord: SleepSoul#6006)

    Allow limits on which, if any, free rooms can be offered together.
]]
ModUtil.Mod.Register("FreeRoomControl")

local config = {
    RemoveConflicts = true,
    ForceMidshop = "None",
    MinFreeRooms = 0,
}
FreeRoomControl.config = config
FreeRoomControl.CurrentDoors = {}
FreeRoomControl.FoundPriority = false
FreeRoomControl.CurrentRewardStore = nil
FreeRoomControl.RewardStoreData = {}
FreeRoomControl.RewardKey = nil
FreeRoomControl.DoorRewards = {}
FreeRoomControl.Biome = "Tartarus"
FreeRoomControl.FreeRoomsThisBiome = 0
FreeRoomControl.FreeRoomNeeded = false
FreeRoomControl.TimeUntilShop = nil

FreeRoomControl.IsPriorityRoom = { -- Priority rooms are to be kept in conflicts
    A_Shop01 = true,
    B_Shop01 = true,
    C_Shop01 = true,
}
FreeRoomControl.IsFreeRoom = {
    A_Shop01 = true,
    A_Reprieve01 = true,
    A_Story01 = true,
    B_Shop01 = true,
    B_Reprieve01 = true,
    B_Story01 = true,
    C_Shop01 = true,
    C_Reprieve01 = true,
    C_Story01 = true,
}
FreeRoomControl.BiomeMidshops = {
    Tartarus = "A_Shop01",
    Asphodel = "B_Shop01",
    Elysium = "C_Shop01",
}
FreeRoomControl.BiomeEndDepths = { -- The depth at which each biome forces endshop
    Tartarus = 11,
    Asphodel = 7,
    Elysium = 9,
}
FreeRoomControl.BiomeShopDepths = { 
    None = { -- Dummy setting- you can never be at biomeDepth -1, so this will just never force shop under any circumstances
        Tartarus = -1,
        Asphodel = -1,
        Elysium = -1,
        Styx = -1,
    },
    Start = { -- The lowest depth at which each biome can have its midshop
        Tartarus = 4,
        Asphodel = 3,
        Elysium = 3,
        Styx = -1,
    },
    End = { -- The highest depth at which each biome can have its midshop
        Tartarus = 9,
        Asphodel = 5,
        Elysium = 6,
        Styx = -1,
    },
}

function FreeRoomControl.CheckDoors( doors ) -- Check a table of offered doors, storing which are free/priority and returning how many free rooms are found
    local freeRoomsFound = 0
    FreeRoomControl.FoundPriority = false

    for index, door in ipairs( doors ) do
        local name = door.Room.Name
        local doorData = {}
        doorData.IsFree = FreeRoomControl.IsFreeRoom[name] or false
        doorData.IsPriority = FreeRoomControl.IsPriorityRoom[name] or false

        if doorData.IsFree then
            DebugPrint({Text = name.." is free"})
            freeRoomsFound = freeRoomsFound + 1
        end
        if doorData.IsPriority then
            DebugPrint({Text = name.." is priority"})
            FreeRoomControl.FoundPriority = true
        end
        FreeRoomControl.CurrentDoors[index] = doorData
    end
    return freeRoomsFound
end

function FreeRoomControl.ResolveConflicts( doors )
    local nonPriorityChosen = false

    for index, door in ipairs( doors ) do
        local name = door.Room.Name
        local doorData = FreeRoomControl.CurrentDoors[index]
        local needsRerolling = true

        local rewardsChosen = {}
        for index, offeredDoor in pairs( OfferedExitDoors ) do
            if offeredDoor.Room ~= nil then
                table.insert( rewardsChosen, { RewardType = offeredDoor.Room.ChosenRewardType, ForceLootName = offeredDoor.Room.ForceLootName })
            end
        end

        if not doorData.IsFree then
            needsRerolling = false
        end
        if doorData.IsPriority then
            needsRerolling = false
        end
        if doorData.IsFree and not FreeRoomControl.FoundPriority and not nonPriorityChosen then -- If there aren't any priority rooms to keep, we need to keep at least one non-priority free room
            nonPriorityChosen = true
            needsRerolling = false
        end
        if needsRerolling then
            DebugPrint({Text = "Rerolling "..name})
            CurrentRun.RoomCreations[name] = CurrentRun.RoomCreations[name] - 1 -- Mark the room as having not been seen, so it can appear again
            if FreeRoomControl.DoorRewards[index] then
                table.insert( CurrentRun.RewardStores[FreeRoomControl.CurrentRewardStore], FreeRoomControl.DoorRewards[index] ) -- Re-add a chosen reward to the bag
                FreeRoomControl.DoorRewards[index] = nil
            end

            local roomForDoorData = ChooseNextRoomData( CurrentRun, { RequiredRewardStore = FreeRoomControl.CurrentRewardStore, BanFreeRooms = true } )
            local roomForDoor = CreateRoom( roomForDoorData, { RewardStoreName = FreeRoomControl.CurrentRewardStore, PreviouslyChosenRewards = rewardsChosen } )
            door.Room = roomForDoor
            FreeRoomControl.RefreshDoorIcon( door )

            StopAnimation({ DestinationId = door.DoorIconFront, Names = { "ConsecrationBuffedFront" }, PreventChain = true }) -- Fountain visual from DoorVisualIndicators
        end
    end
end

function FreeRoomControl.RefreshDoorIcon( door ) -- Remove and replace a door's icon without playing a breaking animation
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

function FreeRoomControl.IsFreeRoomNeeded( currentRun, currentRoom ) -- Check how many free rooms we've had so far, and if we need to force one
    DebugPrint({ Text = "Current biome: " .. FreeRoomControl.Biome })
    DebugPrint({ Text = "Free rooms so far: " .. FreeRoomControl.FreeRoomsThisBiome or 0 })
    if FreeRoomControl.Biome == "Styx" then
        return false
    end
    local roomsLeft = math.max( FreeRoomControl.BiomeEndDepths[FreeRoomControl.Biome] - currentRun.BiomeDepthCache, 0 )
    local freeRoomsLeft = math.min( FreeRoomControl.config.MinFreeRooms - FreeRoomControl.FreeRoomsThisBiome, roomsLeft )

    DebugPrint({ Text =  math.max( freeRoomsLeft, 0 ).." of "..roomsLeft.." remaining rooms need to be free" })
    if roomsLeft > 0 and roomsLeft == freeRoomsLeft then
        return true
    end
    return false
end

ModUtil.Path.Wrap( "StartRoom", function( baseFunc, currentRun, currentRoom )
    if currentRoom.RoomSetName ~= "Secrets" and currentRoom.RoomSetName ~= "Base" then
        FreeRoomControl.Biome = currentRoom.RoomSetName or FreeRoomControl.Biome or "Tartarus"
    end
    if currentRun.BiomeDepthCache <= 1 then -- c1 has a biome depth of 0, but the first room of every other biome is at depth 1
        FreeRoomControl.FreeRoomsThisBiome = 0
    end
    FreeRoomControl.CurrentRewardStore = nil
    FreeRoomControl.RewardStoreData = {}
    FreeRoomControl.DoorRewards = {}
    FreeRoomControl.RewardKey = nil

    FreeRoomControl.FreeRoomNeeded = FreeRoomControl.IsFreeRoomNeeded( currentRun, currentRoom )
    local shopDepth = FreeRoomControl.BiomeShopDepths[FreeRoomControl.config.ForceMidshop][FreeRoomControl.Biome]
    FreeRoomControl.TimeUntilShop = ( shopDepth - currentRun.BiomeDepthCache ) or nil
    baseFunc( currentRun, currentRoom )
end, FreeRoomControl )

ModUtil.Path.Wrap( "StartEncounter", function( baseFunc, currentRun, currentRoom, currentEncounter )
    if currentEncounter.ObjectiveSets == "ThanatosChallenge" or currentEncounter.EncounterType == "SurvivalChallenge" then
        FreeRoomControl.FreeRoomsThisBiome = FreeRoomControl.FreeRoomsThisBiome + 1
        FreeRoomControl.FreeRoomNeeded = FreeRoomControl.IsFreeRoomNeeded( currentRun, currentRoom ) -- Adding a free room might affect whether one needs forcing, so re-check
    end
    baseFunc( currentRun, currentRoom, currentEncounter )
end, FreeRoomControl )

ModUtil.Path.Context.Wrap( "DoUnlockRoomExits", function()
    ModUtil.Path.Wrap( "ChooseRoomReward", function( baseFunc, run, room, rewardStoreName, previouslyChosenRewards, args )
        -- Create a list of the rewards chosen thus far, including their game state requirements etc. Allows returning exact copies to the bag if a door is rerolled
        if FreeRoomControl.CurrentRewardStore == nil then
            FreeRoomControl.CurrentRewardStore = rewardStoreName
        end
        FreeRoomControl.RewardStoreData = ModUtil.Table.Copy( run.RewardStores[rewardStoreName] )
        local rewardName = baseFunc( run, room, rewardStoreName, previouslyChosenRewards, args )
        local index = ModUtil.Locals.Stacked().index
        FreeRoomControl.DoorRewards[index] = FreeRoomControl.RewardStoreData[FreeRoomControl.RewardKey]
        return rewardName
    end, FreeRoomControl )
end, FreeRoomControl )

ModUtil.Path.Wrap( "DoUnlockRoomExits", function( baseFunc, run, room )
    baseFunc( run, room )
    FreeRoomControl.CurrentDoors = {}
    FreeRoomControl.FoundPriority = false
    local freeRoomsNum = 0
    local exitDoorsIPairs = CollapseTableOrdered( OfferedExitDoors )

    freeRoomsNum = FreeRoomControl.CheckDoors( exitDoorsIPairs )
    if freeRoomsNum > 1 and FreeRoomControl.config.RemoveConflicts then
        FreeRoomControl.FreeRoomsThisBiome = FreeRoomControl.FreeRoomsThisBiome + 1
        DebugPrint({Text = "Free room conflict! Resolving..."})
        FreeRoomControl.ResolveConflicts( exitDoorsIPairs )
    else
        FreeRoomControl.FreeRoomsThisBiome = FreeRoomControl.FreeRoomsThisBiome + freeRoomsNum
    end
end, FreeRoomControl )

ModUtil.Path.Context.Wrap( "ChooseRoomReward", function()
    ModUtil.Path.Wrap( "GetRandomValue", function( baseFunc, tableArg, rng )
        FreeRoomControl.RewardKey = baseFunc( tableArg, rng )
        return FreeRoomControl.RewardKey
    end, FreeRoomControl)
end, FreeRoomControl)

ModUtil.Path.Wrap( "IsRoomEligible", function( baseFunc, currentRun, currentRoom, nextRoomData, args )
    args = args or {}
    if args.BanFreeRooms and FreeRoomControl.IsFreeRoom[nextRoomData.Name] then
        return false
    end
    if args.RequiredRewardStore and nextRoomData.ForcedRewardStore and args.RequiredRewardStore ~= nextRoomData.ForcedRewardStore then
        -- If we're rerolling a conflict, we've already chosen a reward store. We can't use any rooms that, had they been chosen the first time, would've forced a different reward store
        return false
    end
    if nextRoomData.Name ~= FreeRoomControl.BiomeMidshops[FreeRoomControl.Biome] and ( nextRoomData.NumExits or 0 ) < 2 and FreeRoomControl.TimeUntilShop == 1 then
        return false
    end
    return baseFunc( currentRun, currentRoom, nextRoomData, args )
end, FreeRoomControl )

ModUtil.Path.Wrap( "IsRoomForced", function( baseFunc, currentRun, currentRoom, nextRoomData, args )
    args = args or {}
    if nextRoomData.Name == FreeRoomControl.BiomeMidshops[FreeRoomControl.Biome] and FreeRoomControl.TimeUntilShop == 0 then
        return true
    end
    return baseFunc( currentRun, currentRoom, nextRoomData, args )
end, FreeRoomControl )

ModUtil.Path.Override( "ChooseNextRoomData", function( currentRun, args ) -- Override is how we force free rooms. Alternative is wrapping IsRoomForced, but that causes illegal behaviour wrt rooms already forced in vanilla. This is less clean but maintains legal behaviour
    args = args or {}

    local currentRoom = currentRun.CurrentRoom
    local roomSetName = currentRun.CurrentRoom.RoomSetName or "Tartarus"
    if args.ForceNextRoomSet ~= nil then
        roomSetName = args.ForceNextRoomSet
    elseif currentRoom.NextRoomSet ~= nil then
        roomSetName = GetRandomValue( currentRoom.NextRoomSet )
    elseif currentRoom.UsePreviousRoomSet then
        local previousRoom = GetPreviousRoom(currentRun) or currentRoom
        roomSetName = previousRoom.RoomSetName or "Tartarus"
    elseif currentRoom.NextRoomSetNoGenerate ~= nil then
        roomSetName = GetRandomValue( currentRoom.NextRoomSetNoGenerate )
    end

    local roomDataSet = args.RoomDataSet or RoomSetData[roomSetName]
    local nextRoomData = nil
    if ForceNextRoom ~= nil and RoomData[ForceNextRoom] ~= nil then
        nextRoomData = RoomData[ForceNextRoom]
    elseif args.ForceNextRoom ~= nil and RoomData[args.ForceNextRoom] ~= nil then
        nextRoomData = RoomData[args.ForceNextRoom]
    elseif currentRoom.LinkedRoom ~= nil or currentRoom.LinkedRooms ~= nil or currentRoom.LinkedRoomByPactLevel then
        local nextRoomName = currentRoom.LinkedRoom
        if currentRoom.LinkedRooms ~= nil then
            local eligibleRoomNames = {}
            local forcedRoomNames = {}
            for i, linkedRoomName in ipairs( CollapseTableOrdered( currentRoom.LinkedRooms ) ) do
                if IsRoomEligible( currentRun, currentRoom, roomDataSet[linkedRoomName], args ) then
                    table.insert( eligibleRoomNames, linkedRoomName )
                    if IsRoomForced( currentRun, currentRoom, roomDataSet[linkedRoomName], args ) then
                        table.insert( forcedRoomNames, linkedRoomName )
                    end
                end
            end
            if not IsEmpty( forcedRoomNames ) then
                nextRoomName = GetRandomValue( forcedRoomNames )
            else
                nextRoomName = GetRandomValue( eligibleRoomNames )
            end
        elseif currentRoom.LinkedRoomByPactLevel then
            local shrineLevel = GetNumMetaUpgrades( currentRoom.ShrineMetaUpgradeName )
            nextRoomName = currentRoom.LinkedRoomByPactLevel[shrineLevel]
        end

        if nextRoomName ~= nil then
            nextRoomData = roomDataSet[nextRoomName]
        end
    end

    if nextRoomData == nil then
        local eligibleRooms = {}
        local forcedRooms = {}
        -- CHANGES MADE HERE
        local freeRooms = {}
        for i, kvp in ipairs( CollapseTableAsOrderedKeyValuePairs( roomDataSet ) ) do
            local roomName = kvp.Key
            local roomData = kvp.Value
            if IsRoomEligible( currentRun, currentRoom, roomData, args ) then
                table.insert( eligibleRooms, roomData )
                if FreeRoomControl.IsFreeRoom[roomName] then
                    table.insert( freeRooms, roomData )
                end
                if IsRoomForced( currentRun, currentRoom, roomData, args ) then
                    table.insert( forcedRooms, roomData )
                end
            end
        end
        if not IsEmpty( forcedRooms ) then
            nextRoomData = GetRandomValue( forcedRooms )
        elseif FreeRoomControl.FreeRoomNeeded and not IsEmpty( freeRooms ) then
            nextRoomData = GetRandomValue( freeRooms )
            DebugPrint({ Text = "Choosing "..nextRoomData.Name.." as free room"})
        else
            nextRoomData = GetRandomValue( eligibleRooms )
        end
    end

    DebugAssert({ Condition = nextRoomData ~= nil, Text = "No eligible rooms for exit door!"  })
    if nextRoomData and nextRoomData.Name and FreeRoomControl.IsFreeRoom[nextRoomData.Name] then
        FreeRoomControl.FreeRoomNeeded = false
    end
    -- END CHANGES
    return nextRoomData

end, FreeRoomControl )
