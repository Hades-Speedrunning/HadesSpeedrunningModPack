--[[
    ForceSecondGod
    Author:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Force a second god to appear by the point of Tartarus midboss, configurable per aspect.
]]
ModUtil.Mod.Register("ForceSecondGod")

ForceSecondGod.GodKeepsakes = {
    ForceZeusBoonTrait = "ZeusUpgrade",
    ForcePoseidonBoonTrait = "PoseidonUpgrade",
    ForceAphroditeBoonTrait = "AphroditeUpgrade",
    ForceArtemisBoonTrait = "ArtemisUpgrade",
    ForceDionysusBoonTrait = "DionysusUpgrade",
    ForceAthenaBoonTrait = "AthenaUpgrade",
    ForceAresBoonTrait = "AresUpgrade",
    ForceDemeterBoonTrait = "DemeterUpgrade",
}

function ForceSecondGod.IsGodForceEligible( room, godToForce, keepsakeGod, keepsakeCharges, previousOffers )
    timesForceSeen = CurrentRun.LootTypeHistory[godToForce] or 0
    
    if room.ChosenRewardType ~= "Boon"
    or not room.IsMiniBossRoom
    or Contains( previousOffers, godToForce )
    or keepsakeCharges > 0 and not Contains( previousOffers, keepsakeGod )
    or godToForce == keepsakeGod and CurrentRun.RunDepthCache > 14
    or godToForce == keepsakeGod and timesForceSeen >= 2
    or godToForce ~= keepsakeGod and timesForceSeen >= 1
    or ReachedMaxGods() and timesForceSeen == 0
    then
        return false
    end
    DebugPrint({Text = "Forcing second god..."})
    return true
end

ModUtil.Path.Wrap( "SetupRoomReward", function( baseFunc, currentRun, room, previouslyChosenRewards, args )
    args = args or {}

    CheckPreviousReward( currentRun, room, previouslyChosenRewards, args )

    local currentAspect = RCLib.GetAspectName()
    local godToForce = RCLib.EncodeBoonSet(ForceSecondGod.config.AspectSettings[currentAspect])

    local excludeLootNames = {}
    if previouslyChosenRewards ~= nil then -- Same vanilla code that prevents duplicate gods
        for i, data in pairs( previouslyChosenRewards ) do
            if data.RewardType == "Boon" then
                table.insert( excludeLootNames, data.ForceLootName )
            end
        end
    end
    
    local keepsakeCharges = 0
    local keepsakeGod = ForceSecondGod.GodKeepsakes[GameState.LastAwardTrait] or nil
    if keepsakeGod then
        for k, data in ipairs(CurrentRun.Hero.Traits) do
            if data.Name == GameState.LastAwardTrait and data.Uses then
                keepsakeCharges = data.Uses
            end
        end
    end

    if ForceSecondGod.IsGodForceEligible( room, godToForce, keepsakeGod, keepsakeCharges, excludeLootNames ) then
        room.ForceLootName = godToForce
    end

    baseFunc( currentRun, room, previouslyChosenRewards, args )
end, ForceSecondGod)

