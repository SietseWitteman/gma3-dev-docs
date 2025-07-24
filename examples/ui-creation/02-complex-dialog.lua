---@meta
--- Complex Dialog Creation Example
--- Advanced dialog with multiple UI element types, tabs, and complex layouts
--- 
--- This example covers:
--- - Multi-tab dialog structure
--- - Mixed UI element types (inputs, checkboxes, faders, dropdowns)
--- - Dynamic content updates and inter-element communication
--- - Advanced validation and data processing
--- - Resizable dialog with flexible layouts

---@class ComplexDialogExample
local ComplexDialogExample = {}

-- ========================================
-- COMPLEX DIALOG CONFIGURATION
-- ========================================

---Configuration for the complex dialog
local ComplexDialogConfig = {
    -- Dialog dimensions and behavior
    name = "ComplexExampleDialog",
    title = "Advanced Dialog Example",
    icon = "application_xp_terminal",
    width = 800,
    height = 600,
    minWidth = 600,
    minHeight = 400,
    
    -- Tab configuration
    tabs = {
        {
            id = "fixtures",
            name = "Fixture Control",
            icon = "object_fixture",
            description = "Control fixture parameters and settings"
        },
        {
            id = "groups",
            name = "Group Management", 
            icon = "object_group",
            description = "Manage groups and selection sets"
        },
        {
            id = "presets",
            name = "Preset Library",
            icon = "object_preset",
            description = "Browse and apply preset configurations"
        },
        {
            id = "settings",
            name = "Settings",
            icon = "tools",
            description = "Dialog preferences and advanced options"
        }
    }
}

-- ========================================
-- DIALOG STRUCTURE CREATION
-- ========================================

---Create the main complex dialog structure
---@param display Handle Display for dialog placement
---@param colors table Theme colors
---@return Handle baseDialog Main dialog container
local function createComplexDialogBase(display, colors)
    local screenOverlay = display.ScreenOverlay
    screenOverlay:ClearUIChildren()
    
    -- Create resizable dialog base
    local baseDialog = screenOverlay:Append("BaseInput")
    baseDialog.Name = ComplexDialogConfig.name
    baseDialog.W = tostring(ComplexDialogConfig.width)
    baseDialog.H = tostring(ComplexDialogConfig.height)
    baseDialog.MaxSize = string.format("%s,%s", display.W * 0.95, display.H * 0.95)
    baseDialog.MinSize = string.format("%s,%s", ComplexDialogConfig.minWidth, ComplexDialogConfig.minHeight)
    baseDialog.Columns = 1
    baseDialog.Rows = 3
    baseDialog.AutoClose = "No"
    baseDialog.CloseOnEscape = "Yes"
    baseDialog.Moveable = "Yes"
    baseDialog.Resizeable = "Yes"
    
    -- Configure layout proportions
    baseDialog[1][1].SizePolicy = "Fixed"
    baseDialog[1][1].Size = "50"        -- Title bar
    baseDialog[1][2].SizePolicy = "Fixed"
    baseDialog[1][2].Size = "40"        -- Tab bar
    baseDialog[1][3].SizePolicy = "Stretch"  -- Content area
    
    Printf("Created complex dialog base: " .. ComplexDialogConfig.width .. "x" .. ComplexDialogConfig.height)
    
    return baseDialog
end

---Create enhanced title bar with status information
---@param baseDialog Handle Main dialog container
---@param colors table Theme colors
---@return Handle titleBar Title bar container
local function createComplexTitleBar(baseDialog, colors)
    local titleBar = baseDialog:Append("TitleBar")
    titleBar.Columns = 3
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar.Texture = "corner2"
    
    -- Configure title bar layout
    titleBar[2][2].SizePolicy = "Stretch"   -- Status area
    titleBar[2][3].SizePolicy = "Fixed"
    titleBar[2][3].Size = "40"              -- Close button
    
    -- Create title button
    local titleButton = titleBar:Append("TitleButton")
    titleButton.Text = ComplexDialogConfig.title
    titleButton.Icon = ComplexDialogConfig.icon
    titleButton.Texture = "corner1"
    titleButton.Anchors = "0,0"
    titleButton.Font = "Medium18"
    titleButton.HasHover = "No"
    
    -- Create status display area
    local statusLabel = titleBar:Append("UIObject")
    statusLabel.Text = "Ready"
    statusLabel.Font = "Small12"
    statusLabel.TextalignmentH = "Right"
    statusLabel.HasHover = "No"
    statusLabel.BackColor = colors.transparent
    statusLabel.Anchors = "1,0"
    statusLabel.Padding = { left = 10, right = 10, top = 15, bottom = 15 }
    
    -- Create close button
    local closeButton = titleBar:Append("CloseButton")
    closeButton.Anchors = "2,0"
    closeButton.Texture = "corner2"
    closeButton.HasHover = "Yes"
    
    Printf("Created complex title bar with status display")
    
    return titleBar, statusLabel
end

---Create tab navigation bar
---@param baseDialog Handle Main dialog container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle tabBar Tab bar container
---@return table tabButtons Array of tab button handles
local function createTabBar(baseDialog, colors, signalTable, pluginHandle)
    local tabBar = baseDialog:Append("UILayoutGrid")
    tabBar.Columns = #ComplexDialogConfig.tabs
    tabBar.Rows = 1
    tabBar.Anchors = "0,1"
    tabBar.Margin = { left = 5, right = 5, top = 0, bottom = 5 }
    
    local tabButtons = {}
    
    -- Create tab buttons
    for i, tabConfig in ipairs(ComplexDialogConfig.tabs) do
        local tabButton = tabBar:Append("Button")
        tabButton.Text = tabConfig.name
        tabButton.Icon = tabConfig.icon
        tabButton.Font = "Medium14"
        tabButton.TextalignmentH = "Centre"
        tabButton.HasHover = "Yes"
        tabButton.Textshadow = 1
        tabButton.Anchors = { left = i-1, right = i-1, top = 0, bottom = 0 }
        tabButton.Margin = { left = 2, right = 2, top = 0, bottom = 0 }
        tabButton.BackColor = colors.background
        tabButton.PluginComponent = pluginHandle
        tabButton.Clicked = "OnTabClicked"
        
        -- Store tab information
        tabButton.TabId = tabConfig.id
        tabButton.TabIndex = i
        
        tabButtons[tabConfig.id] = tabButton
        
        Printf("Created tab button: " .. tabConfig.name)
    end
    
    -- Set first tab as active
    if tabButtons[ComplexDialogConfig.tabs[1].id] then
        tabButtons[ComplexDialogConfig.tabs[1].id].BackColor = colors.backgroundPlease
    end
    
    return tabBar, tabButtons
end

-- ========================================
-- TAB CONTENT CREATION
-- ========================================

---Create fixture control tab content
---@param contentArea Handle Main content container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle fixtureTab Fixture tab content
local function createFixtureTab(contentArea, colors, signalTable, pluginHandle)
    local fixtureTab = contentArea:Append("UILayoutGrid")
    fixtureTab.Name = "FixtureTab"
    fixtureTab.Columns = 2
    fixtureTab.Rows = 3
    fixtureTab.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    fixtureTab.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Configure layout
    fixtureTab[2][1].SizePolicy = "Fixed"
    fixtureTab[2][1].Size = "200"  -- Left panel width
    
    -- Left panel: Fixture selection
    local selectionPanel = fixtureTab:Append("DialogFrame")
    selectionPanel.Anchors = { left = 0, right = 0, top = 0, bottom = 2 }
    selectionPanel.Columns = 1
    selectionPanel.Rows = 4
    
    -- Selection title
    local selectionTitle = selectionPanel:Append("UIObject")
    selectionTitle.Text = "Fixture Selection"
    selectionTitle.Font = "Medium16"
    selectionTitle.TextalignmentH = "Center"
    selectionTitle.HasHover = "No"
    selectionTitle.BackColor = colors.partlySelected
    selectionTitle.Anchors = "0,0"
    selectionTitle.Padding = { left = 5, right = 5, top = 8, bottom = 8 }
    
    -- Fixture ID input
    local fixtureIdGrid = selectionPanel:Append("UILayoutGrid")
    fixtureIdGrid.Columns = 3
    fixtureIdGrid.Rows = 1
    fixtureIdGrid.Anchors = "0,1"
    fixtureIdGrid.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
    
    local idLabel = fixtureIdGrid:Append("UIObject")
    idLabel.Text = "ID:"
    idLabel.Font = "Medium14"
    idLabel.TextalignmentH = "Left"
    idLabel.HasHover = "No"
    idLabel.Anchors = "0,0"
    idLabel.Padding = { left = 5, right = 5, top = 8, bottom = 8 }
    
    local idInput = fixtureIdGrid:Append("LineEdit")
    idInput.Prompt = "1"
    idInput.Filter = "0123456789+-"
    idInput.MaxTextLength = 20
    idInput.Content = "1"
    idInput.Anchors = "1,0"
    idInput.PluginComponent = pluginHandle
    idInput.TextChanged = "OnFixtureIdChanged"
    
    local selectButton = fixtureIdGrid:Append("Button")
    selectButton.Text = "Select"
    selectButton.Font = "Small12"
    selectButton.Icon = "select"
    selectButton.Anchors = "2,0"
    selectButton.PluginComponent = pluginHandle
    selectButton.Clicked = "OnSelectFixtures"
    
    -- Quick selection buttons
    local quickSelectionGrid = selectionPanel:Append("UILayoutGrid")
    quickSelectionGrid.Columns = 3
    quickSelectionGrid.Rows = 2
    quickSelectionGrid.Anchors = "0,2"
    quickSelectionGrid.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
    
    local quickButtons = {
        { text = "1-10", command = "Fixture 1 Thru 10" },
        { text = "11-20", command = "Fixture 11 Thru 20" },
        { text = "All", command = "Fixture Thru" },
        { text = "Odd", command = "Fixture 1+3+5+7+9" },
        { text = "Even", command = "Fixture 2+4+6+8+10" },
        { text = "Clear", command = "Clear" }
    }
    
    for i, buttonConfig in ipairs(quickButtons) do
        local row = math.floor((i-1) / 3)
        local col = (i-1) % 3
        
        local quickButton = quickSelectionGrid:Append("Button")
        quickButton.Text = buttonConfig.text
        quickButton.Font = "Small11"
        quickButton.Anchors = { left = col, right = col, top = row, bottom = row }
        quickButton.Margin = { left = 1, right = 1, top = 1, bottom = 1 }
        quickButton.PluginComponent = pluginHandle
        quickButton.Clicked = "OnQuickSelect"
        quickButton.CommandText = buttonConfig.command
    end
    
    -- Right panel: Parameter controls
    local controlPanel = fixtureTab:Append("DialogFrame")
    controlPanel.Anchors = { left = 1, right = 1, top = 0, bottom = 2 }
    controlPanel.Columns = 1
    controlPanel.Rows = 2
    
    -- Control title
    local controlTitle = controlPanel:Append("UIObject")
    controlTitle.Text = "Parameter Control"
    controlTitle.Font = "Medium16"
    controlTitle.TextalignmentH = "Center"
    controlTitle.HasHover = "No"
    controlTitle.BackColor = colors.partlySelected
    controlTitle.Anchors = "0,0"
    controlTitle.Padding = { left = 5, right = 5, top = 8, bottom = 8 }
    
    -- Parameter faders
    local faderGrid = controlPanel:Append("UILayoutGrid")
    faderGrid.Columns = 4
    faderGrid.Rows = 2
    faderGrid.Anchors = "0,1"
    faderGrid.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    local faderConfigs = {
        { name = "Intensity", attr = "Dimmer", min = 0, max = 100 },
        { name = "Red", attr = "ColorAdd_R", min = 0, max = 255 },
        { name = "Green", attr = "ColorAdd_G", min = 0, max = 255 },
        { name = "Blue", attr = "ColorAdd_B", min = 0, max = 255 },
        { name = "Pan", attr = "Pan", min = -270, max = 270 },
        { name = "Tilt", attr = "Tilt", min = -135, max = 135 },
        { name = "Zoom", attr = "Zoom", min = 0, max = 100 },
        { name = "Focus", attr = "Focus", min = 0, max = 100 }
    }
    
    for i, faderConfig in ipairs(faderConfigs) do
        local row = math.floor((i-1) / 4)
        local col = (i-1) % 4
        
        local fader = faderGrid:Append("UiFader")
        fader.Text = faderConfig.name
        fader.Min = faderConfig.min
        fader.Max = faderConfig.max
        fader.Value = faderConfig.min
        fader.Anchors = { left = col, right = col, top = row, bottom = row }
        fader.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
        fader.PluginComponent = pluginHandle
        fader.Changed = "OnParameterChanged"
        fader.AttributeName = faderConfig.attr
    end
    
    return fixtureTab
end

---Create group management tab content
---@param contentArea Handle Main content container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle groupTab Group tab content
local function createGroupTab(contentArea, colors, signalTable, pluginHandle)
    local groupTab = contentArea:Append("UILayoutGrid")
    groupTab.Name = "GroupTab"
    groupTab.Columns = 1
    groupTab.Rows = 3
    groupTab.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    groupTab.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    groupTab.Visible = "No"  -- Hidden by default
    
    -- Configure layout
    groupTab[1][1].SizePolicy = "Fixed"
    groupTab[1][1].Size = "40"     -- Header
    groupTab[1][2].SizePolicy = "Stretch"  -- Group list
    groupTab[1][3].SizePolicy = "Fixed"
    groupTab[1][3].Size = "80"     -- Controls
    
    -- Header with group creation
    local headerGrid = groupTab:Append("UILayoutGrid")
    headerGrid.Columns = 4
    headerGrid.Rows = 1
    headerGrid.Anchors = "0,0"
    headerGrid.Margin = { left = 0, right = 0, top = 0, bottom = 5 }
    
    local groupLabel = headerGrid:Append("UIObject")
    groupLabel.Text = "Group Name:"
    groupLabel.Font = "Medium14"
    groupLabel.TextalignmentH = "Left"
    groupLabel.HasHover = "No"
    groupLabel.Anchors = "0,0"
    groupLabel.Padding = { left = 5, right = 5, top = 10, bottom = 10 }
    
    local groupNameInput = headerGrid:Append("LineEdit")
    groupNameInput.Prompt = "New Group"
    groupNameInput.MaxTextLength = 32
    groupNameInput.Anchors = "1,0"
    groupNameInput.PluginComponent = pluginHandle
    groupNameInput.TextChanged = "OnGroupNameChanged"
    
    local createGroupButton = headerGrid:Append("Button")
    createGroupButton.Text = "Create"
    createGroupButton.Icon = "plus"
    createGroupButton.Font = "Medium14"
    createGroupButton.Anchors = "2,0"
    createGroupButton.PluginComponent = pluginHandle
    createGroupButton.Clicked = "OnCreateGroup"
    
    local refreshButton = headerGrid:Append("Button")
    refreshButton.Text = "Refresh"
    refreshButton.Icon = "reload"
    refreshButton.Font = "Medium14"
    refreshButton.Anchors = "3,0"
    refreshButton.PluginComponent = pluginHandle
    refreshButton.Clicked = "OnRefreshGroups"
    
    -- Group list area (simulated with grid)
    local groupListGrid = groupTab:Append("UILayoutGrid")
    groupListGrid.Columns = 4
    groupListGrid.Rows = 8
    groupListGrid.Anchors = "0,1"
    groupListGrid.Margin = { left = 0, right = 0, top = 5, bottom = 5 }
    
    -- Create mock group entries
    for i = 1, 16 do
        local row = math.floor((i-1) / 4)
        local col = (i-1) % 4
        
        if row < 8 then  -- Only create within grid bounds
            local groupButton = groupListGrid:Append("Button")
            groupButton.Text = "Group " .. i
            groupButton.Font = "Small12"
            groupButton.Icon = "object_group"
            groupButton.Anchors = { left = col, right = col, top = row, bottom = row }
            groupButton.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
            groupButton.PluginComponent = pluginHandle
            groupButton.Clicked = "OnGroupSelected"
            groupButton.GroupId = i
        end
    end
    
    -- Control buttons
    local controlGrid = groupTab:Append("UILayoutGrid")
    controlGrid.Columns = 3
    controlGrid.Rows = 1
    controlGrid.Anchors = "0,2"
    controlGrid.Margin = { left = 0, right = 0, top = 5, bottom = 0 }
    
    local flashButton = controlGrid:Append("Button")
    flashButton.Text = "Flash Selected"
    flashButton.Icon = "flash"
    flashButton.Font = "Medium14"
    flashButton.BackColor = colors.backgroundPlease
    flashButton.Anchors = "0,0"
    flashButton.PluginComponent = pluginHandle
    flashButton.Clicked = "OnFlashGroup"
    
    local selectButton = controlGrid:Append("Button")
    selectButton.Text = "Select Fixtures"
    selectButton.Icon = "select"
    selectButton.Font = "Medium14"
    selectButton.Anchors = "1,0"
    selectButton.PluginComponent = pluginHandle
    selectButton.Clicked = "OnSelectGroupFixtures"
    
    local deleteButton = controlGrid:Append("Button")
    deleteButton.Text = "Delete Group"
    deleteButton.Icon = "delete"
    deleteButton.Font = "Medium14"
    deleteButton.BackColor = colors.partlySelected
    deleteButton.Anchors = "2,0"
    deleteButton.PluginComponent = pluginHandle
    deleteButton.Clicked = "OnDeleteGroup"
    
    return groupTab
end

---Create preset library tab content
---@param contentArea Handle Main content container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle presetTab Preset tab content
local function createPresetTab(contentArea, colors, signalTable, pluginHandle)
    local presetTab = contentArea:Append("UILayoutGrid")
    presetTab.Name = "PresetTab"
    presetTab.Columns = 1
    presetTab.Rows = 2
    presetTab.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    presetTab.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    presetTab.Visible = "No"  -- Hidden by default
    
    -- Preset type selector
    local typeSelector = presetTab:Append("UILayoutGrid")
    typeSelector.Columns = 4
    typeSelector.Rows = 1
    typeSelector.Anchors = "0,0"
    typeSelector.Margin = { left = 0, right = 0, top = 0, bottom = 10 }
    
    typeSelector[2][1].SizePolicy = "Fixed"
    typeSelector[2][1].Size = "80"  -- Button width
    
    local presetTypes = { "Intensity", "Color", "Beam", "Position" }
    
    for i, presetType in ipairs(presetTypes) do
        local typeButton = typeSelector:Append("Button")
        typeButton.Text = presetType
        typeButton.Font = "Medium14"
        typeButton.Anchors = { left = i-1, right = i-1, top = 0, bottom = 0 }
        typeButton.Margin = { left = 2, right = 2, top = 0, bottom = 0 }
        typeButton.BackColor = (i == 1) and colors.backgroundPlease or colors.background
        typeButton.PluginComponent = pluginHandle
        typeButton.Clicked = "OnPresetTypeSelected"
        typeButton.PresetType = presetType
    end
    
    -- Preset grid
    local presetGrid = presetTab:Append("UILayoutGrid")
    presetGrid.Columns = 8
    presetGrid.Rows = 6
    presetGrid.Anchors = "0,1"
    presetGrid.Margin = { left = 0, right = 0, top = 10, bottom = 0 }
    
    -- Create preset buttons
    for i = 1, 48 do
        local row = math.floor((i-1) / 8)
        local col = (i-1) % 8
        
        if row < 6 then
            local presetButton = presetGrid:Append("Button")
            presetButton.Text = tostring(i)
            presetButton.Font = "Small11"
            presetButton.Icon = "object_preset"
            presetButton.Anchors = { left = col, right = col, top = row, bottom = row }
            presetButton.Margin = { left = 1, right = 1, top = 1, bottom = 1 }
            presetButton.PluginComponent = pluginHandle
            presetButton.Clicked = "OnPresetClicked"
            presetButton.PresetId = i
            
            -- Add some visual variety
            if i % 5 == 0 then
                presetButton.BackColor = colors.partlySelected
            end
        end
    end
    
    return presetTab
end

---Create settings tab content
---@param contentArea Handle Main content container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle settingsTab Settings tab content
local function createSettingsTab(contentArea, colors, signalTable, pluginHandle)
    local settingsTab = contentArea:Append("UILayoutGrid")
    settingsTab.Name = "SettingsTab"
    settingsTab.Columns = 2
    settingsTab.Rows = 1
    settingsTab.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    settingsTab.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    settingsTab.Visible = "No"  -- Hidden by default
    
    -- Left panel: General settings
    local generalPanel = settingsTab:Append("DialogFrame")
    generalPanel.Anchors = "0,0"
    generalPanel.Columns = 1
    generalPanel.Rows = 5
    generalPanel.Margin = { left = 0, right = 5, top = 0, bottom = 0 }
    
    local generalTitle = generalPanel:Append("UIObject")
    generalTitle.Text = "General Settings"
    generalTitle.Font = "Medium16"
    generalTitle.TextalignmentH = "Center"
    generalTitle.HasHover = "No"
    generalTitle.BackColor = colors.partlySelected
    generalTitle.Anchors = "0,0"
    generalTitle.Padding = { left = 5, right = 5, top = 8, bottom = 8 }
    
    -- Setting checkboxes
    local settingItems = {
        { text = "Auto-refresh data", default = true },
        { text = "Show tooltips", default = true },
        { text = "Confirm destructive actions", default = true },
        { text = "Remember window position", default = false }
    }
    
    for i, setting in ipairs(settingItems) do
        local checkbox = generalPanel:Append("CheckBox")
        checkbox.Text = setting.text
        checkbox.Font = "Medium14"
        checkbox.TextalignmentH = "Left"
        checkbox.State = setting.default and 1 or 0
        checkbox.Anchors = { left = 0, right = 0, top = i, bottom = i }
        checkbox.Margin = { left = 10, right = 10, top = 5, bottom = 5 }
        checkbox.PluginComponent = pluginHandle
        checkbox.Clicked = "OnSettingChanged"
        checkbox.SettingName = setting.text
    end
    
    -- Right panel: Advanced settings  
    local advancedPanel = settingsTab:Append("DialogFrame")
    advancedPanel.Anchors = "1,0"
    advancedPanel.Columns = 1
    advancedPanel.Rows = 4
    advancedPanel.Margin = { left = 5, right = 0, top = 0, bottom = 0 }
    
    local advancedTitle = advancedPanel:Append("UIObject")
    advancedTitle.Text = "Advanced Settings"
    advancedTitle.Font = "Medium16"
    advancedTitle.TextalignmentH = "Center"
    advancedTitle.HasHover = "No"
    advancedTitle.BackColor = colors.partlySelected
    advancedTitle.Anchors = "0,0"
    advancedTitle.Padding = { left = 5, right = 5, top = 8, bottom = 8 }
    
    -- Update interval setting
    local intervalGrid = advancedPanel:Append("UILayoutGrid")
    intervalGrid.Columns = 2
    intervalGrid.Rows = 1
    intervalGrid.Anchors = "0,1"
    intervalGrid.Margin = { left = 10, right = 10, top = 10, bottom = 5 }
    
    local intervalLabel = intervalGrid:Append("UIObject")
    intervalLabel.Text = "Update Interval (ms):"
    intervalLabel.Font = "Medium14"
    intervalLabel.TextalignmentH = "Left"
    intervalLabel.HasHover = "No"
    intervalLabel.Anchors = "0,0"
    intervalLabel.Padding = { left = 0, right = 5, top = 8, bottom = 8 }
    
    local intervalInput = intervalGrid:Append("LineEdit")
    intervalInput.Content = "100"
    intervalInput.Filter = "0123456789"
    intervalInput.MaxTextLength = 6
    intervalInput.Anchors = "1,0"
    intervalInput.PluginComponent = pluginHandle
    intervalInput.TextChanged = "OnIntervalChanged"
    
    -- Debug level setting
    local debugGrid = advancedPanel:Append("UILayoutGrid")
    debugGrid.Columns = 2
    debugGrid.Rows = 1
    debugGrid.Anchors = "0,2"
    debugGrid.Margin = { left = 10, right = 10, top = 5, bottom = 5 }
    
    local debugLabel = debugGrid:Append("UIObject")
    debugLabel.Text = "Debug Level:"
    debugLabel.Font = "Medium14"
    debugLabel.TextalignmentH = "Left"
    debugLabel.HasHover = "No"
    debugLabel.Anchors = "0,0"
    debugLabel.Padding = { left = 0, right = 5, top = 8, bottom = 8 }
    
    -- Note: In a real implementation, this would be a dropdown
    local debugButton = debugGrid:Append("Button")
    debugButton.Text = "Info"
    debugButton.Font = "Medium14"
    debugButton.Anchors = "1,0"
    debugButton.PluginComponent = pluginHandle
    debugButton.Clicked = "OnDebugLevelClicked"
    
    -- Reset button
    local resetButton = advancedPanel:Append("Button")
    resetButton.Text = "Reset to Defaults"
    resetButton.Icon = "reload"
    resetButton.Font = "Medium14"
    resetButton.BackColor = colors.partlySelected
    resetButton.Anchors = "0,3"
    resetButton.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    resetButton.PluginComponent = pluginHandle
    resetButton.Clicked = "OnResetSettings"
    
    return settingsTab
end

-- ========================================
-- EVENT HANDLERS FOR COMPLEX DIALOG
-- ========================================

---Create comprehensive event handlers for the complex dialog
---@param tabButtons table Tab button handles
---@param statusLabel Handle Status display label
---@param colors table Theme colors
---@return table handlers Event handler functions
local function createComplexEventHandlers(tabButtons, statusLabel, colors)
    local handlers = {}
    local currentTab = ComplexDialogConfig.tabs[1].id
    local selectedGroup = nil
    local selectedPresetType = "Intensity"
    
    ---Handle tab button clicks
    handlers.OnTabClicked = function(caller)
        local newTab = caller.TabId
        Printf("Switching to tab: " .. newTab)
        
        -- Update button states
        for tabId, button in pairs(tabButtons) do
            if tabId == newTab then
                button.BackColor = colors.backgroundPlease
            else
                button.BackColor = colors.background
            end
        end
        
        -- Show/hide tab content
        local contentArea = caller.parent.parent  -- Navigate to main content area
        for i = 1, contentArea.ChildCount do
            local child = contentArea[i]
            if child.Name and child.Name:find("Tab$") then
                if child.Name == newTab .. "Tab" or 
                   (newTab == "fixtures" and child.Name == "FixtureTab") or
                   (newTab == "groups" and child.Name == "GroupTab") or
                   (newTab == "presets" and child.Name == "PresetTab") or
                   (newTab == "settings" and child.Name == "SettingsTab") then
                    child.Visible = "Yes"
                else
                    child.Visible = "No"
                end
            end
        end
        
        currentTab = newTab
        statusLabel.Text = "Tab: " .. newTab:gsub("^%l", string.upper)
    end
    
    -- Fixture tab handlers
    handlers.OnFixtureIdChanged = function(caller)
        local fixtureId = caller.Content
        Printf("Fixture ID changed to: " .. fixtureId)
        statusLabel.Text = "Fixture: " .. fixtureId
    end
    
    handlers.OnSelectFixtures = function(caller)
        -- Get fixture ID from input
        local idInput = nil  -- Would need proper reference in real implementation
        Printf("Selecting fixtures based on input")
        statusLabel.Text = "Fixtures selected"
    end
    
    handlers.OnQuickSelect = function(caller)
        local command = caller.CommandText
        Printf("Quick select command: " .. command)
        statusLabel.Text = "Quick select: " .. caller.Text
        -- Cmd(command)  -- Execute command
    end
    
    handlers.OnParameterChanged = function(caller)
        local attributeName = caller.AttributeName
        local value = caller.Value
        Printf("Parameter " .. attributeName .. " changed to: " .. value)
        statusLabel.Text = attributeName .. ": " .. value
    end
    
    -- Group tab handlers
    handlers.OnGroupNameChanged = function(caller)
        local groupName = caller.Content
        Printf("Group name: " .. groupName)
    end
    
    handlers.OnCreateGroup = function(caller)
        Printf("Creating new group")
        statusLabel.Text = "Group created"
    end
    
    handlers.OnRefreshGroups = function(caller)
        Printf("Refreshing group list")
        statusLabel.Text = "Groups refreshed"
    end
    
    handlers.OnGroupSelected = function(caller)
        selectedGroup = caller.GroupId
        Printf("Selected group: " .. selectedGroup)
        statusLabel.Text = "Group " .. selectedGroup .. " selected"
        
        -- Update visual selection (would need proper reference)
        caller.BackColor = colors.backgroundPlease
    end
    
    handlers.OnFlashGroup = function(caller)
        if selectedGroup then
            Printf("Flashing group " .. selectedGroup)
            statusLabel.Text = "Flashing group " .. selectedGroup
            -- Cmd("Group " .. selectedGroup .. " Flash")
        else
            Printf("No group selected for flash")
            statusLabel.Text = "Select a group first"
        end
    end
    
    handlers.OnSelectGroupFixtures = function(caller)
        if selectedGroup then
            Printf("Selecting fixtures from group " .. selectedGroup)
            statusLabel.Text = "Selected group " .. selectedGroup .. " fixtures"
            -- Cmd("Group " .. selectedGroup)
        end
    end
    
    handlers.OnDeleteGroup = function(caller)
        if selectedGroup then
            Printf("Deleting group " .. selectedGroup)
            statusLabel.Text = "Deleted group " .. selectedGroup
            -- Cmd("Delete Group " .. selectedGroup)
        end
    end
    
    -- Preset tab handlers
    handlers.OnPresetTypeSelected = function(caller)
        selectedPresetType = caller.PresetType
        Printf("Selected preset type: " .. selectedPresetType)
        statusLabel.Text = "Preset type: " .. selectedPresetType
        
        -- Update button states (would need proper reference to all type buttons)
        caller.BackColor = colors.backgroundPlease
    end
    
    handlers.OnPresetClicked = function(caller)
        local presetId = caller.PresetId
        Printf("Applying " .. selectedPresetType .. " preset " .. presetId)
        statusLabel.Text = selectedPresetType .. " preset " .. presetId .. " applied"
        -- Cmd("Preset " .. selectedPresetType .. " " .. presetId)
    end
    
    -- Settings tab handlers
    handlers.OnSettingChanged = function(caller)
        local settingName = caller.SettingName
        local enabled = caller.State == 1
        Printf("Setting '" .. settingName .. "' changed to: " .. (enabled and "enabled" or "disabled"))
        statusLabel.Text = "Settings updated"
    end
    
    handlers.OnIntervalChanged = function(caller)
        local interval = caller.Content
        Printf("Update interval changed to: " .. interval .. "ms")
        statusLabel.Text = "Interval: " .. interval .. "ms"
    end
    
    handlers.OnDebugLevelClicked = function(caller)
        Printf("Debug level selector clicked")
        statusLabel.Text = "Debug level: " .. caller.Text
    end
    
    handlers.OnResetSettings = function(caller)
        Printf("Resetting settings to defaults")
        statusLabel.Text = "Settings reset to defaults"
    end
    
    return handlers
end

-- ========================================
-- MAIN COMPLEX DIALOG CREATION FUNCTION
-- ========================================

---Create a complete complex dialog with multiple tabs and advanced features
---@param pluginHandle? Handle Optional plugin component handle
---@param signalTable? table Optional signal table for event handlers
---@return Handle|nil dialog Created dialog handle or nil if failed
---@usage
--- -- Create complex dialog:
--- local dialog = createComplexDialog(myHandle, signalTable)
function createComplexDialog(pluginHandle, signalTable)
    Printf("Creating complex dialog example...")
    
    -- Initialize components
    local eventTable = signalTable or {}
    local componentHandle = pluginHandle or Obj()
    
    -- Get display and colors
    local display, displayIndex = getTargetDisplay()
    if not display then
        Printf("Error: Could not get target display")
        return nil
    end
    
    local colors = getThemeColors()
    
    -- Create main dialog structure
    local baseDialog = createComplexDialogBase(display, colors)
    local titleBar, statusLabel = createComplexTitleBar(baseDialog, colors)
    local tabBar, tabButtons = createTabBar(baseDialog, colors, eventTable, componentHandle)
    
    -- Create content area
    local contentArea = baseDialog:Append("DialogFrame")
    contentArea.H = "100%"
    contentArea.W = "100%"
    contentArea.Columns = 1
    contentArea.Rows = 1
    contentArea.Anchors = { left = 0, right = 0, top = 2, bottom = 2 }
    
    -- Create tab content
    local fixtureTab = createFixtureTab(contentArea, colors, eventTable, componentHandle)
    local groupTab = createGroupTab(contentArea, colors, eventTable, componentHandle)
    local presetTab = createPresetTab(contentArea, colors, eventTable, componentHandle)
    local settingsTab = createSettingsTab(contentArea, colors, eventTable, componentHandle)
    
    -- Set up event handlers
    local handlers = createComplexEventHandlers(tabButtons, statusLabel, colors)
    
    -- Register all handlers
    for handlerName, handlerFunc in pairs(handlers) do
        eventTable[handlerName] = handlerFunc
    end
    
    Printf("Complex dialog created successfully on display " .. displayIndex)
    Printf("Dialog contains " .. #ComplexDialogConfig.tabs .. " tabs with advanced features")
    
    return baseDialog
end

-- ========================================
-- DEMONSTRATION FUNCTION
-- ========================================

---Run the complex dialog demonstration
---@usage
--- -- Run the demo:
--- runComplexDialogDemo()
function runComplexDialogDemo()
    Printf("Starting Complex Dialog Example...")
    Printf("")
    
    -- Create demo signal table
    local demoSignalTable = {}
    
    -- Create the complex dialog
    local dialog = createComplexDialog(nil, demoSignalTable)
    
    if dialog then
        Printf("✓ Complex dialog created and displayed")
        Printf("✓ Dialog features:")
        Printf("  - Multi-tab interface with 4 tabs")
        Printf("  - Fixture control with parameter faders")
        Printf("  - Group management with selection")
        Printf("  - Preset library browser")
        Printf("  - Settings panel with options")
        Printf("  - Status bar showing current activity")
        Printf("  - Resizable and moveable window")
        Printf("")
        Printf("Try interacting with the dialog:")
        Printf("1. Click different tabs to switch content")
        Printf("2. Adjust parameter faders on Fixture tab")
        Printf("3. Select groups on Group Management tab")
        Printf("4. Browse presets on Preset Library tab")
        Printf("5. Modify settings on Settings tab")
        Printf("6. Watch status updates in title bar")
    else
        Printf("✗ Failed to create complex dialog")
    end
    
    Printf("")
    Printf("Complex Dialog Example completed!")
end

-- Export functions for external use
return {
    createComplexDialog = createComplexDialog,
    runDemo = runComplexDialogDemo,
    ComplexDialogConfig = ComplexDialogConfig
}