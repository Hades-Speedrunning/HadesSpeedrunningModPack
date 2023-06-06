--[[
    TileControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Simple mod to create banlists of tiles for each biome.
]]
ModUtil.Mod.Register("TileControl")

local config = {
    Enabled = false,
    TileSetting = "Vanilla",
    BanChaos = false,
}
TileControl.config = config

TileControl.Presets = { -- List which tiles to ban
    Vanilla = {},
    NoSkips = {
        A_Reprieve01 = true,
        A_Story01 = true,
        B_Reprieve01 = true,
        B_Story01 = true,
        C_Reprieve01 = true,
        C_Story01 = true,
    },
    NoSkipsNoShops = {
        A_Shop01 = true,
        A_Reprieve01 = true,
        A_Story01 = true,
        B_Shop01 = true,
        B_Reprieve01 = true,
        B_Story01 = true,
        C_Shop01 = true,
        C_Reprieve01 = true,
        C_Story01 = true,
    },
    Hypermodded = {
        A_Combat13 = true,
        B_Combat11 = true,
        C_Combat06 = true,
    },
}

ModUtil.Path.Wrap( "IsRoomEligible", function( baseFunc, currentRun, currentRoom, nextRoomData, args )
    args = args or {}
    local setting = TileControl.config.TileSetting or "Vanilla"
    local banlist = TileControl.Presets[setting] or {}

    if banlist[nextRoomData.Name] then
        DebugPrint({Text = nextRoomData.Name.." is banned"})
        return false
    end

    return baseFunc( currentRun, currentRoom, nextRoomData, args )
end, TileControl)

ModUtil.Path.Wrap( "IsSecretDoorEligible", function( baseFunc, ... )
    if TileControl.config.BanChaos then
        return false
    end

    return baseFunc( ... )
end, TileControl)