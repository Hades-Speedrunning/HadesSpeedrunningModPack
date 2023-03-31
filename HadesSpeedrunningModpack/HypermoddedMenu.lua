HypermoddedMenu = {
  UIComponents = {},
  Keys = {
    SecondGodDropdown = "SecondGodDropdown",
    WeaponListDropdown = "WeaponListDropdown",
    AspectListDropdown = "AspectListDropdown",
    HermesDropdown = "HermesDropdown",
    FirstHammerDropdown = "FirstHammerDropdown",
    SecondHammerDropdown = "SecondHammerDropdown",
  },
  CurrentAspect = nil,
  CurrentWeapon = nil,
}

SaveIgnores["HypermoddedMenu"] = true

function HSMConfigMenu.CreateHypermoddedMenu( screen )
  local rowStartX = 250
  local rowStartY = 300
  local itemLocationX = rowStartX
  local itemLocationY = rowStartY
  local itemSpacingX = 250
  local itemSpacingY = 65

  -----------------
  -- Chaos control settings
  -----------------
  screen.Components["ChaosSettingsTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
  })
  CreateTextBox({
      Id = screen.Components["ChaosSettingsTextBox"].Id,
      Text = "Chaos Settings: ",
      Color = Color.BoonPatchCommon,
      FontSize = 16,
      OffsetX = 0, OffsetY = 0,
      Font = "AlegrayaSansSCRegular",
      ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
      Justification = "Left",
      Group = "Combat_Menu"
  })

  local initialChaosSetting = ChaosControl.config.ChaosSetting
  local chaosDropdownOptions = {["Default"] = {
      event = function(dropdown)
          ChaosControl.config.ChaosSetting = initialChaosSetting
      end,
      Text = initialChaosSetting,
    }}
    for k, v in pairs(ChaosControl.Presets) do
      table.insert(chaosDropdownOptions,
        {
          event = function(dropdown)
              ChaosControl.config.ChaosSetting = k
          end,
          Text = k
        })
    end
  
  ErumiUILib.Dropdown.CreateDropdown(screen, {
      Name = "ChaosDropdown",
      Group = "Combat_Menu",  
      Scale = {X = .25, Y = .5},
      Padding = {X = 0, Y = 2},
      X = itemLocationX + itemSpacingX * 2, Y = itemLocationY,
      GeneralFontSize = 16,
      Font = "AlegrayaSansSCRegular",
      Items = chaosDropdownOptions
  })
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- DarknessDenied settings
  -----------------
  -- title
  screen.Components["DarknessDeniedTitleTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["DarknessDeniedTitleTextBox"].Id,
    Text = "Hades's Moveset Options ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  itemLocationY = itemLocationY + itemSpacingY * 0.5

  -- all darkness
  screen.Components["DarknessDeniedAllTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["DarknessDeniedAllTextBox"].Id,
    Text = "Remove All Darknesses:",
    Color = Color.BoonPatchCommon,
    FontSize = 12,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["DarknessDeniedAllCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 2,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["DarknessDeniedAllCheckBox"].Config = "DarknessDenied.config.RemoveDarkness"
  screen.Components["DarknessDeniedAllCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["DarknessDeniedAllCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY * 0.5

  -- insta-darkness
  screen.Components["DarknessDeniedInstantTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["DarknessDeniedInstantTextBox"].Id,
    Text = "Remove Only Insta-Darknesses:",
    Color = Color.BoonPatchCommon,
    FontSize = 12,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["DarknessDeniedInstantEnabledBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 2,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["DarknessDeniedInstantEnabledBox"].Config = "DarknessDenied.config.RemoveInstadarkness"
  screen.Components["DarknessDeniedInstantEnabledBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["DarknessDeniedInstantEnabledBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- EnemyControl settings
  -----------------
  screen.Components["EnemySettingsTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
  })
  CreateTextBox({
      Id = screen.Components["EnemySettingsTextBox"].Id,
      Text = "Enemy Settings: ",
      Color = Color.BoonPatchCommon,
      FontSize = 16,
      OffsetX = 0, OffsetY = 0,
      Font = "AlegrayaSansSCRegular",
      ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
      Justification = "Left"
  })

  local initialEnemyControlSetting = EnemyControl.config.EnemySetting
  local enemyControlOptions = {["Default"] = {
      event = function(dropdown)
          EnemyControl.config.EnemySetting = initialEnemyControlSetting
      end,
      Text = initialEnemyControlSetting,
    }}
    for k, v in pairs(EnemyControl.Presets) do
      table.insert(enemyControlOptions,
        {
          event = function(dropdown)
              EnemyControl.config.EnemySetting = k
          end,
          Text = k
        })
    end
  
  ErumiUILib.Dropdown.CreateDropdown(screen, {
      Name = "EnemyControlDropDown",
      Group = "Combat_Menu",  
      Scale = {X = .25, Y = .5},
      Padding = {X = 0, Y = 2},
      X = itemLocationX + itemSpacingX * 2, Y = itemLocationY,
      GeneralFontSize = 16,
      Font = "AlegrayaSansSCRegular",
      Items = enemyControlOptions
  })
  itemLocationY = itemLocationY + itemSpacingY


  -----------------
  -- ForceSecondGod settings
  -----------------
  screen.Components["ForceSecondGodEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["ForceSecondGodEnabledTextBox"].Id,
    Text = "Enable Choice of Second God:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["ForceSecondGodEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 2,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["ForceSecondGodEnabledCheckbox"].Config = "ForceSecondGod.config.Enabled"
  screen.Components["ForceSecondGodEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["ForceSecondGodEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY * 0.5
  screen.Components["ForceSecondGodNoteTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["ForceSecondGodNoteTextBox"].Id,
    Text = "(select Gods by aspect on next page)",
    Color = Color.BoonPatchCommon,
    FontSize = 12,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  itemLocationY = itemLocationY + itemSpacingY

-----------------
-- FreeRoomControl settings
-----------------
screen.Components["FreeRoomControlEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["FreeRoomControlEnabledTextBox"].Id,
    Text = "Prevent Free Room Conflicts:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["FreeRoomControlEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 2,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["FreeRoomControlEnabledCheckbox"].Config = "FreeRoomControl.config.Enabled"
  screen.Components["FreeRoomControlEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["FreeRoomControlEnabledCheckbox"])

  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- SatyrSackControl short tunnel settings
  -----------------
  screen.Components["SatyrSackControlShortTunnelEnabledTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
    })
    CreateTextBox({
      Id = screen.Components["SatyrSackControlShortTunnelEnabledTextBox"].Id,
      Text = "Force Short Tunnels in Styx:",
      Color = Color.BoonPatchCommon,
      FontSize = 16,
      OffsetX = 0, OffsetY = 0,
      Font = "AlegrayaSansSCRegular",
      ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
      Justification = "Left"
    })
    
    screen.Components["SatyrSackControlShortTunnelEnabledCheckbox"] = CreateScreenComponent({
      Name = "RadioButton",
      Scale = 1,
      X = itemLocationX + itemSpacingX * 2,
      Y = itemLocationY,
      Group = "Combat_Menu"
    })
    screen.Components["SatyrSackControlShortTunnelEnabledCheckbox"].Config = "SatyrSackControl.config.ForceShortTunnels"
    screen.Components["SatyrSackControlShortTunnelEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
    HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["SatyrSackControlShortTunnelEnabledCheckbox"])

    itemLocationY = itemLocationY + itemSpacingY
  -----------------
  -- WellControl settings
  -----------------
  screen.Components["WellControlSettingsTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
  })
  CreateTextBox({
      Id = screen.Components["WellControlSettingsTextBox"].Id,
      Text = "Well Settings: ",
      Color = Color.BoonPatchCommon,
      FontSize = 16,
      OffsetX = 0, OffsetY = 0,
      Font = "AlegrayaSansSCRegular",
      ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
      Justification = "Left"
  })

  local initialWellControlOptions = WellControl.config.WellSetting
  local wellControlOptions = {["Default"] = {
      event = function(dropdown)
          WellControl.config.WellSetting = initialWellControlOptions
      end,
      Text = initialWellControlOptions,
    }}
    for k, v in pairs(WellControl.Presets) do
      table.insert(wellControlOptions,
        {
          event = function(dropdown)
              WellControl.config.WellSetting = k
          end,
          Text = k
        })
    end
  
  ErumiUILib.Dropdown.CreateDropdown(screen, {
      Name = "WellControlDropDown",
      Group = "Combat_Menu",  
      Scale = {X = .25, Y = .5},
      Padding = {X = 0, Y = 2},
      X = itemLocationX + itemSpacingX * 2, Y = itemLocationY,
      GeneralFontSize = 16,
      Font = "AlegrayaSansSCRegular",
      Items = wellControlOptions
  })
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- BoonControl global enabled setting
  -----------------
  screen.Components["BoonControlEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["BoonControlEnabledTextBox"].Id,
    Text = "Enable advanced boon control:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["BoonControlEnabledCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 2,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["BoonControlEnabledCheckBox"].Config = "BoonControl.config.Enabled"
  screen.Components["BoonControlEnabledCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["BoonControlEnabledCheckBox"])

  itemLocationY = itemLocationY + itemSpacingY
  itemLocationX = itemLocationX + itemSpacingX * 3

  -------------------------------------
  -- SECOND ROW (BoonControl config) --
  -------------------------------------
  itemLocationY = rowStartY
  -----------------
  -- BoonControl.config.AllowHermesControl
  -----------------
  screen.Components["HermesControlEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["HermesControlEnabledTextBox"].Id,
    Text = "Enable control of Hermes:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["HermesControlControlEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 3,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["HermesControlControlEnabledCheckbox"].Config = "BoonControl.config.AllowHermesControl"
  screen.Components["HermesControlControlEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["HermesControlControlEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY
  -----------------
  -- BoonControl.config.AllowOlympianControl
  -----------------
  screen.Components["OlympianControlEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["OlympianControlEnabledTextBox"].Id,
    Text = "Enable control of other Olympians:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["OlympianControlEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 3,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["OlympianControlEnabledCheckbox"].Config = "BoonControl.config.AllowOlympianControl"
  screen.Components["OlympianControlEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["OlympianControlEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- BoonControl.config.AllowHammerControl
  -----------------
  
  screen.Components["HammerControlTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["HammerControlTextBox"].Id,
    Text = "Select number of hammers to control:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  local originalHammerValue = BoonControl.config.AllowedHammerControl
  local textTable = { 
    [0] = "None",
    [1] = "One Hammer",
    [2] = "Both Hammers"
  }
  local hammerOptions = {
    Default = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = originalHammerValue
      end,
      Text = textTable[originalHammerValue]
    },
    [1] = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = 0
      end,
      Text = "None"
    },
    [2] = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = 1
      end,
      Text = "One Hammer"
    },
    [3] = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = 2
      end,
      Text = "Both Hammers"
    },
  }

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "HammerControlDropdown",
    Group = "Combat_Menu",  
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX * 3, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = hammerOptions,
  })
  itemLocationY = itemLocationY + itemSpacingY
  

  -----------------
  -- BoonControl.config.AllowRarityForce
  -----------------
  screen.Components["AllowRarityForceEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["AllowRarityForceEnabledTextBox"].Id,
    Text = "Enable for always-epic Hermes:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  -- TODO: add note about all rarity force config possibilities but not leaderboard legal
  
  screen.Components["AllowRarityForceEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 3,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["AllowRarityForceEnabledCheckbox"].Config = "BoonControl.config.AllowRarityForce"
  screen.Components["AllowRarityForceEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["AllowRarityForceEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- BoonControl.config.FirstBoonAlwaysEpic/FirstBoonEpicOnPride
  -----------------
  
  screen.Components["RarityControlTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["RarityControlTextBox"].Id,
    Text = "Select first boon rarity settings:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  -- setup firstBoon default options and text based on existing config
  local firstBoonAlwaysEpicSetting = BoonControl.config.FirstBoonAlwaysEpic
  local firstBoonEpicOnPrideSetting = BoonControl.config.FirstBoonEpicOnPride

  local firstBoonSettingText = "Select an option"
  if BoonControl.config.FirstBoonAlwaysEpic == false and
    BoonControl.config.FirstBoonEpicOnPride == false then
      firstBoonSettingText = "Vanilla"
  elseif BoonControl.config.FirstBoonAlwaysEpic == false and
    BoonControl.config.FirstBoonEpicOnPride == true then
      firstBoonSettingText = "Epic on God's Pride"
  elseif BoonControl.config.FirstBoonAlwaysEpic == true and
    BoonControl.config.FirstBoonEpicOnPride == true then
      firstBoonSettingText = "Always Epic"
  end

  local rarityOptions = {
    Default = {
      event = function ()
        BoonControl.config.FirstBoonAlwaysEpic = firstBoonAlwaysEpicSetting
        BoonControl.config.FirstBoonEpicOnPride = firstBoonEpicOnPrideSetting
      end,
      Text = firstBoonSettingText
    },
    [1] = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = false
        BoonControl.config.FirstBoonEpicOnPride = false
      end,
      Text = "Vanilla"
    },
    [2] = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = false
        BoonControl.config.FirstBoonEpicOnPride = true
      end,
      Text = "Epic on God's Pride"
    },
    [3] = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = true
        BoonControl.config.FirstBoonEpicOnPride = true
      end,
      Text = "Always Epic"
    },
  }

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "RarityControlDropdown",
    Group = "Combat_Menu",  
    Scale = {X = .35, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX * 3, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = rarityOptions,
  })
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- WaveControl
  -----------------
  screen.Components["WaveControlTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["WaveControlTextBox"].Id,
    Text = "Wave Settings:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  local waveValue = WaveControl.config.WaveSettings
  local waveTable = {
    Vanilla = "Vanilla",
    No3Wave = "No 3 Waves",
    NoTart3Wave = "No 3 Waves in Tart",
    Only1Wave = "1 Wave Only"
  }
  local waveOptions = {
    Default = {
      event = function (dropdown)
        WaveControl.config.WaveSettings = waveValue
      end,
      Text = waveTable[waveValue]
    },
    [1] = {
      event = function (dropdown)
        WaveControl.config.WaveSettings = "Vanilla"
      end,
      Text = "Vanilla"
    },
    [2] = {
      event = function (dropdown)
        WaveControl.config.WaveSettings = "No3Wave"
      end,
      Text = "No 3 Waves"
    },
    [3] = {
      event = function (dropdown)
        WaveControl.config.WaveSettings = "NoTart3Wave"
      end,
      Text = "No 3 Waves in Tart"
    },
    [4] = {
      event = function (dropdown)
        WaveControl.config.WaveSettings = "Only1Wave"
      end,
      Text = "1 Wave Only"
    }
  }
  
  ErumiUILib.Dropdown.CreateDropdown(screen, {
      Name = "WaveControlDropDown",
      Group = "Combat_Menu",  
      Scale = {X = .3, Y = .5},
      Padding = {X = 0, Y = 2},
      X = itemLocationX + itemSpacingX * 3, Y = itemLocationY,
      GeneralFontSize = 16,
      Font = "AlegrayaSansSCRegular",
      Items = waveOptions
  })
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["SleepSaysThanks"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["SleepSaysThanks"].Id,
    Text = "Thank you Zyru, and thank you everyone.\\n I love you all. - Sleep",
    Color = Color.Gray,
    FontSize = 14,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
end

function CreateSecondGodPicker( screen, aspect, xpos, ypos)
  DebugPrint{ Text = (aspect or "nil") .. " in CreateSecondGodPicker" .. ypos .. " " .. xpos}
  local gods = BoonControl.BoonGods
  local defaultGod = ForceSecondGod.config.AspectSettings[aspect]
  local godOptions = {["Default"] = {
    event = function(dropdown)
      ForceSecondGod.config.AspectSettings[aspect] = defaultGod
    end,
    Text = defaultGod,
  }}
  for i, god in pairs(gods) do
    table.insert(godOptions,
      {
        event = function(dropdown)
            ForceSecondGod.config.AspectSettings[aspect] = god
        end,
        Text = god
      })
  end

  HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.SecondGodDropdown] = ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "GodDropdown"..aspect,
    Group = "Combat_Menu",  
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = xpos, Y = ypos,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = godOptions
  })
  
end

function HSMConfigMenu.CreateBoonControlMenu ( screen )
  local rowStartX = 250
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 250
  local itemSpacingY = 65

  -----------------
  -- BoonControl.config.AllowHermesControl
  -----------------
  screen.Components["HermesControlEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["HermesControlEnabledTextBox"].Id,
    Text = "Enable control of Hermes:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["HermesControlControlEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 3,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["HermesControlControlEnabledCheckbox"].Config = "BoonControl.config.AllowHermesControl"
  screen.Components["HermesControlControlEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["HermesControlControlEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY
  -----------------
  -- BoonControl.config.AllowOlympianControl
  -----------------
  screen.Components["OlympianControlEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["OlympianControlEnabledTextBox"].Id,
    Text = "Enable control of other Olympians:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  
  screen.Components["OlympianControlEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 3,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["OlympianControlEnabledCheckbox"].Config = "BoonControl.config.AllowOlympianControl"
  screen.Components["OlympianControlEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["OlympianControlEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- BoonControl.config.AllowHammerControl
  -----------------
  
  screen.Components["HammerControlTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["HammerControlTextBox"].Id,
    Text = "Select number of hammers to control:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  local originalHammerValue = BoonControl.config.AllowedHammerControl
  local textTable = { 
    [0] = "None",
    [1] = "One Hammer",
    [2] = "Both Hammers"
  }
  local hammerOptions = {
    Default = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = originalHammerValue
      end,
      Text = textTable[originalHammerValue]
    },
    [1] = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = 0
      end,
      Text = "None"
    },
    [2] = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = 1
      end,
      Text = "One Hammer"
    },
    [3] = {
      event = function (dropdown)
        BoonControl.config.AllowedHammerControl = 2
      end,
      Text = "Both Hammers"
    },
  }

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "HammerControlDropdown",
    Group = "Combat_Menu",  
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX * 3, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = hammerOptions,
  })
  itemLocationY = itemLocationY + itemSpacingY
  

  -----------------
  -- BoonControl.config.AllowRarityForce
  -----------------
  screen.Components["AllowRarityForceEnabledTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["AllowRarityForceEnabledTextBox"].Id,
    Text = "Enable for always-epic Hermes:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  -- TODO: add note about all rarity force config possibilities but not leaderboard legal
  
  screen.Components["AllowRarityForceEnabledCheckbox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX * 3,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  screen.Components["AllowRarityForceEnabledCheckbox"].Config = "BoonControl.config.AllowRarityForce"
  screen.Components["AllowRarityForceEnabledCheckbox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["AllowRarityForceEnabledCheckbox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- BoonControl.config.FirstBoonAlwaysEpic/FirstBoonEpicOnPride
  -----------------
  
  screen.Components["RarityControlTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["RarityControlTextBox"].Id,
    Text = "Select first boon rarity settings:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  local rarityOptions = {
    Default = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = false
        BoonControl.config.FirstBoonEpicOnPride = false
      end,
      Text = "Vanilla"
    },
    [1] = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = false
        BoonControl.config.FirstBoonEpicOnPride = false
      end,
      Text = "Vanilla"
    },
    [2] = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = false
        BoonControl.config.FirstBoonEpicOnPride = true
      end,
      Text = "Epic on God's Pride"
    },
    [3] = {
      event = function (dropdown)
        BoonControl.config.FirstBoonAlwaysEpic = true
        BoonControl.config.FirstBoonEpicOnPride = true
      end,
      Text = "Always Epic"
    },
  }

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "RarityControlDropdown",
    Group = "Combat_Menu",  
    Scale = {X = .35, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX * 3, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = rarityOptions,
  })
  itemLocationY = itemLocationY + itemSpacingY

end

function UpdateDropdown( screen, dropdown, options, newSetValue )
  if dropdown == nil then
    return
  end
  -- copied from NewEntry function, using the Dropdown api led to weird crashes
  dropdown.dropDownPressedArgs.Items = options
  if dropdown.isExpanded then
      ErumiUILib.Dropdown.Collapse(screen, dropdown)
      ErumiUILib.Dropdown.Expand(screen, dropdown)
  end
  if newSetValue ~= nil then
    ErumiUILib.Dropdown.SetValue(dropdown, newSetValue)
  end
end

function GetHermesDropdownOptions ( aspect )
  DebugPrint { Text = "GetHermesDropdownOptions for: " .. (aspect or "nil")}
  local hermesBoonOptions = {["Default"] = {
    event = function(dropdown)
      BoonControl.config.AspectSettings[aspect].BoonSetting = BoonControl.config.AspectSettings[aspect].BoonSetting
    end,
    Text = BoonControl.config.AspectSettings[aspect].BoonSetting
  }}
  
  for k, v in pairs(BoonControl.BoonPresets) do
    table.insert(hermesBoonOptions, {
      event = function (dropdown)
        BoonControl.config.AspectSettings[aspect].BoonSetting = k
      end,
      Text = k
    })
  end
  return hermesBoonOptions
end

function GetSecondGodDropdownOptions ( aspect )
  local gods = BoonControl.BoonGods
  local defaultGod = ForceSecondGod.config.AspectSettings[aspect]
  local godOptions = {["Default"] = {
    event = function(dropdown)
      ForceSecondGod.config.AspectSettings[aspect] = defaultGod
    end,
    Text = defaultGod,
  }}
  for i, god in pairs(gods) do
    table.insert(godOptions,
      {
        event = function(dropdown)
            ForceSecondGod.config.AspectSettings[aspect] = god
        end,
        Text = god
      })
  end
  return godOptions
end

function GetHammerDropdownOptions( aspectName, index )
  -- trait name list
  DebugPrint { Text = "GetHammerDropdownOptions for " .. (aspectName or "nil")}
  -- local aspectName = RCLib.CodeToName.Aspects[aspect]
  local hammers = BoonControl.HammerOptions[aspectName]
  -- trait

  local hammerSetString = ""
  local defaultHammerName = BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[index][1].Name
  local defaultHammerTrait = RCLib.NameToCode.Hammers[defaultHammerName]
  local hammerOptions = {["Default"] = {
    event = function(dropdown)
      BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[index][1].Name = defaultHammerName
    end,
    Text = defaultHammerTrait, -- translated by UI framework to full Display Name
  }}

  local otherIndex = 3 - index
  local otherHammerName = BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[otherIndex][1].Name
  local otherHammerTrait = RCLib.NameToCode.Hammers[defaultHammerName]
  for i, hammerTrait in pairs(hammers) do
    local hammerName = RCLib.CodeToName.Hammers[hammerTrait]
    if hammerTrait ~= otherHammerTrait then
      hammerSetString = hammerSetString .. " " .. hammerTrait
      table.insert(hammerOptions,
      {
        event = function(dropdown)
          BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[index][1].Name = hammerName
        end,
        Text = hammerTrait
      })
    end
  end
  DebugPrint { Text = "Returning " .. hammerSetString}
  return hammerOptions
end


function RefreshUIComponents ( screen, args )
  --[[
  args: {
    ComponentsToRefresh: HypermoddedMenu.UIComponents.Keys[]
  }
  ]]--
  local weaponType = HypermoddedMenu.CurrentWeapon
  local aspect = HypermoddedMenu.CurrentAspect
  local currentAspectName = RCLib.CodeToName.Aspects[aspect]
  local weaponIndex = nil
  for k, v in ipairs(BoonControl.WeaponAspectData) do
    if v.Name == HypermoddedMenu.CurrentWeapon then
      weaponIndex = k
      break
    end
  end

  DebugPrint { Text = "Refreshing UI Components: " .. ModUtil.ToString.Deep(args)}

  
  -------------------------
  -- Refresh Aspect Icon --
  -------------------------
  DebugPrint { Text = "Changing Aspect Icon display to: " .. (HypermoddedMenu.CurrentAspect or "nil")}
  SetAnimation({
    DestinationId = screen.Components["AspectIcon"].Id,
    Name = TraitData[HypermoddedMenu.CurrentAspect].Icon .. "_Large"
  })
  ----------------------------------
  -- refresh aspect list dropdown --
  ----------------------------------
  if Contains(args.ComponentsToRefresh, HypermoddedMenu.Keys.AspectListDropdown) then
    DebugPrint { Text = "Refreshing AsepctListDropdown"}
    local aspectDropdownOptions = {["Default"] = {
      event = function (dropdown)
        HypermoddedMenu.CurrentAspect = BoonControl.WeaponAspectData[weaponIndex][1]
        DebugPrint { Text = "calling default aspecct dropdown list refresh" }
        RefreshUIComponents(screen, {
          ComponentsToRefresh = { 
            HypermoddedMenu.Keys.HermesDropdown,
            HypermoddedMenu.Keys.SecondGodDropdown,
            HypermoddedMenu.Keys.FirstHammerDropdown,
            HypermoddedMenu.Keys.SecondHammerDropdown,
          }
        })
      end,
      Text = BoonControl.WeaponAspectData[weaponIndex][1]
    }}

    for j = 1, TableLength(BoonControl.WeaponAspectData[weaponIndex].Aspects) do
      local aspectID = BoonControl.WeaponAspectData[weaponIndex].Aspects[j]
      table.insert(aspectDropdownOptions, {
        event = function (dropdown)
          -- on update, refresh 1) Hermes, 2) Second God UI, 3, hammers
          HypermoddedMenu.CurrentAspect = aspectID
          RefreshUIComponents(screen, {
            ComponentsToRefresh = { 
              HypermoddedMenu.Keys.HermesDropdown,
              HypermoddedMenu.Keys.SecondGodDropdown,
              HypermoddedMenu.Keys.FirstHammerDropdown,
              HypermoddedMenu.Keys.SecondHammerDropdown,
            }
          })
        end,
        Text = aspectID
      })
    end
    UpdateDropdown(screen, HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.AspectListDropdown], aspectDropdownOptions, 1)
  end
  
  --------------------------------------
  -- end aspect list dropdown refresh --
  -- begin SecondGodDropdown refresh  --
  --------------------------------------
  
  if Contains(args.ComponentsToRefresh, HypermoddedMenu.Keys.SecondGodDropdown)
    and ForceSecondGod.config.Enabled then
    UpdateDropdown(
      screen,
      HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.SecondGodDropdown],
      GetSecondGodDropdownOptions(currentAspectName),
      ForceSecondGod.config.AspectSettings[currentAspectName]
    )
  end

  
  if Contains(args.ComponentsToRefresh, HypermoddedMenu.Keys.HermesDropdown)
    and BoonControl.config.Enabled and BoonControl.config.AllowHermesControl then
    UpdateDropdown(
      screen,
      HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.HermesDropdown],
      GetHermesDropdownOptions(currentAspectName),
      BoonControl.config.AspectSettings[currentAspectName].BoonSetting
    )
  end

  if Contains(args.ComponentsToRefresh, HypermoddedMenu.Keys.FirstHammerDropdown)
    and BoonControl.config.Enabled and BoonControl.config.AllowedHammerControl >= 1 then
    UpdateDropdown(
      screen,
      HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.FirstHammerDropdown],
      GetHammerDropdownOptions(currentAspectName, 1),
      -1
    )
  end

  if Contains(args.ComponentsToRefresh, HypermoddedMenu.Keys.SecondHammerDropdown)
    and BoonControl.config.Enabled and BoonControl.config.AllowedHammerControl >= 2 then
    UpdateDropdown(
      screen,
      HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.SecondHammerDropdown],
      GetHammerDropdownOptions(currentAspectName, 2),
      -1
    )
  end
end

function CreateSecondGodUI ( screen, aspect, xpos, ypos )
  -- Create "menu disabled" text
  local itemSpacingX = 250
  screen.Components["ForceSecondSettingsTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = xpos,
    Y = ypos,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["ForceSecondSettingsTextBox"].Id,
    Text = "Select Tartarus Miniboss God Offering:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
      OffsetX = 0, OffsetY = 0,
      Font = "AlegrayaSansSCRegular",
      ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
      Justification = "Left"
    })
  CreateSecondGodPicker( screen, aspect, xpos + itemSpacingX * 3, ypos)
end
-- aspect is traitName
function CreateHammerUI( screen, aspect, xpos, ypos, index )
  -- input  is friendly name of hammer
  -- config is friendly name of hammer
  -- ui     is trait name    of hammer

  -- trait name list
  local aspectName = RCLib.CodeToName.Aspects[aspect]
  local hammers = BoonControl.HammerOptions[aspectName]
  -- trait

  local defaultHammerName = BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[index][1].Name
  local defaultHammerTrait = RCLib.NameToCode.Hammers[defaultHammerName]
  local hammerOptions = {["Default"] = {
    event = function(dropdown)
      BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[index][1].Name = defaultHammerName
    end,
    Text = defaultHammerTrait, -- translated by UI framework to full Display Name
  }}

  local otherIndex = 3 - index
  local otherHammerName = BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[otherIndex][1].Name
  local otherHammerTrait = RCLib.NameToCode.Hammers[defaultHammerName]
  for i, hammerTrait in pairs(hammers) do
    local hammerName = RCLib.CodeToName.Hammers[hammerTrait]
    if hammerTrait ~= otherHammerTrait then
      table.insert(hammerOptions,
      {
        event = function(dropdown)
          BoonControl.config.AspectSettings[aspectName].HammerSetting.ForceOnAppearanceNum[index][1].Name = hammerName
        end,
        Text = hammerTrait
      })
    end
  end

  local componentKeyMap = { HypermoddedMenu.Keys.FirstHammerDropdown, HypermoddedMenu.Keys.SecondHammerDropdown }
  local componentKey = componentKeyMap[index]

  HypermoddedMenu.UIComponents[componentKey] = ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = componentKey,
    Group = "Combat_Menu",  
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = xpos, Y = ypos,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = hammerOptions
  })
end

function CreateHermesUI (screen)

end

function HSMConfigMenu.CreateAspectMenu ( screen )
  local rowStartX = 250
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 250
  local itemSpacingY = 65

  if not BoonControl.config.Enabled or not BoonControl.config.AllowHermesControl then
    -- Create "menu disabled" text
    local textToUse = BoonControl.config.Enabled and 
      "Enable \"Allow controlled Hermes\" setting to use this menu." or
      "Enable \"Enable advanced boon control\" setting to use this menu."
    
    screen.Components["HermesControlDisabledTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
    })
    CreateTextBox({
        Id = screen.Components["HermesControlDisabledTextBox"].Id,
        Text = textToUse,
        Color = Color.BoonPatchCommon,
        FontSize = 16,
        OffsetX = 0, OffsetY = 0,
        Font = "AlegrayaSansSCRegular",
        ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
        Justification = "Left"
    })
    return
  end
  itemLocationY = 500
  --[[
    1. Create Weapon List Dropdown
    2. Create Aspect List Dropdown
    3. Create Icon Display from aspect
    4. On Select Functions
    5. Hermes Display
  ]]--
  -- 1. create weapon list
  HypermoddedMenu.CurrentWeapon = "SwordWeapon"
  HypermoddedMenu.CurrentAspect = "SwordBaseUpgradeTrait"

  --Icon Display
  screen.Components["AspectIcon"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1.5,
    Group = "Combat_Menu",
    X = itemLocationX + itemSpacingX * 2.5,
    Y = itemLocationY 
  })
  SetAnimation({
    DestinationId = screen.Components["AspectIcon"].Id,
    Name = TraitData[HypermoddedMenu.CurrentAspect].Icon .. "_Large"
  })

  local weaponOptions = {["Default"] = {
    Text = "SwordWeapon"
  }}

  -- setup weapon options
  for i = 1, TableLength(BoonControl.WeaponAspectData) do
    local weaponData = BoonControl.WeaponAspectData[i]
    table.insert(weaponOptions, {
      event = function (dropdown)
        HypermoddedMenu.CurrentWeapon = weaponData.Name
        HypermoddedMenu.CurrentAspect = weaponData.Aspects[1]
        RefreshUIComponents(screen, {
          ComponentsToRefresh = {
            HypermoddedMenu.Keys.AspectListDropdown,
            HypermoddedMenu.Keys.HermesDropdown,
            HypermoddedMenu.Keys.SecondGodDropdown,
            HypermoddedMenu.Keys.FirstHammerDropdown,
            HypermoddedMenu.Keys.SecondHammerDropdown,
          }
        })
      end,
      Text = weaponData.Name
    })
  end

  -- weapon dropdown
  HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.WeaponListDropdown] = ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "HermesWeaponDropdown",
    Group = "Combat_Menu",  
    Scale = {X = .3, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = weaponOptions,
  })

  -- Create Hermes Control Menu
  -- initial aspect list
  HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.AspectListDropdown] = ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "HermesAspectDropdown",
    Group = "Combat_Menu",  
    Scale = {X = .3, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX * 1.25, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = {["Default"] = {}},
  })
  

  itemLocationX = itemLocationX + itemSpacingX * 3
  itemLocationY = 400

  ----------------------------
  --  HERMES -----------------
  ----------------------------
  if BoonControl.config.Enabled and BoonControl.config.AllowHermesControl then
    screen.Components["HermesSettingsTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
    })
    CreateTextBox({
      Id = screen.Components["HermesSettingsTextBox"].Id,
      Text = "Select Hermes Preset:",
      Color = Color.BoonPatchCommon,
      FontSize = 16,
        OffsetX = 0, OffsetY = 0,
        Font = "AlegrayaSansSCRegular",
        ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
        Justification = "Left"
      })
    -- actual hermes boons options
    HypermoddedMenu.UIComponents[HypermoddedMenu.Keys.HermesDropdown] = ErumiUILib.Dropdown.CreateDropdown(screen, {
      Name = "HermesBoonDropdown",
      Group = "Combat_Menu",  
      Scale = {X = .25, Y = .5},
      Padding = {X = 0, Y = 2},
      X = itemLocationX + itemSpacingX * 3, Y = itemLocationY,
      GeneralFontSize = 16,
      Font = "AlegrayaSansSCRegular",
      -- placeholder, this gets updated very quickly anyway
      Items = {["Default"] = {}},
    })
    itemLocationY = itemLocationY + itemSpacingY
  end

  -- second god options

  if ForceSecondGod.config.Enabled then
    -- local aspectID = weaponData.Aspects[j]
    CreateSecondGodUI( screen, HypermoddedMenu.CurrentAspect, itemLocationX, itemLocationY)
    itemLocationY = itemLocationY + itemSpacingY
  end
  -- create first hammer options
  if BoonControl.config.Enabled and BoonControl.config.AllowedHammerControl >= 1 then
    screen.Components["HammerSettingsTextBox"] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = itemLocationX,
      Y = itemLocationY,
      Group = "Combat_Menu"
    })
    CreateTextBox({
        Id = screen.Components["HammerSettingsTextBox"].Id,
        Text = "Select Hammers:",
        Color = Color.BoonPatchCommon,
        FontSize = 16,
        OffsetX = 0, OffsetY = 0,
        Font = "AlegrayaSansSCRegular",
        ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
        Justification = "Left"
    })
    -- Space appropriately based on hammer control settings.
    local dropdownSpacingFactor = (BoonControl.config.Enabled and BoonControl.config.AllowedHammerControl == 2) and 2 or 3
    CreateHammerUI( screen, HypermoddedMenu.CurrentAspect, itemLocationX + itemSpacingX * dropdownSpacingFactor, itemLocationY, 1 )
  end
  -- create second hammer options
  if BoonControl.config.Enabled and BoonControl.config.AllowedHammerControl >= 2 then
    CreateHammerUI( screen, HypermoddedMenu.CurrentAspect, itemLocationX + itemSpacingX * 3, itemLocationY, 2 )
    itemLocationY = itemLocationY + itemSpacingY
  end

  -- refresh UI to generate options
  -- weapon list does not need to refresh since it is the highest in hierarchy
  RefreshUIComponents(screen, {
    ComponentsToRefresh = {
      HypermoddedMenu.Keys.AspectListDropdown,
      HypermoddedMenu.Keys.HermesDropdown,
      HypermoddedMenu.Keys.SecondGodDropdown,
      HypermoddedMenu.Keys.FirstHammerDropdown,
      HypermoddedMenu.Keys.SecondHammerDropdown,
    }
  })
end

ModUtil.LoadOnce(function()
    ModConfigMenu.RegisterMenuOverride({ModName = "Hypermodded"}, HSMConfigMenu.CreateHypermoddedMenu)
    -- ModConfigMenu.RegisterMenuOverride({ModName = "Hypermodded (cont.)"}, HSMConfigMenu.CreateBoonControlMenu)
    ModConfigMenu.RegisterMenuOverride({ModName = "Aspect Settings"}, HSMConfigMenu.CreateAspectMenu)
end)
