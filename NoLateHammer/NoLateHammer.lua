--[[
    NoLateHammer
    Author:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Force a specified reward (per-aspect) to always be offered in a set shop.
]]
ModUtil.Mod.Register( "NoLateHammer" )

ModUtil.Path.Wrap( "FillInShopOptions", function( baseFunc, args )
    local store = baseFunc( args )
    local aspect = RCLib.GetAspectName()
    local reward = RCLib.EncodeShopReward( NoLateHammer.config.AspectSettings[aspect] )

    if NoLateHammer.config.Enabled
    and CurrentRun.CurrentRoom.Name == NoLateHammer.config.ShopToUse
    and ( StoreItemEligible( ConsumableData[reward], args ) or not NoLateHammer.config.CheckEligibility ) then
        store.StoreOptions[3] = { Name = reward, Type = "Consumable" }
    end

    return store
end, NoLateHammer )
