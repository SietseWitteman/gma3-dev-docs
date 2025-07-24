---@meta
--- UI Elements Enumerations  
--- Dialog types, button states, input modes, and interface elements
--- 
--- These enumerations define user interface elements, states, and behaviors
--- used in dialog creation, button assignments, and user interaction handling.

---@class UIElementEnums
local UIElementEnums = {}

-- ========================================
-- DIALOG TYPES AND MODES
-- ========================================

---@enum DialogType
--- Types of dialogs available for user interaction
UIElementEnums.DialogType = {
    Input = 1,
    CheckBox = 2,
    Fader = 3,
    Custom = 4,
    Message = 5,
    Confirmation = 6
}

---@enum DialogResult
--- Standard dialog result values
UIElementEnums.DialogResult = {
    Cancel = 0,
    OK = 1,
    Yes = 2,
    No = 3,
    Retry = 4,
    Abort = 5
}

---@enum InputMode
--- Types of input modes for dialog elements
UIElementEnums.InputMode = {
    Text = 0,
    Numeric = 1,
    Selection = 2,
    MultiSelection = 3,
    Password = 4
}

-- ========================================
-- BUTTON STATES AND FUNCTIONS
-- ========================================

---@enum ButtonState
--- States that buttons can be in
UIElementEnums.ButtonState = {
    Released = 0,
    Pressed = 1,
    Active = 2,
    Inactive = 3,
    Disabled = 4,
    Hidden = 5
}

---@enum AssignmentButtonFunctions
--- General button assignment functions
UIElementEnums.AssignmentButtonFunctions = {
    Empty = 0,
    Temp = 1,
    Top = 2,
    Set = 3,
    Go_minus = 4,
    Pause = 5,
    Go_plus = 6,
    Select = 7,
    Off = 8,
    On = 9,
    Toggle = 10,
    Flash = 11,
    Black = 12,
    Master = 13,
    Rate = 14,
    Speed = 15,
    Time = 16
}

---@enum AssignmentButtonFunctionsSequence
--- Sequence-specific button functions
UIElementEnums.AssignmentButtonFunctionsSequence = {
    Go_minus = 0,
    Pause = 1, 
    Go_plus = 2,
    Select = 3,
    Off = 4,
    On = 5,
    Toggle = 6,
    Flash = 7,
    Black = 8,
    Rate = 9,
    Speed = 10,
    Time = 11,
    Master = 12,
    Temp = 13,
    Top = 14
}

---@enum AssignmentButtonFunctionsGroup
--- Group-specific button functions
UIElementEnums.AssignmentButtonFunctionsGroup = {
    Select = 0,
    SelectFixtures = 1,
    Flash = 2,
    Temp = 3,
    Solo = 4,
    OOn = 5, -- "OOn" as defined in original enum
    OOff = 6 -- "OOff" as defined in original enum
}

---@enum AssignmentButtonFunctionsPreset
--- Preset-specific button functions
UIElementEnums.AssignmentButtonFunctionsPreset = {
    Call = 0,
    Off = 1,
    Select = 2,
    SelectFixtures = 3,
    Toggle = 4
}

---@enum AssignmentButtonFunctionsMacro
--- Macro-specific button functions
UIElementEnums.AssignmentButtonFunctionsMacro = {
    Call = 0,
    Off = 1,
    Select = 2
}

-- ========================================
-- FADER FUNCTIONS AND STATES
-- ========================================

---@enum AssignmentFaderFunctions
--- General fader assignment functions
UIElementEnums.AssignmentFaderFunctions = {
    Empty = 0,
    Master = 1,
    Rate = 2,
    Speed = 3,
    Time = 4,
    Temp = 5,
    Highlight = 6,
    Solo = 7,
    XFade = 8
}

---@enum AssignmentFaderFunctionsSubTrack
--- Sub-track specific fader functions
UIElementEnums.AssignmentFaderFunctionsSubTrack = {
    Master = 0,
    Rate = 1,
    Speed = 2,
    Time = 3
}

---@enum FaderType
--- Types of faders in the system
UIElementEnums.FaderType = {
    Linear = 0,
    Rotary = 1,
    Touch = 2,
    Virtual = 3
}

---@enum FaderMode
--- Operational modes for faders
UIElementEnums.FaderMode = {
    Normal = 0,
    Inverted = 1,
    Scaled = 2,
    Stepped = 3
}

-- ========================================
-- DISPLAY AND VIEW ELEMENTS
-- ========================================

---@enum ActiveDisplay
--- Types of active display modes
UIElementEnums.ActiveDisplay = {
    Wave = 0,
    Sound = 1,
    Beat = 2
}

---@enum ViewMode
--- Different view modes for interfaces
UIElementEnums.ViewMode = {
    List = 0,
    Grid = 1,
    Sheet = 2,
    Timeline = 3,
    Graph = 4
}

---@enum LayoutMode
--- UI layout arrangement modes
UIElementEnums.LayoutMode = {
    Fixed = 0,
    Auto = 1,
    Flexible = 2,
    Responsive = 3
}

---@enum AlignmentH
--- Horizontal alignment options
UIElementEnums.AlignmentH = {
    Left = 0,
    Center = 1,
    Right = 2,
    Justify = 3
}

---@enum AlignmentV
--- Vertical alignment options
UIElementEnums.AlignmentV = {
    Top = 0,
    Center = 1,
    Bottom = 2,
    Baseline = 3
}

-- ========================================
-- SCREEN AND WINDOW MANAGEMENT
-- ========================================

---@enum AssignmentButtonFunctionsScreenConfig
--- Screen configuration button functions
UIElementEnums.AssignmentButtonFunctionsScreenConfig = {
    Call = 0,
    Select = 1
}

---@enum AssignmentButtonFunctionsView
--- View-specific button functions
UIElementEnums.AssignmentButtonFunctionsView = {
    Call = 0,
    Select = 1,
    Off = 2
}

---@enum WindowState
--- States that windows can be in
UIElementEnums.WindowState = {
    Normal = 0,
    Minimized = 1,
    Maximized = 2,
    Hidden = 3,
    Fullscreen = 4
}

-- ========================================
-- USER INTERACTION STATES
-- ========================================

---@enum InteractionState
--- States of user interaction elements
UIElementEnums.InteractionState = {
    Idle = 0,
    Hover = 1,
    Active = 2,
    Pressed = 3,
    Selected = 4,
    Disabled = 5
}

---@enum InputValidation
--- Input validation states
UIElementEnums.InputValidation = {
    Valid = 0,
    Invalid = 1,
    Required = 2,
    OutOfRange = 3,
    FormatError = 4
}

-- ========================================
-- USAGE EXAMPLES
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Dialog Creation with Type Checking:
   local function createDialog(dialogType, options, callback)
       if dialogType == UIElementEnums.DialogType.Input then
           CreateInputDialog(options.title, options.prompt, callback)
       elseif dialogType == UIElementEnums.DialogType.CheckBox then
           CreateCheckBoxDialog(options.title, options.choices, callback)
       end
   end

2. Button State Management:
   local function updateButtonState(button, newState)
       if newState == UIElementEnums.ButtonState.Pressed then
           button:SetPressed(true)
       elseif newState == UIElementEnums.ButtonState.Released then
           button:SetPressed(false)
       elseif newState == UIElementEnums.ButtonState.Disabled then
           button:SetEnabled(false)
       end
   end

3. Fader Function Assignment:
   local function assignFaderFunction(fader, functionType)
       if functionType == UIElementEnums.AssignmentFaderFunctions.Master then
           fader:SetFunction("Master")
       elseif functionType == UIElementEnums.AssignmentFaderFunctions.Rate then
           fader:SetFunction("Rate")
       end
   end

4. Input Validation:
   local function validateInput(input, validationType)
       if validationType == UIElementEnums.InputMode.Numeric then
           local num = tonumber(input)
           return num ~= nil and UIElementEnums.InputValidation.Valid or UIElementEnums.InputValidation.FormatError
       elseif validationType == UIElementEnums.InputMode.Text then
           return input ~= "" and UIElementEnums.InputValidation.Valid or UIElementEnums.InputValidation.Required
       end
   end

5. Display Mode Switching:
   local function setDisplayMode(display, mode)
       if mode == UIElementEnums.ActiveDisplay.Wave then
           display:ShowWaveform()
       elseif mode == UIElementEnums.ActiveDisplay.Beat then
           display:ShowBeatIndicator()
       end
   end

INTEGRATION WITH MA3 DIALOG FUNCTIONS:
- CreateInputDialog() uses DialogType.Input patterns
- CreateCheckBoxDialog() uses DialogType.CheckBox patterns
- CreateFaderDialog() uses DialogType.Fader patterns
- Button assignments use AssignmentButtonFunctions values

CROSS-REFERENCES TO HANDLE METHODS:
- Button functions work with Handle:SetFader() method
- Display modes integrate with Handle:GetUIEditor()
- View modes connect to Handle:GetUISettings()
- Dialog results affect Handle property updates

PERFORMANCE CONSIDERATIONS:
- Cache enum values for frequently used UI operations
- Use enum comparisons instead of string matching
- Validate enum values before UI operations
- Handle invalid enum values gracefully
]]

return UIElementEnums