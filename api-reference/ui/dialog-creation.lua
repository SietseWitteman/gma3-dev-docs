---@meta
--- Dialog Creation API Reference
--- Complete reference for creating interactive dialogs in MA3 plugins
--- 
--- This module provides methods and patterns for creating various types of dialogs
--- including input dialogs, checkboxes, faders, and custom dialog layouts.

---@class DialogCreation
local DialogCreation = {}

-- ========================================
-- BASIC DIALOG FUNCTIONS
-- ========================================

---Create an input dialog for text or numeric input
---@param title string Dialog window title
---@param prompt string User prompt text
---@param callback function Function called with user input (result: string|nil)
---@param options? table Optional dialog configuration
---@usage
--- CreateInputDialog("Plugin Settings", "Enter fixture count:", function(result)
---     if result and result ~= "" then
---         local count = tonumber(result)
---         if count then
---             Printf("Setting fixture count to: " .. count)
---         end
---     end
--- end)
function CreateInputDialog(title, prompt, callback, options)
end

---Create a checkbox dialog for multiple choice selection
---@param title string Dialog window title
---@param choices table Array of choice strings
---@param callback function Function called with selection array (result: boolean[])
---@param options? table Optional dialog configuration
---@usage
--- local options = {"Fixtures", "Groups", "Presets", "Cues"}
--- CreateCheckBoxDialog("Select Types", options, function(result)
---     for i, selected in ipairs(result) do
---         if selected then
---             Printf("Selected: " .. options[i])
---         end
---     end
--- end)
function CreateCheckBoxDialog(title, choices, callback, options)
end

---Create a fader dialog for numeric value selection
---@param title string Dialog window title
---@param min number Minimum value
---@param max number Maximum value
---@param default number Default/initial value
---@param callback function Function called with selected value (result: number|nil)
---@param options? table Optional dialog configuration
---@usage
--- CreateFaderDialog("Set Intensity", 0, 100, 50, function(result)
---     if result then
---         Printf("Intensity set to: " .. result .. "%")
---         Cmd("At " .. result)
---     end
--- end)
function CreateFaderDialog(title, min, max, default, callback, options)
end

---Create a confirmation dialog with Yes/No options
---@param title string Dialog window title
---@param message string Confirmation message
---@param callback function Function called with user choice (result: boolean)
---@param options? table Optional dialog configuration
---@usage
--- CreateConfirmDialog("Delete Cue", "Are you sure you want to delete Cue 1?", function(confirmed)
---     if confirmed then
---         Cmd("Delete Cue 1")
---         Printf("Cue 1 deleted")
---     end
--- end)
function CreateConfirmDialog(title, message, callback, options)
end

-- ========================================
-- ADVANCED DIALOG CREATION
-- ========================================

---Create a custom dialog with specified UI elements
---@param title string Dialog window title
---@param elements table Array of UI element definitions
---@param callback function Function called with dialog results
---@param options? table Optional dialog configuration
---@usage
--- local elements = {
---     {type = "input", label = "Name:", default = ""},
---     {type = "slider", label = "Value:", min = 0, max = 100, default = 50},
---     {type = "checkbox", label = "Enable feature", default = false}
--- }
--- CreateCustomDialog("Advanced Settings", elements, function(results)
---     Printf("Name: " .. results.name)
---     Printf("Value: " .. results.value)
---     Printf("Enabled: " .. tostring(results.enabled))
--- end)
function CreateCustomDialog(title, elements, callback, options)
end

---Create a list selection dialog
---@param title string Dialog window title
---@param items table Array of selectable items
---@param callback function Function called with selected item (result: string|nil)
---@param options? table Optional dialog configuration (multiSelect, etc.)
---@usage
--- local fixtures = {"Moving Light 1", "LED Strip 2", "Par Can 3"}
--- CreateListDialog("Select Fixture", fixtures, function(selected)
---     if selected then
---         Printf("Selected fixture: " .. selected)
---         Cmd("Select Fixture \"" .. selected .. "\"")
---     end
--- end)
function CreateListDialog(title, items, callback, options)
end

-- ========================================
-- DIALOG DISPLAY AND MANAGEMENT
-- ========================================

---Get the display index for dialog placement
---@param preferredDisplay? integer Optional preferred display index
---@return integer displayIndex Valid display index (1-5)
---@usage
--- local displayIndex = GetDialogDisplayIndex(2)
--- local display = GetDisplayByIndex(displayIndex)
function GetDialogDisplayIndex(preferredDisplay)
    local displayIndex = Obj.Index(GetFocusDisplay())
    if displayIndex > 5 then
        displayIndex = 1
    end
    if preferredDisplay and preferredDisplay >= 1 and preferredDisplay <= 5 then
        displayIndex = preferredDisplay
    end
    return displayIndex
end

---Get display object by index
---@param displayIndex integer Display index (1-5)
---@return table display Display object
---@usage
--- local display = GetDisplayByIndex(1)
--- local overlay = display.ScreenOverlay
function GetDisplayByIndex(displayIndex)
    -- Implementation depends on MA3 API
    return {}
end

---Get the focused display for dialog placement
---@return table display Currently focused display
---@usage
--- local focusedDisplay = GetFocusDisplay()
--- local displayIndex = Obj.Index(focusedDisplay)
function GetFocusDisplay()
    -- Implementation depends on MA3 API
    return {}
end

-- ========================================
-- CUSTOM DIALOG BUILDING
-- ========================================

---Create a dialog base structure
---@param display table Display object
---@param title string Dialog title
---@param width number Dialog width in pixels
---@return table baseDialog Dialog base object
---@usage
--- local display = GetDisplayByIndex(1)
--- local dialog = CreateDialogBase(display, "My Dialog", 650)
--- -- Add UI elements to dialog
function CreateDialogBase(display, title, width)
    local screenOverlay = display.ScreenOverlay
    
    -- Clear existing UI elements
    screenOverlay:ClearUIChildren()
    
    -- Create dialog base
    local baseInput = screenOverlay:Append("BaseInput")
    baseInput.Name = title .. "Window"
    baseInput.H = "0"
    baseInput.W = width
    baseInput.MaxSize = string.format("%s,%s", display.W * 0.8, display.H)
    baseInput.MinSize = string.format("%s,0", width - 100)
    baseInput.Columns = 1
    baseInput.Rows = 2
    baseInput[1][1].SizePolicy = "Fixed"
    baseInput[1][1].Size = "60"
    baseInput[1][2].SizePolicy = "Stretch"
    baseInput.AutoClose = "No"
    baseInput.CloseOnEscape = "Yes"
    
    return baseInput
end

---Create a title bar for a dialog
---@param dialog table Dialog base object
---@param title string Title text
---@param icon? string Optional icon name
---@return table titleBar Title bar object
---@usage
--- local titleBar = CreateDialogTitleBar(dialog, "Settings", "gear")
function CreateDialogTitleBar(dialog, title, icon)
    local titleBar = dialog:Append("TitleBar")
    titleBar.Columns = 2
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar[2][2].SizePolicy = "Fixed"
    titleBar[2][2].Size = "50"
    titleBar.Texture = "corner2"
    
    local titleBarIcon = titleBar:Append("TitleButton")
    titleBarIcon.Text = title
    titleBarIcon.Texture = "corner1"
    titleBarIcon.Anchors = "0,0"
    if icon then
        titleBarIcon.Icon = icon
    end
    
    local titleBarCloseButton = titleBar:Append("CloseButton")
    titleBarCloseButton.Anchors = "1,0"
    
    return titleBar
end

---Add an input field to a dialog
---@param parent table Parent container
---@param label string Field label
---@param default? string Default value
---@return table inputField Input field object
---@usage
--- local input = AddInputField(contentArea, "Fixture Name:", "Moving Light")
function AddInputField(parent, label, default)
    local container = parent:Append("UILayoutFrame")
    container.Columns = 2
    container.Rows = 1
    
    local labelElement = container:Append("UILabel")
    labelElement.Text = label
    labelElement.Anchors = "0,0.5"
    
    local inputElement = container:Append("UITextInput")
    if default then
        inputElement.Text = default
    end
    inputElement.Anchors = "1,0.5"
    
    return inputElement
end

---Add a checkbox to a dialog
---@param parent table Parent container
---@param label string Checkbox label
---@param default? boolean Default checked state
---@return table checkbox Checkbox object
---@usage
--- local checkbox = AddCheckBox(contentArea, "Enable feature", true)
function AddCheckBox(parent, label, default)
    local container = parent:Append("UILayoutFrame")
    container.Columns = 2
    container.Rows = 1
    
    local checkboxElement = container:Append("UICheckButton")
    if default then
        checkboxElement.Checked = "Yes"
    end
    checkboxElement.Anchors = "0,0.5"
    
    local labelElement = container:Append("UILabel")
    labelElement.Text = label
    labelElement.Anchors = "0,0.5"
    
    return checkboxElement
end

---Add a slider to a dialog
---@param parent table Parent container
---@param label string Slider label
---@param min number Minimum value
---@param max number Maximum value
---@param default? number Default value
---@return table slider Slider object
---@usage
--- local slider = AddSlider(contentArea, "Intensity:", 0, 100, 50)
function AddSlider(parent, label, min, max, default)
    local container = parent:Append("UILayoutFrame")
    container.Columns = 1
    container.Rows = 2
    
    local labelElement = container:Append("UILabel")
    labelElement.Text = label
    labelElement.Anchors = "0,0"
    
    local sliderElement = container:Append("UISlider")
    sliderElement.Min = min
    sliderElement.Max = max
    if default then
        sliderElement.Value = default
    end
    sliderElement.Anchors = "0,0"
    
    return sliderElement
end

-- ========================================
-- DIALOG STYLING AND THEMING
-- ========================================

---Get MA3 color theme colors for consistent styling
---@return table colors Table of theme colors
---@usage
--- local colors = GetThemeColors()
--- element.BackgroundColor = colors.background
function GetThemeColors()
    return {
        transparent = Root().ColorTheme.ColorGroups.Global.Transparent,
        background = Root().ColorTheme.ColorGroups.Button.Background,
        backgroundPlease = Root().ColorTheme.ColorGroups.Button.BackgroundPlease,
        partlySelected = Root().ColorTheme.ColorGroups.Global.PartlySelected,
        partlySelectedPreset = Root().ColorTheme.ColorGroups.Global.PartlySelectedPreset,
        text = Root().ColorTheme.ColorGroups.Global.Text or "White",
        border = Root().ColorTheme.ColorGroups.Global.Border or "Gray"
    }
end

---Apply consistent styling to a dialog
---@param dialog table Dialog object
---@param style? table Optional style overrides
---@usage
--- ApplyDialogStyling(dialog, {backgroundColor = "DarkBlue"})
function ApplyDialogStyling(dialog, style)
    local colors = GetThemeColors()
    local defaultStyle = {
        backgroundColor = colors.background,
        textColor = colors.text,
        borderColor = colors.border
    }
    
    -- Merge with provided style
    if style then
        for key, value in pairs(style) do
            defaultStyle[key] = value
        end
    end
    
    -- Apply styling
    if dialog.BackgroundColor then
        dialog.BackgroundColor = defaultStyle.backgroundColor
    end
    if dialog.TextColor then
        dialog.TextColor = defaultStyle.textColor
    end
end

-- ========================================
-- DIALOG EVENT HANDLING
-- ========================================

---Set up dialog event handlers
---@param dialog table Dialog object
---@param handlers table Event handler functions
---@usage
--- SetupDialogEvents(dialog, {
---     onClose = function() Printf("Dialog closed") end,
---     onOK = function(data) processDialogData(data) end
--- })
function SetupDialogEvents(dialog, handlers)
    if handlers.onClose and dialog.CloseButton then
        dialog.CloseButton.OnClick = handlers.onClose
    end
    
    if handlers.onOK and dialog.OKButton then
        dialog.OKButton.OnClick = handlers.onOK
    end
    
    if handlers.onCancel and dialog.CancelButton then
        dialog.CancelButton.OnClick = handlers.onCancel
    end
end

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

---Validate dialog input
---@param input string Input to validate
---@param type string Validation type ("number", "text", "integer")
---@param constraints? table Optional constraints (min, max, required)
---@return boolean valid True if input is valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateDialogInput("50", "number", {min = 0, max = 100})
--- if not valid then
---     Printf("Invalid input: " .. error)
--- end
function ValidateDialogInput(input, type, constraints)
    constraints = constraints or {}
    
    if constraints.required and (not input or input == "") then
        return false, "This field is required"
    end
    
    if type == "number" or type == "integer" then
        local num = tonumber(input)
        if not num then
            return false, "Must be a valid number"
        end
        
        if type == "integer" and math.floor(num) ~= num then
            return false, "Must be a whole number"
        end
        
        if constraints.min and num < constraints.min then
            return false, "Must be at least " .. constraints.min
        end
        
        if constraints.max and num > constraints.max then
            return false, "Must be at most " .. constraints.max
        end
    end
    
    if type == "text" and constraints.maxLength then
        if #input > constraints.maxLength then
            return false, "Must be " .. constraints.maxLength .. " characters or less"
        end
    end
    
    return true
end

---Close all open dialogs
---@usage
--- CloseAllDialogs() -- Clean up before creating new dialog
function CloseAllDialogs()
    for i = 1, 5 do
        local display = GetDisplayByIndex(i)
        if display and display.ScreenOverlay then
            display.ScreenOverlay:ClearUIChildren()
        end
    end
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Simple Input Dialog:
   CreateInputDialog("Enter Value", "Please enter a number:", function(result)
       if result and result ~= "" then
           local num = tonumber(result)
           if num then
               -- Process the number
               Printf("Got number: " .. num)
           else
               -- Show error dialog
               CreateInputDialog("Error", "Please enter a valid number:", callback)
           end
       end
   end)

2. Multi-Step Dialog Process:
   local function step1()
       CreateInputDialog("Step 1", "Enter name:", function(name)
           if name and name ~= "" then
               step2(name)
           end
       end)
   end
   
   local function step2(name)
       CreateCheckBoxDialog("Step 2", {"Option A", "Option B"}, function(choices)
           -- Process both name and choices
           processData(name, choices)
       end)
   end

3. Validation with Retry:
   local function createValidatedDialog(title, prompt, validator, callback)
       CreateInputDialog(title, prompt, function(result)
           if not result then return end
           
           local valid, error = validator(result)
           if valid then
               callback(result)
           else
               createValidatedDialog("Error: " .. error, prompt, validator, callback)
           end
       end)
   end

4. Custom Complex Dialog:
   local function createSettingsDialog()
       local display = GetDisplayByIndex(1)
       local dialog = CreateDialogBase(display, "Plugin Settings", 800)
       local titleBar = CreateDialogTitleBar(dialog, "Settings", "gear")
       
       -- Add various input elements
       local nameInput = AddInputField(dialog, "Plugin Name:", "MyPlugin")
       local enabledCheck = AddCheckBox(dialog, "Enabled", true)
       local intensitySlider = AddSlider(dialog, "Default Intensity:", 0, 100, 75)
       
       -- Set up event handling
       SetupDialogEvents(dialog, {
           onOK = function()
               local settings = {
                   name = nameInput.Text,
                   enabled = enabledCheck.Checked == "Yes",
                   intensity = intensitySlider.Value
               }
               processSettings(settings)
           end
       })
   end

INTEGRATION POINTS:
- Use with Handle methods for object selection dialogs
- Integrate with Command API for immediate action execution
- Connect to plugin configuration for settings dialogs
- Link with validation utilities for input checking

PERFORMANCE CONSIDERATIONS:
- Close dialogs when not needed with CloseAllDialogs()
- Cache display objects for repeated dialog creation
- Use appropriate dialog types for different input needs
- Validate input early to prevent processing overhead
]]

return DialogCreation