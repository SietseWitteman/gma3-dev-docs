---@meta
--- User Input API Reference
--- Input capture, processing, event handling, and user interaction methods
--- 
--- This module provides methods for handling user input, processing events,
--- validating data, and managing user interaction states in MA3 plugins.

---@class UserInput
local UserInput = {}

-- ========================================
-- INPUT EVENT HANDLING
-- ========================================

---Set up event handler for UI element clicks
---@param element table UI element object
---@param handler function Click event handler function
---@usage
--- SetupClickHandler(button, function()
---     Printf("Button clicked!")
---     processButtonClick()
--- end)
function SetupClickHandler(element, handler)
    if element and handler then
        element.OnClick = handler
    end
end

---Set up event handler for text input changes
---@param element table Text input element
---@param handler function Change event handler function (newValue: string)
---@usage
--- SetupTextChangeHandler(textInput, function(newValue)
---     if validateInput(newValue) then
---         processTextChange(newValue)
---     end
--- end)
function SetupTextChangeHandler(element, handler)
    if element and handler then
        element.OnTextChanged = handler
    end
end

---Set up event handler for slider value changes
---@param element table Slider element
---@param handler function Value change handler (newValue: number)
---@usage
--- SetupSliderHandler(slider, function(newValue)
---     Printf("Slider value: " .. newValue)
---     updateIntensity(newValue)
--- end)
function SetupSliderHandler(element, handler)
    if element and handler then
        element.OnValueChanged = handler
    end
end

---Set up event handler for checkbox state changes
---@param element table Checkbox element
---@param handler function State change handler (isChecked: boolean)
---@usage
--- SetupCheckboxHandler(checkbox, function(isChecked)
---     Printf("Checkbox " .. (isChecked and "checked" or "unchecked"))
---     toggleFeature(isChecked)
--- end)
function SetupCheckboxHandler(element, handler)
    if element and handler then
        element.OnCheckedChanged = function()
            handler(element.Checked == "Yes")
        end
    end
end

---Set up keyboard event handler
---@param element table UI element
---@param handler function Key event handler (keyCode: integer, modifiers: table)
---@usage
--- SetupKeyHandler(dialog, function(keyCode, modifiers)
---     if keyCode == 13 then -- Enter key
---         processDialogSubmit()
---     elseif keyCode == 27 then -- Escape key
---         closeDialog()
---     end
--- end)
function SetupKeyHandler(element, handler)
    if element and handler then
        element.OnKeyPress = handler
    end
end

-- ========================================
-- INPUT VALIDATION
-- ========================================

---Validate numeric input
---@param input string Input string to validate
---@param constraints? table Optional constraints {min, max, integer, required}
---@return boolean valid True if input is valid
---@return number|nil value Parsed numeric value if valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, value, error = ValidateNumericInput("50", {min = 0, max = 100})
--- if not valid then
---     ShowErrorMessage(error)
--- end
function ValidateNumericInput(input, constraints)
    constraints = constraints or {}
    
    -- Check if required
    if constraints.required and (not input or input == "") then
        return false, nil, "This field is required"
    end
    
    -- Allow empty input if not required
    if not input or input == "" then
        return true, nil, nil
    end
    
    -- Parse number
    local value = tonumber(input)
    if not value then
        return false, nil, "Must be a valid number"
    end
    
    -- Check integer constraint
    if constraints.integer and math.floor(value) ~= value then
        return false, nil, "Must be a whole number"
    end
    
    -- Check range constraints
    if constraints.min and value < constraints.min then
        return false, nil, "Must be at least " .. constraints.min
    end
    
    if constraints.max and value > constraints.max then
        return false, nil, "Must be at most " .. constraints.max
    end
    
    return true, value, nil
end

---Validate text input
---@param input string Input string to validate
---@param constraints? table Optional constraints {required, minLength, maxLength, pattern, allowEmpty}
---@return boolean valid True if input is valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateTextInput(name, {
---     required = true,
---     minLength = 3,
---     maxLength = 50,
---     pattern = "^[%w%s]+$"
--- })
function ValidateTextInput(input, constraints)
    constraints = constraints or {}
    
    -- Check if required
    if constraints.required and (not input or input == "") then
        return false, "This field is required"
    end
    
    -- Allow empty input if not required
    if not input or input == "" then
        if constraints.allowEmpty ~= false then
            return true, nil
        else
            return false, "This field cannot be empty"
        end
    end
    
    -- Check length constraints
    if constraints.minLength and #input < constraints.minLength then
        return false, "Must be at least " .. constraints.minLength .. " characters"
    end
    
    if constraints.maxLength and #input > constraints.maxLength then
        return false, "Must be " .. constraints.maxLength .. " characters or less"
    end
    
    -- Check pattern constraint
    if constraints.pattern and not input:match(constraints.pattern) then
        return false, "Invalid format"
    end
    
    return true, nil
end

---Validate selection input (for dropdowns, lists, etc.)
---@param selection any Selected value
---@param validOptions table Array of valid options
---@param required? boolean Whether selection is required (default: true)
---@return boolean valid True if selection is valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateSelectionInput(selectedOption, {"Option A", "Option B", "Option C"})
function ValidateSelectionInput(selection, validOptions, required)
    required = required ~= false -- Default to true
    
    if required and (not selection or selection == "") then
        return false, "Please make a selection"
    end
    
    if not selection or selection == "" then
        return true, nil -- Not required and empty
    end
    
    -- Check if selection is in valid options
    for _, option in ipairs(validOptions) do
        if selection == option then
            return true, nil
        end
    end
    
    return false, "Invalid selection"
end

-- ========================================
-- INPUT PROCESSING AND CONVERSION
-- ========================================

---Process and sanitize text input
---@param input string Raw input text
---@param options? table Processing options {trim, lowercase, uppercase, removeSpecial}
---@return string processed Processed input text
---@usage
--- local clean = ProcessTextInput(" User Input! ", {trim = true, removeSpecial = true})
--- -- Returns "User Input"
function ProcessTextInput(input, options)
    if not input then return "" end
    
    options = options or {}
    local processed = input
    
    -- Trim whitespace
    if options.trim then
        processed = processed:match("^%s*(.-)%s*$")
    end
    
    -- Case conversion
    if options.lowercase then
        processed = processed:lower()
    elseif options.uppercase then
        processed = processed:upper()
    end
    
    -- Remove special characters
    if options.removeSpecial then
        processed = processed:gsub("[^%w%s]", "")
    end
    
    return processed
end

---Convert input to appropriate data type
---@param input string Input string
---@param targetType string Target type ("number", "integer", "boolean", "string")
---@return any|nil converted Converted value or nil if conversion failed
---@usage
--- local value = ConvertInputType("50", "number") -- Returns 50
--- local flag = ConvertInputType("yes", "boolean") -- Returns true
function ConvertInputType(input, targetType)
    if not input or input == "" then
        return nil
    end
    
    if targetType == "number" then
        return tonumber(input)
    elseif targetType == "integer" then
        local num = tonumber(input)
        return num and math.floor(num)
    elseif targetType == "boolean" then
        local lower = input:lower()
        return lower == "true" or lower == "yes" or lower == "1" or lower == "on"
    elseif targetType == "string" then
        return tostring(input)
    end
    
    return input
end

---Parse comma-separated values
---@param input string Comma-separated input
---@param itemType? string Type to convert each item to ("number", "integer", "string")
---@return table values Array of parsed values
---@usage
--- local numbers = ParseCSV("1,2,3,4,5", "number") -- Returns {1, 2, 3, 4, 5}
function ParseCSV(input, itemType)
    if not input or input == "" then
        return {}
    end
    
    local values = {}
    for item in input:gmatch("[^,]+") do
        local trimmed = item:match("^%s*(.-)%s*$") -- Trim whitespace
        if itemType then
            local converted = ConvertInputType(trimmed, itemType)
            if converted ~= nil then
                table.insert(values, converted)
            end
        else
            table.insert(values, trimmed)
        end
    end
    
    return values
end

-- ========================================
-- USER FEEDBACK AND INTERACTION
-- ========================================

---Show validation error message to user
---@param message string Error message
---@param title? string Optional dialog title (default: "Input Error")
---@usage
--- ShowValidationError("Please enter a number between 1 and 100")
function ShowValidationError(message, title)
    title = title or "Input Error"
    Printf("Validation Error: " .. message)
    
    -- Could create an error dialog here
    -- CreateInputDialog(title, message .. "\n\nPress OK to continue", function() end)
end

---Show success feedback to user
---@param message string Success message
---@param duration? number Optional display duration in seconds
---@usage
--- ShowSuccessFeedback("Settings saved successfully!", 3)
function ShowSuccessFeedback(message, duration)
    Printf("Success: " .. message)
    
    -- Could show temporary success indicator
    -- Implementation depends on available UI methods
end

---Provide input hints or help text
---@param element table UI element
---@param hintText string Hint or help text
---@usage
--- ShowInputHint(textInput, "Enter fixture numbers separated by commas")
function ShowInputHint(element, hintText)
    if element then
        element.Hint = hintText
        element.Tooltip = hintText
    end
end

---Highlight invalid input field
---@param element table UI element to highlight
---@param isInvalid boolean Whether field is invalid
---@usage
--- HighlightInvalidInput(textInput, true) -- Show error state
--- HighlightInvalidInput(textInput, false) -- Clear error state
function HighlightInvalidInput(element, isInvalid)
    if not element then return end
    
    if isInvalid then
        element.BackgroundColor = "Red"
        element.BorderColor = "DarkRed"
    else
        -- Reset to normal colors
        element.BackgroundColor = nil -- Use default
        element.BorderColor = nil -- Use default
    end
end

-- ========================================
-- INPUT STATE MANAGEMENT
-- ========================================

---Track input field states for validation
---@class InputStateManager
local InputStateManager = {
    fields = {},
    
    ---Register an input field for state tracking
    ---@param fieldId string Unique field identifier
    ---@param element table UI element
    ---@param validator function Validation function
    register = function(self, fieldId, element, validator)
        self.fields[fieldId] = {
            element = element,
            validator = validator,
            isValid = true,
            lastValue = "",
            errorMessage = ""
        }
    end,
    
    ---Validate a specific field
    ---@param fieldId string Field identifier
    ---@return boolean valid Whether field is valid
    validate = function(self, fieldId)
        local field = self.fields[fieldId]
        if not field then return false end
        
        local currentValue = field.element.Text or ""
        local valid, error = field.validator(currentValue)
        
        field.isValid = valid
        field.lastValue = currentValue
        field.errorMessage = error or ""
        
        HighlightInvalidInput(field.element, not valid)
        
        return valid
    end,
    
    ---Validate all registered fields
    ---@return boolean allValid Whether all fields are valid
    ---@return table errors Array of error messages
    validateAll = function(self)
        local allValid = true
        local errors = {}
        
        for fieldId, field in pairs(self.fields) do
            if not self:validate(fieldId) then
                allValid = false
                table.insert(errors, fieldId .. ": " .. field.errorMessage)
            end
        end
        
        return allValid, errors
    end,
    
    ---Clear all field states
    clear = function(self)
        for fieldId, field in pairs(self.fields) do
            HighlightInvalidInput(field.element, false)
        end
        self.fields = {}
    end
}

---Create a new input state manager
---@return table manager Input state manager instance
---@usage
--- local inputManager = CreateInputStateManager()
--- inputManager:register("name", nameInput, function(value)
---     return ValidateTextInput(value, {required = true, minLength = 3})
--- end)
function CreateInputStateManager()
    local manager = {}
    for key, value in pairs(InputStateManager) do
        manager[key] = value
    end
    manager.fields = {}
    return manager
end

-- ========================================
-- SPECIALIZED INPUT HANDLERS
-- ========================================

---Handle fixture number input with validation
---@param input string Input string (e.g., "1,2,5-10")
---@return boolean valid Whether input is valid
---@return table|nil fixtures Array of fixture numbers if valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, fixtures, error = HandleFixtureInput("1,2,5-10")
--- if valid then
---     for _, fixtureNum in ipairs(fixtures) do
---         -- Process fixture
---     end
--- end
function HandleFixtureInput(input)
    if not input or input == "" then
        return false, nil, "Please enter fixture numbers"
    end
    
    local fixtures = {}
    
    -- Split by commas
    for part in input:gmatch("[^,]+") do
        local trimmed = part:match("^%s*(.-)%s*$")
        
        -- Check for range (e.g., "5-10")
        local startNum, endNum = trimmed:match("^(%d+)%-(%d+)$")
        if startNum and endNum then
            local start = tonumber(startNum)
            local endVal = tonumber(endNum)
            if start and endVal and start <= endVal then
                for i = start, endVal do
                    table.insert(fixtures, i)
                end
            else
                return false, nil, "Invalid range: " .. trimmed
            end
        else
            -- Single number
            local num = tonumber(trimmed)
            if num and num >= 1 then
                table.insert(fixtures, num)
            else
                return false, nil, "Invalid fixture number: " .. trimmed
            end
        end
    end
    
    if #fixtures == 0 then
        return false, nil, "No valid fixture numbers found"
    end
    
    return true, fixtures, nil
end

---Handle color input with validation
---@param input string Color input (hex, name, or RGB values)
---@return boolean valid Whether input is valid
---@return table|nil color Color information if valid {r, g, b, format}
---@return string|nil error Error message if invalid
---@usage
--- local valid, color, error = HandleColorInput("#FF0000")
--- -- Returns: true, {r=255, g=0, b=0, format="hex"}, nil
function HandleColorInput(input)
    if not input or input == "" then
        return false, nil, "Please enter a color value"
    end
    
    local trimmed = input:match("^%s*(.-)%s*$"):lower()
    
    -- Check hex color (#RRGGBB or #RGB)
    local hex = trimmed:match("^#?([%da-f]+)$")
    if hex then
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            return true, {r = r, g = g, b = b, format = "hex"}, nil
        elseif #hex == 3 then
            local r = tonumber(hex:sub(1, 1), 16) * 17
            local g = tonumber(hex:sub(2, 2), 16) * 17
            local b = tonumber(hex:sub(3, 3), 16) * 17
            return true, {r = r, g = g, b = b, format = "hex"}, nil
        end
    end
    
    -- Check RGB format (r,g,b)
    local r, g, b = trimmed:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
    if r and g and b then
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r <= 255 and g <= 255 and b <= 255 then
            return true, {r = r, g = g, b = b, format = "rgb"}, nil
        end
    end
    
    -- Check named colors
    local namedColors = {
        red = {255, 0, 0},
        green = {0, 255, 0},
        blue = {0, 0, 255},
        white = {255, 255, 255},
        black = {0, 0, 0},
        yellow = {255, 255, 0},
        cyan = {0, 255, 255},
        magenta = {255, 0, 255}
    }
    
    local namedColor = namedColors[trimmed]
    if namedColor then
        return true, {r = namedColor[1], g = namedColor[2], b = namedColor[3], format = "named"}, nil
    end
    
    return false, nil, "Invalid color format. Use hex (#FF0000), RGB (255,0,0), or color name"
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Simple Input Validation:
   local function createValidatedInput(parent, label, validator)
       local input = AddInputField(parent, label)
       
       SetupTextChangeHandler(input, function(newValue)
           local valid, error = validator(newValue)
           HighlightInvalidInput(input, not valid)
           if not valid and error then
               ShowInputHint(input, error)
           end
       end)
       
       return input
   end

2. Form Validation with State Manager:
   local function createValidatedForm()
       local inputManager = CreateInputStateManager()
       
       -- Register inputs with validators
       inputManager:register("name", nameInput, function(value)
           return ValidateTextInput(value, {required = true, minLength = 3})
       end)
       
       inputManager:register("count", countInput, function(value)
           return ValidateNumericInput(value, {min = 1, max = 100, integer = true})
       end)
       
       -- Validate on submit
       local function onSubmit()
           local allValid, errors = inputManager:validateAll()
           if allValid then
               processForm()
           else
               ShowValidationError(table.concat(errors, "\n"))
           end
       end
   end

3. Real-time Input Processing:
   SetupTextChangeHandler(fixtureInput, function(newValue)
       local valid, fixtures, error = HandleFixtureInput(newValue)
       if valid then
           -- Update preview
           highlightFixtures(fixtures)
           ShowSuccessFeedback("Found " .. #fixtures .. " fixtures")
       else
           -- Show error
           HighlightInvalidInput(fixtureInput, true)
           ShowInputHint(fixtureInput, error)
       end
   end)

4. Multi-step Input Workflow:
   local function createMultiStepInput()
       local step = 1
       local data = {}
       
       local function nextStep()
           if step == 1 then
               -- Validate step 1 and collect data
               local valid, value, error = ValidateTextInput(step1Input.Text, {required = true})
               if valid then
                   data.name = value
                   showStep2()
               else
                   ShowValidationError(error)
               end
           elseif step == 2 then
               -- Process final data
               processMultiStepData(data)
           end
       end
   end

5. Specialized Input Handling:
   local function setupColorPicker(colorInput)
       SetupTextChangeHandler(colorInput, function(newValue)
           local valid, color, error = HandleColorInput(newValue)
           if valid then
               -- Update color preview
               updateColorPreview(color)
               colorInput.BackgroundColor = string.format("#%02X%02X%02X", color.r, color.g, color.b)
           else
               HighlightInvalidInput(colorInput, true)
               ShowInputHint(colorInput, error)
           end
       end)
   end

INTEGRATION WITH OTHER SYSTEMS:
- Use with dialog creation for form validation
- Connect to Handle methods for object property setting
- Integrate with command system for parameter validation
- Link with display management for error message positioning

PERFORMANCE CONSIDERATIONS:
- Debounce real-time validation for performance
- Cache validation results for repeated inputs
- Use appropriate validation complexity for input frequency
- Clear validation states when inputs are reset

ERROR HANDLING:
- Always provide clear, actionable error messages
- Highlight invalid inputs visually
- Offer suggestions for fixing invalid input
- Handle edge cases gracefully (empty input, special characters, etc.)
]]

return UserInput