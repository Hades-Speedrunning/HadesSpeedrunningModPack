--[[
    RacingStartSelector
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Add the option to force chamber 1 to contain either an epic boon or a hammer, configurable.
]]
ModUtil.Mod.Register("RacingStartSelector")

local config = {
    ChosenStart = "EpicBoon"
}
RacingStartSelector.config = config
RacingStartSelector.EpicGivenFlag = false
RacingStartSelector.FirstBoonRarityOverride = {
    Rare = 0,
    Epic = 1.0,
    Heroic = 0,
    Legendary = 0,
}

ModUtil.Path.Wrap( "StartNewRun", function ( baseFunc, currentRun )
	RacingStartSelector.EpicGivenFlag = false
    return baseFunc(currentRun)
end, RacingStartSelector)

ModUtil.Path.Wrap( "ChooseRoomReward", function( baseFunc, run, room, rewardStoreName, previouslyChosenRewards, args )
    local vanillaReward = baseFunc( run, room, rewardStoreName, previouslyChosenRewards, args )
    local rewardToUse = nil

    if room.Name ~= "RoomOpening" then
        DebugPrint({Text = "This is not c1, so a forced reward is not needed"})
		return vanillaReward
	end
    if RacingStartSelector.config.ChosenStart == "Hammer" then
		rewardToUse = "WeaponUpgrade"
	else
		rewardToUse = "Boon"
    end

    return rewardToUse
end, RacingStartSelector )

ModUtil.Path.Wrap( "SetTraitsOnLoot", function( baseFunc, lootData, args )
	args = args or {}
    local epicForceNeeded = true

    if CurrentRun.CurrentRoom.Name ~= "RoomOpening"
    or RacingStartSelector.config.ChosenStart ~= "EpicBoon"
    or RacingStartSelector.EpicGivenFlag then
        epicForceNeeded = false
	end

    if epicForceNeeded then
        DebugPrint({Text = "An epic boon is needed; Overriding rarity"})
        lootData.OverriddenRarityChances = lootData.RarityChances
        lootData.RarityChances = RacingStartSelector.FirstBoonRarityOverride
    elseif lootData.OverriddenRarityChances then
        DebugPrint({Text = "An epic boon is not needed; Resetting rarity to normal"})
        lootData.RarityChances = lootData.OverriddenRarityChances
    end
    return baseFunc( lootData, args )
end, RacingStartSelector )
