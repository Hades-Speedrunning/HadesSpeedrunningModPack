--[[
    EnemyControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Change the pool of side heads that can be chosen in the Lernie fight.
]]
ModUtil.Mod.Register("LernieControl")

local config = {
    LernieSetting = "Vanilla",
    AllowIneligibleCombos = false, -- Normally Lernie side heads cannot be the same as the side head, this overrides that. Note that the game can crash if this is not enabled and preset only contains 1 head
}
LernieControl.config = config

LernieControl.Presets = {
    Vanilla = {
        Heads = {},
    },
    NoPinkHeads = {
        Heads = {
            PinkLernieHead = false,
        },
    },
    NoBlueHeads = {
        Heads = {
            BlueLernieHead = false,
        },
    },
    NoPinkOrBlue = {
        Heads = {
            PinkLernieHead = false,
            BlueLernieHead = false,
        },
    },
}
LernieControl.VanillaSet = {}
LernieControl.VanillaEligibility = {}
LernieControl.EligibleHeads = {}

function LernieControl.ReadPreset()
    local preset = LernieControl.Presets[ LernieControl.config.LernieSetting ]
    local eligibleHeads = RCLib.RemoveIneligibleStrings( preset.Heads, LernieControl.VanillaSet, RCLib.NameToCode.Bosses )
    RCLib.PopulateMinLength( LernieControl.EligibleHeads, eligibleHeads, 2 ) -- Game crashes if there is only one head type in EnemySet
end

function LernieControl.UpdatePool()
    DebugPrint({ Text = "Lernie preset: "..LernieControl.config.LernieSetting })
    ModUtil.Table.Replace( EnemySets.HydraHeads, LernieControl.EligibleHeads )

    if LernieControl.config.AllowIneligibleCombos then
        ModUtil.Table.MergeKeyed( EncounterData.BossHydra.BlockHeadsByHydraVariant, {
			HydraHeadImmortal = {},
			HydraHeadImmortalLavamaker = {},
			HydraHeadImmortalSummoner = {},
			HydraHeadImmortalSlammer = {},
			HydraHeadImmortalWavemaker = {},
		})
    else
        ModUtil.Table.MergeKeyed( EncounterData.BossHydra.BlockHeadsByHydraVariant, LernieControl.VanillaEligibility )
    end
end

ModUtil.LoadOnce( function()
    LernieControl.VanillaSet = ModUtil.Table.Copy( EnemySets.HydraHeads )
    LernieControl.VanillaEligibility = ModUtil.Table.Copy( EncounterData.BossHydra.BlockHeadsByHydraVariant )
    LernieControl.ReadPreset()
    LernieControl.UpdatePool()
end)

-- When a new run is started, make sure to apply the pool settings
ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
    LernieControl.ReadPreset()
    LernieControl.UpdatePool()
    return baseFunc( currentRun )
end, LernieControl)
