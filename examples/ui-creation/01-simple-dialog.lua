---@meta
--- Simple Dialog Creation Example
--- Enhanced version of CreateInputDialog demonstrating basic dialog patterns
--- 
--- This example covers:
--- - Basic dialog structure and layout
--- - Title bar with icon and close button
--- - Simple input fields with validation
--- - Button event handling
--- - Proper dialog cleanup and memory management

---@class SimpleDialogExample
local SimpleDialogExample = {}

-- ========================================
-- DIALOG CONFIGURATION
-- ========================================

---Configuration table for dialog appearance and behavior
local DialogConfig = {
    -- Dialog dimensions
    width = 500,
    minWidth = 400,
    height = 300,
    
    -- Dialog identity
    name = "SimpleExampleDialog",
    title = "Simple Dialog Example",
    subtitle = "Basic input dialog with validation",
    icon = "star",
    
    -- Input field configuration
    inputs = {
        {
            label = "Fixture ID",
            prompt = "Fixture: ",
            filter = "0123456789",
            maxLength = 4,
            icon = "object_fixture",
            validation = "integer"
        },
        {
            label = "Intensity %",
            prompt = "Level: ",
            filter = "0123456789",
            maxLength = 3,
            icon = "intensity",
            validation = "percentage"
        }
    }
}

-- ========================================
-- CORE DIALOG CREATION FUNCTIONS
-- ========================================

---Get appropriate display for dialog creation
---@return Handle display Display handle for dialog placement
---@return number displayIndex Index of the selected display
local function getTargetDisplay()
    -- Get focus display, fallback to display 1 if index > 5
    local displayIndex = Obj.Index(GetFocusDisplay())
    if displayIndex > 5 then
        displayIndex = 1
    end
    
    local display = GetDisplayByIndex(displayIndex)
    Printf("Creating dialog on display " .. displayIndex)
    
    return display, displayIndex
end

---Get MA3 theme colors for consistent styling
---@return table colors Table containing theme color handles
local function getThemeColors()
    local colors = {}
    
    -- Safe color access with fallbacks
    local function safeGetColor(colorPath, fallback)
        local success, color = pcall(function()
            local current = Root().ColorTheme.ColorGroups
            for part in string.gmatch(colorPath, "[^%.]+") do
                current = current[part]
            end
            return current
        end)
        
        return success and color or fallback
    end
    
    colors.transparent = safeGetColor("Global.Transparent", "0,0,0,0")
    colors.background = safeGetColor("Button.Background", "0.2,0.2,0.2,1")
    colors.backgroundPlease = safeGetColor("Button.BackgroundPlease", "0.4,0.6,0.8,1")
    colors.partlySelected = safeGetColor("Global.PartlySelected", "0.3,0.5,0.7,1")
    colors.text = safeGetColor("Global.Text", "1,1,1,1")
    
    return colors
end

---Create the base dialog container
---@param display Handle Display handle for dialog placement
---@param colors table Theme colors
---@return Handle baseInput Main dialog container
local function createDialogBase(display, colors)
    local screenOverlay = display.ScreenOverlay
    
    -- Clear any existing UI elements on the overlay
    screenOverlay:ClearUIChildren()
    Printf("Cleared existing UI elements from overlay")
    
    -- Create the main dialog container
    local baseInput = screenOverlay:Append("BaseInput")
    baseInput.Name = DialogConfig.name
    baseInput.H = tostring(DialogConfig.height)
    baseInput.W = tostring(DialogConfig.width)
    baseInput.MaxSize = string.format("%s,%s", display.W * 0.9, display.H * 0.9)
    baseInput.MinSize = string.format("%s,%s", DialogConfig.minWidth, 250)
    baseInput.Columns = 1
    baseInput.Rows = 2
    
    -- Configure dialog behavior
    baseInput.AutoClose = "No"
    baseInput.CloseOnEscape = "Yes"
    baseInput.Moveable = "Yes"
    baseInput.Resizeable = "Yes"
    
    -- Set up dialog layout
    baseInput[1][1].SizePolicy = "Fixed"
    baseInput[1][1].Size = "50"  -- Title bar height
    baseInput[1][2].SizePolicy = "Stretch"  -- Content area
    
    Printf("Created dialog base: " .. DialogConfig.width .. "x" .. DialogConfig.height)
    
    return baseInput
end

---Create the dialog title bar with icon and close button
---@param baseInput Handle Main dialog container
---@param colors table Theme colors
---@return Handle titleBar Title bar container
local function createTitleBar(baseInput, colors)
    local titleBar = baseInput:Append("TitleBar")
    titleBar.Columns = 2
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar.Texture = "corner2"
    
    -- Configure title bar layout
    titleBar[2][2].SizePolicy = "Fixed"
    titleBar[2][2].Size = "40"  -- Close button width
    
    -- Create title button with icon
    local titleButton = titleBar:Append("TitleButton")
    titleButton.Text = DialogConfig.title
    titleButton.Icon = DialogConfig.icon
    titleButton.Texture = "corner1"
    titleButton.Anchors = "0,0"
    titleButton.Font = "Medium18"
    titleButton.HasHover = "No"
    
    -- Create close button
    local closeButton = titleBar:Append("CloseButton")
    closeButton.Anchors = "1,0"
    closeButton.Texture = "corner2"
    closeButton.HasHover = "Yes"
    
    Printf("Created title bar: " .. DialogConfig.title)
    
    return titleBar
end

---Create the main content frame
---@param baseInput Handle Main dialog container
---@param colors table Theme colors
---@return Handle contentFrame Main content container
local function createContentFrame(baseInput, colors)
    local contentFrame = baseInput:Append("DialogFrame")
    contentFrame.H = "100%"
    contentFrame.W = "100%"
    contentFrame.Columns = 1
    contentFrame.Rows = 4  -- Subtitle, inputs, spacer, buttons
    contentFrame.Anchors = {
        left = 0, right = 0,
        top = 1, bottom = 1
    }
    
    -- Configure content layout
    contentFrame[1][1].SizePolicy = "Fixed"
    contentFrame[1][1].Size = "40"      -- Subtitle
    contentFrame[1][2].SizePolicy = "Fixed"
    contentFrame[1][2].Size = "120"     -- Input area
    contentFrame[1][3].SizePolicy = "Stretch"  -- Spacer
    contentFrame[1][4].SizePolicy = "Fixed"
    contentFrame[1][4].Size = "50"      -- Button area
    
    Printf("Created content frame with 4-row layout")
    
    return contentFrame
end

-- ========================================
-- INPUT CREATION FUNCTIONS
-- ========================================

---Create input validation functions
---@return table validators Table of validation functions
local function createValidators()
    local validators = {}
    
    ---Validate integer input
    ---@param value string Input value to validate
    ---@return boolean isValid True if value is valid integer
    ---@return string message Validation message
    validators.integer = function(value)
        if not value or value == "" then
            return false, "Value is required"
        end
        
        local num = tonumber(value)
        if not num or num ~= math.floor(num) then
            return false, "Must be a whole number"
        end
        
        if num < 1 or num > 9999 then
            return false, "Must be between 1 and 9999"
        end
        
        return true, "Valid"
    end
    
    ---Validate percentage input
    ---@param value string Input value to validate
    ---@return boolean isValid True if value is valid percentage
    ---@return string message Validation message
    validators.percentage = function(value)
        if not value or value == "" then
            return false, "Value is required"
        end
        
        local num = tonumber(value)
        if not num then
            return false, "Must be a number"
        end
        
        if num < 0 or num > 100 then
            return false, "Must be between 0 and 100"
        end
        
        return true, "Valid"
    end
    
    return validators
end

---Create input fields grid
---@param contentFrame Handle Main content container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return table inputElements Array of created input elements
local function createInputFields(contentFrame, colors, signalTable, pluginHandle)
    -- Create subtitle
    local subtitle = contentFrame:Append("UIObject")
    subtitle.Text = DialogConfig.subtitle
    subtitle.Font = "Medium16"
    subtitle.TextalignmentH = "Center"
    subtitle.HasHover = "No"
    subtitle.BackColor = colors.transparent
    subtitle.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    subtitle.Padding = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Create inputs grid
    local inputsGrid = contentFrame:Append("UILayoutGrid")
    inputsGrid.Columns = 10
    inputsGrid.Rows = #DialogConfig.inputs
    inputsGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    inputsGrid.Margin = { left = 10, right = 10, top = 5, bottom = 5 }
    
    local inputElements = {}
    local validators = createValidators()
    
    -- Create each input field
    for i, inputConfig in ipairs(DialogConfig.inputs) do
        local row = i - 1  -- Grid is 0-indexed
        
        -- Create icon
        local icon = inputsGrid:Append("Button")
        icon.Text = ""
        icon.Icon = inputConfig.icon
        icon.HasHover = "No"
        icon.Anchors = { left = 0, right = 0, top = row, bottom = row }
        icon.Margin = { left = 0, right = 5, top = 2, bottom = 2 }
        
        -- Create label
        local label = inputsGrid:Append("UIObject")
        label.Text = inputConfig.label
        label.TextalignmentH = "Left"
        label.HasHover = "No"
        label.Font = "Medium14"
        label.Anchors = { left = 1, right = 5, top = row, bottom = row }
        label.Margin = { left = 5, right = 5, top = 2, bottom = 2 }
        label.Padding = { left = 5, right = 5, top = 8, bottom = 8 }
        
        -- Create input field
        local inputField = inputsGrid:Append("LineEdit")
        inputField.Prompt = inputConfig.prompt
        inputField.Filter = inputConfig.filter
        inputField.MaxTextLength = inputConfig.maxLength
        inputField.Content = ""
        inputField.TextAutoAdjust = "Yes"
        inputField.HideFocusFrame = "No"
        inputField.Anchors = { left = 6, right = 9, top = row, bottom = row }
        inputField.Margin = { left = 5, right = 0, top = 2, bottom = 2 }
        inputField.Padding = { left = 8, right = 8, top = 5, bottom = 5 }
        
        -- Set up input validation
        inputField.PluginComponent = pluginHandle
        inputField.TextChanged = "OnInput" .. i .. "Changed"
        
        -- Create validation handler
        signalTable["OnInput" .. i .. "Changed"] = function(caller)
            local value = caller.Content or ""
            local isValid, message = validators[inputConfig.validation](value)
            
            Printf("Input " .. i .. " (" .. inputConfig.label .. "): '" .. value .. "' - " .. message)
            
            -- Update visual feedback
            if isValid then
                caller.BackColor = colors.background
                label.BackColor = colors.transparent
            else
                caller.BackColor = colors.partlySelected
                label.BackColor = colors.partlySelected
            end
        end
        
        -- Store input elements for later access
        table.insert(inputElements, {
            icon = icon,
            label = label,
            input = inputField,
            config = inputConfig,
            validator = validators[inputConfig.validation]
        })
        
        Printf("Created input field: " .. inputConfig.label)
    end
    
    return inputElements
end

-- ========================================
-- BUTTON CREATION FUNCTIONS
-- ========================================

---Create dialog action buttons
---@param contentFrame Handle Main content container
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@param inputElements table Array of input elements for validation
---@return table buttons Table containing button handles
local function createActionButtons(contentFrame, colors, signalTable, pluginHandle, inputElements)
    -- Create button grid
    local buttonGrid = contentFrame:Append("UILayoutGrid")
    buttonGrid.Columns = 3
    buttonGrid.Rows = 1
    buttonGrid.Anchors = { left = 0, right = 0, top = 3, bottom = 3 }
    buttonGrid.Margin = { left = 10, right = 10, top = 5, bottom = 10 }
    
    -- Create Apply button
    local applyButton = buttonGrid:Append("Button")
    applyButton.Text = "Apply"
    applyButton.Font = "Medium16"
    applyButton.TextalignmentH = "Centre"
    applyButton.HasHover = "Yes"
    applyButton.Textshadow = 1
    applyButton.Icon = "accept"
    applyButton.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    applyButton.Margin = { left = 0, right = 5, top = 0, bottom = 0 }
    applyButton.BackColor = colors.backgroundPlease
    applyButton.PluginComponent = pluginHandle
    applyButton.Clicked = "OnApplyClicked"
    
    -- Create Reset button
    local resetButton = buttonGrid:Append("Button")
    resetButton.Text = "Reset"
    resetButton.Font = "Medium16"
    resetButton.TextalignmentH = "Centre"
    resetButton.HasHover = "Yes"
    resetButton.Textshadow = 1
    resetButton.Icon = "reload"
    resetButton.Anchors = { left = 1, right = 1, top = 0, bottom = 0 }
    resetButton.Margin = { left = 5, right = 5, top = 0, bottom = 0 }
    resetButton.BackColor = colors.background
    resetButton.PluginComponent = pluginHandle
    resetButton.Clicked = "OnResetClicked"
    
    -- Create Cancel button
    local cancelButton = buttonGrid:Append("Button")
    cancelButton.Text = "Cancel"
    cancelButton.Font = "Medium16"
    cancelButton.TextalignmentH = "Centre"
    cancelButton.HasHover = "Yes"
    cancelButton.Textshadow = 1
    cancelButton.Icon = "cancel"
    cancelButton.Anchors = { left = 2, right = 2, top = 0, bottom = 0 }
    cancelButton.Margin = { left = 5, right = 0, top = 0, bottom = 0 }
    cancelButton.BackColor = colors.background
    cancelButton.PluginComponent = pluginHandle
    cancelButton.Clicked = "OnCancelClicked"
    
    Printf("Created action buttons: Apply, Reset, Cancel")
    
    return {
        apply = applyButton,
        reset = resetButton,
        cancel = cancelButton
    }
end

-- ========================================
-- EVENT HANDLERS
-- ========================================

---Create event handler functions
---@param inputElements table Array of input elements
---@param buttons table Button handles
---@param baseInput Handle Main dialog container
---@param colors table Theme colors
---@return table handlers Table of event handler functions
local function createEventHandlers(inputElements, buttons, baseInput, colors)
    local handlers = {}
    
    ---Handle Apply button click - validate and process inputs
    handlers.OnApplyClicked = function(caller)
        Printf("Apply button clicked - validating inputs...")
        
        local allValid = true
        local values = {}
        
        -- Validate all inputs
        for i, element in ipairs(inputElements) do
            local value = element.input.Content or ""
            local isValid, message = element.validator(value)
            
            if not isValid then
                Printf("Validation failed for " .. element.config.label .. ": " .. message)
                allValid = false
                
                -- Highlight invalid field
                element.input.BackColor = colors.partlySelected
                element.label.BackColor = colors.partlySelected
            else
                values[element.config.label] = value
                
                -- Clear highlighting
                element.input.BackColor = colors.background
                element.label.BackColor = colors.transparent
            end
        end
        
        if allValid then
            Printf("All inputs valid - processing data...")
            
            -- Process the validated data
            for label, value in pairs(values) do
                Printf("Processing: " .. label .. " = " .. value)
            end
            
            -- Example: Execute command with validated data
            if values["Fixture ID"] and values["Intensity %"] then
                local command = "Fixture " .. values["Fixture ID"] .. " At " .. values["Intensity %"]
                Printf("Would execute: " .. command)
                -- Cmd(command)  -- Uncomment to actually execute
            end
            
            -- Provide visual feedback
            caller.BackColor = colors.backgroundPlease
            caller.Text = "Applied!"
            
            -- Reset button text after delay (simulated)
            -- In real implementation, you might use a timer
            Printf("Command applied successfully")
        else
            Printf("Validation failed - please correct invalid inputs")
            
            -- Provide error feedback
            caller.BackColor = colors.partlySelected
        end
    end
    
    ---Handle Reset button click - clear all inputs
    handlers.OnResetClicked = function(caller)
        Printf("Reset button clicked - clearing all inputs...")
        
        for i, element in ipairs(inputElements) do
            element.input.Content = ""
            element.input.BackColor = colors.background
            element.label.BackColor = colors.transparent
        end
        
        -- Reset apply button
        buttons.apply.BackColor = colors.backgroundPlease
        buttons.apply.Text = "Apply"
        
        Printf("All inputs cleared")
    end
    
    ---Handle Cancel button click - close dialog
    handlers.OnCancelClicked = function(caller)
        Printf("Cancel button clicked - closing dialog...")
        
        -- Get the screen overlay to delete the dialog
        local display = baseInput.parent
        if display and display.ScreenOverlay then
            display.ScreenOverlay:ClearUIChildren()
            Printf("Dialog closed and cleaned up")
        else
            Printf("Warning: Could not properly close dialog")
        end
    end
    
    return handlers
end

-- ========================================
-- MAIN DIALOG CREATION FUNCTION
-- ========================================

---Create a complete simple dialog with inputs and validation
---@param pluginHandle? Handle Optional plugin component handle
---@param signalTable? table Optional signal table for event handlers
---@return Handle|nil dialog Created dialog handle or nil if failed
---@usage
--- -- From a plugin:
--- local dialog = createSimpleDialog(myHandle, signalTable)
--- 
--- -- Standalone usage:
--- local dialog = createSimpleDialog()
function createSimpleDialog(pluginHandle, signalTable)
    Printf("Creating simple dialog example...")
    
    -- Initialize signal table if not provided
    local eventTable = signalTable or {}
    local componentHandle = pluginHandle or Obj()
    
    -- Get display and colors
    local display, displayIndex = getTargetDisplay()
    if not display then
        Printf("Error: Could not get target display")
        return nil
    end
    
    local colors = getThemeColors()
    
    -- Create dialog structure
    local baseInput = createDialogBase(display, colors)
    local titleBar = createTitleBar(baseInput, colors)
    local contentFrame = createContentFrame(baseInput, colors)
    
    -- Create input fields
    local inputElements = createInputFields(contentFrame, colors, eventTable, componentHandle)
    
    -- Create buttons
    local buttons = createActionButtons(contentFrame, colors, eventTable, componentHandle, inputElements)
    
    -- Set up event handlers
    local handlers = createEventHandlers(inputElements, buttons, baseInput, colors)
    
    -- Register handlers in signal table
    for handlerName, handlerFunc in pairs(handlers) do
        eventTable[handlerName] = handlerFunc
    end
    
    Printf("Simple dialog created successfully on display " .. displayIndex)
    Printf("Dialog contains " .. #inputElements .. " input fields")
    
    return baseInput
end

-- ========================================
-- DEMONSTRATION FUNCTION
-- ========================================

---Run the simple dialog demonstration
---This creates and displays the dialog for testing
---@usage
--- -- Run the demo:
--- runSimpleDialogDemo()
function runSimpleDialogDemo()
    Printf("Starting Simple Dialog Example...")
    Printf("")
    
    -- Create a mock signal table for demo
    local demoSignalTable = {}
    
    -- Create the dialog
    local dialog = createSimpleDialog(nil, demoSignalTable)
    
    if dialog then
        Printf("✓ Simple dialog created and displayed")
        Printf("✓ Dialog features:")
        Printf("  - Title bar with icon and close button")
        Printf("  - Two validated input fields")
        Printf("  - Apply, Reset, and Cancel buttons")
        Printf("  - Real-time input validation")
        Printf("  - Proper error handling and feedback")
        Printf("")
        Printf("Try interacting with the dialog:")
        Printf("1. Enter values in the input fields")
        Printf("2. Watch validation feedback")
        Printf("3. Click Apply to process data")
        Printf("4. Use Reset to clear inputs")
        Printf("5. Click Cancel or X to close")
    else
        Printf("✗ Failed to create simple dialog")
    end
    
    Printf("")
    Printf("Simple Dialog Example completed!")
end

-- Export functions for external use
return {
    createSimpleDialog = createSimpleDialog,
    runDemo = runSimpleDialogDemo,
    DialogConfig = DialogConfig,
    getTargetDisplay = getTargetDisplay,
    getThemeColors = getThemeColors
}