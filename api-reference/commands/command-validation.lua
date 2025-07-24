---@meta
--- Command Validation API Reference
--- Syntax checking, parameter validation, and error prevention for MA3 commands
--- 
--- This module provides comprehensive validation utilities for MA3 commands,
--- including syntax checking, parameter validation, and safety checks.

---@class CommandValidation
local CommandValidation = {}

-- ========================================
-- BASIC SYNTAX VALIDATION
-- ========================================

---Validate basic command syntax
---@param command string Command string to validate
---@return boolean valid True if syntax is valid
---@return string|nil error Error message if invalid
---@return table|nil warnings Array of warning messages
---@usage
--- local valid, error, warnings = ValidateCommandSyntax("Fixture 1 At 100")
--- if not valid then
---     Printf("Syntax error: " .. error)
--- end
--- if warnings then
---     for _, warning in ipairs(warnings) do
---         Printf("Warning: " .. warning)
---     end
--- end
function ValidateCommandSyntax(command)
    local warnings = {}
    
    -- Check for empty command
    if not command or command == "" then
        return false, "Command cannot be empty", nil
    end
    
    local trimmed = command:match("^%s*(.-)%s*$")
    if not trimmed or trimmed == "" then
        return false, "Command contains only whitespace", nil
    end
    
    -- Check for balanced quotes
    local quoteCount = 0
    for char in trimmed:gmatch('"') do
        quoteCount = quoteCount + 1
    end
    if quoteCount % 2 ~= 0 then
        return false, "Unbalanced quotes in command", nil
    end
    
    -- Check for balanced parentheses
    local parenDepth = 0
    for char in trimmed:gmatch("[%(%)]") do
        if char == "(" then
            parenDepth = parenDepth + 1
        else
            parenDepth = parenDepth - 1
        end
        if parenDepth < 0 then
            return false, "Unbalanced parentheses in command", nil
        end
    end
    if parenDepth > 0 then
        return false, "Unbalanced parentheses in command", nil
    end
    
    -- Check for invalid characters
    if trimmed:match("[%c]") then
        return false, "Command contains control characters", nil
    end
    
    -- Check for incomplete syntax patterns
    if trimmed:match("^%s*At%s*$") then
        return false, "Missing value for 'At' command", nil
    end
    
    if trimmed:match("Thru%s*$") then
        return false, "Incomplete 'Thru' range specification", nil
    end
    
    if trimmed:match("^%s*Color%s*$") then
        return false, "Missing color value for 'Color' command", nil
    end
    
    -- Check for common typos and warn
    if trimmed:match("Fixture%s+%d+%s+At%s+%d+%.%d%d%d+") then
        table.insert(warnings, "Intensity value has excessive decimal precision")
    end
    
    if trimmed:match("^%s*store%s+") then
        table.insert(warnings, "Command starts with lowercase 'store', consider 'Store'")
    end
    
    return true, nil, #warnings > 0 and warnings or nil
end

---Validate specific command types
---@param command string Command string
---@param expectedType string Expected command type ("selection", "property", "storage", "playback")
---@return boolean valid True if command matches expected type
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateCommandType("Select Fixture 1", "selection")
function ValidateCommandType(command, expectedType)
    if not command then
        return false, "Command cannot be nil"
    end
    
    local trimmed = command:match("^%s*(.-)%s*$"):lower()
    
    if expectedType == "selection" then
        if not (trimmed:match("^select ") or trimmed:match("^all$") or trimmed:match("^clear$")) then
            return false, "Expected selection command (Select, All, Clear)"
        end
    elseif expectedType == "property" then
        if not (trimmed:match(" at ") or trimmed:match(" color ") or trimmed:match(" position ") or 
                trimmed:match(" gobo ") or trimmed:match(" zoom ") or trimmed:match(" focus ")) then
            return false, "Expected property command (At, Color, Position, etc.)"
        end
    elseif expectedType == "storage" then
        if not (trimmed:match("^store ") or trimmed:match("^update ") or trimmed:match("^copy ") or
                trimmed:match("^move ") or trimmed:match("^delete ")) then
            return false, "Expected storage command (Store, Update, Copy, Move, Delete)"
        end
    elseif expectedType == "playback" then
        if not (trimmed:match("^go ") or trimmed:match("^pause ") or trimmed:match("^off ") or
                trimmed:match("^on ") or trimmed:match("^flash ")) then
            return false, "Expected playback command (Go, Pause, Off, On, Flash)"
        end
    end
    
    return true, nil
end

-- ========================================
-- PARAMETER VALIDATION
-- ========================================

---Validate numeric parameters in commands
---@param value string Numeric value to validate
---@param paramType string Parameter type ("intensity", "position", "time", "dmx")
---@return boolean valid True if parameter is valid
---@return number|nil numValue Parsed numeric value if valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, value, error = ValidateNumericParameter("75", "intensity")
--- if valid then
---     Printf("Valid intensity: " .. value)
--- end
function ValidateNumericParameter(value, paramType)
    local num = tonumber(value)
    if not num then
        return false, nil, "Invalid numeric value: " .. tostring(value)
    end
    
    if paramType == "intensity" then
        if num < 0 or num > 100 then
            return false, nil, "Intensity must be between 0 and 100"
        end
    elseif paramType == "position" then
        if num < -270 or num > 270 then
            return false, nil, "Position value should be between -270 and 270 degrees"
        end
    elseif paramType == "time" then
        if num < 0 then
            return false, nil, "Time value cannot be negative"
        elseif num > 3600 then
            return false, nil, "Time value exceeds reasonable limit (3600 seconds)"
        end
    elseif paramType == "dmx" then
        if num < 0 or num > 255 then
            return false, nil, "DMX value must be between 0 and 255"
        end
    elseif paramType == "cue" then
        if num < 0 or num > 9999 then
            return false, nil, "Cue number should be between 0 and 9999"
        end
    end
    
    return true, num, nil
end

---Validate object references in commands
---@param reference string Object reference (e.g., "1", "1 Thru 10", "MyGroup")
---@param objectType string Object type ("fixture", "group", "preset", "cue", "sequence")
---@return boolean valid True if reference is valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateObjectReference("1 Thru 10", "fixture")
function ValidateObjectReference(reference, objectType)
    if not reference or reference == "" then
        return false, "Object reference cannot be empty"
    end
    
    local trimmed = reference:match("^%s*(.-)%s*$")
    
    -- Check for valid single number
    if trimmed:match("^%d+$") then
        local num = tonumber(trimmed)
        if num < 1 then
            return false, "Object numbers must be positive"
        end
        if num > 9999 then
            return false, "Object number exceeds reasonable limit"
        end
        return true, nil
    end
    
    -- Check for valid range (e.g., "1 Thru 10")
    local startNum, endNum = trimmed:match("^(%d+)%s+[Tt]hru%s+(%d+)$")
    if startNum and endNum then
        local start, endVal = tonumber(startNum), tonumber(endNum)
        if start >= endVal then
            return false, "Range start must be less than range end"
        end
        if start < 1 or endVal > 9999 then
            return false, "Range values must be between 1 and 9999"
        end
        return true, nil
    end
    
    -- Check for valid multi-selection (e.g., "1 + 2 + 5")
    if trimmed:match("^%d+(%s*%+%s*%d+)+$") then
        for numStr in trimmed:gmatch("%d+") do
            local num = tonumber(numStr)
            if num < 1 or num > 9999 then
                return false, "Selection numbers must be between 1 and 9999"
            end
        end
        return true, nil
    end
    
    -- Check for valid quoted name
    local quotedName = trimmed:match('^"(.+)"$')
    if quotedName then
        if quotedName == "" then
            return false, "Object name cannot be empty"
        end
        if #quotedName > 50 then
            return false, "Object name exceeds maximum length (50 characters)"
        end
        return true, nil
    end
    
    -- Check for valid unquoted name (alphanumeric and some special chars)
    if trimmed:match("^[%w_%-%.]+$") then
        if #trimmed > 50 then
            return false, "Object name exceeds maximum length (50 characters)"
        end
        return true, nil
    end
    
    return false, "Invalid object reference format"
end

---Validate color parameters
---@param color string Color value (name, hex, or RGB)
---@return boolean valid True if color is valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateColorParameter("#FF0000")
--- local valid2, error2 = ValidateColorParameter("Red")
function ValidateColorParameter(color)
    if not color or color == "" then
        return false, "Color value cannot be empty"
    end
    
    local trimmed = color:match("^%s*(.-)%s*$")
    
    -- Check hex color (#RRGGBB or #RGB)
    if trimmed:match("^#[%da-fA-F]+$") then
        local hex = trimmed:sub(2)
        if #hex == 6 or #hex == 3 then
            return true, nil
        else
            return false, "Hex color must be #RGB or #RRGGBB format"
        end
    end
    
    -- Check RGB format (r,g,b)
    local r, g, b = trimmed:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
    if r and g and b then
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r > 255 or g > 255 or b > 255 then
            return false, "RGB values must be between 0 and 255"
        end
        return true, nil
    end
    
    -- Check named colors
    local validColors = {
        "red", "green", "blue", "white", "black", "yellow", "cyan", "magenta",
        "orange", "purple", "pink", "brown", "gray", "grey", "amber", "lime",
        "indigo", "violet", "turquoise", "navy", "maroon", "olive", "teal"
    }
    
    local lowerColor = trimmed:lower()
    for _, validColor in ipairs(validColors) do
        if lowerColor == validColor then
            return true, nil
        end
    end
    
    return false, "Invalid color format. Use hex (#FF0000), RGB (255,0,0), or color name"
end

-- ========================================
-- COMMAND SAFETY VALIDATION
-- ========================================

---Check if command is potentially destructive
---@param command string Command to check
---@return boolean destructive True if command could cause data loss
---@return string reason Reason why command is destructive
---@return string severity Severity level ("low", "medium", "high", "critical")
---@usage
--- local destructive, reason, severity = IsDestructiveCommand("Delete All")
--- if destructive then
---     -- Show confirmation dialog based on severity
--- end
function IsDestructiveCommand(command)
    if not command then
        return false, "", "low"
    end
    
    local lowerCmd = command:lower()
    
    -- Critical destructive operations
    if lowerCmd:match("^%s*delete%s+all") then
        return true, "Will permanently delete ALL objects", "critical"
    end
    
    if lowerCmd:match("^%s*clear%s+all") then
        return true, "Will clear ALL current data and selections", "critical"
    end
    
    -- High severity operations
    if lowerCmd:match("^%s*delete%s+") then
        return true, "Will permanently delete specified objects", "high"
    end
    
    if lowerCmd:match("^%s*format%s+") then
        return true, "Will format storage device (permanent data loss)", "critical"
    end
    
    -- Medium severity operations
    if lowerCmd:match("^%s*clear%s*$") or lowerCmd:match("^%s*clear%s+selection") then
        return true, "Will clear current selection", "medium"
    end
    
    if lowerCmd:match("^%s*off%s+all") then
        return true, "Will turn off all active playback", "medium"
    end
    
    if lowerCmd:match("^%s*blackout") then
        return true, "Will blackout all console output", "medium"
    end
    
    -- Low severity operations
    if lowerCmd:match("^%s*update%s+") then
        return true, "Will overwrite existing stored data", "low"
    end
    
    return false, "", "low"
end

---Validate command execution context
---@param command string Command to validate
---@param context table Current context {mode, selection, activeObjects}
---@return boolean valid True if command is valid in current context
---@return string|nil error Error message if invalid
---@return table|nil suggestions Array of suggested corrections
---@usage
--- local context = {mode = "blind", selection = "none", activeObjects = {}}
--- local valid, error, suggestions = ValidateCommandContext("Flash Sequence 1", context)
function ValidateCommandContext(command, context)
    local suggestions = {}
    
    if not command or not context then
        return false, "Invalid parameters for context validation", nil
    end
    
    local lowerCmd = command:lower()
    
    -- Check if command requires selection but none exists
    if (lowerCmd:match("^%s*at%s+") or lowerCmd:match("^%s*color%s+") or 
        lowerCmd:match("^%s*position%s+")) and
       (not context.selection or context.selection == "none") then
        table.insert(suggestions, "Select objects before setting properties")
        return false, "Property command requires object selection", suggestions
    end
    
    -- Check context-specific validations
    if context.mode == "blind" then
        if lowerCmd:match("^%s*flash%s+") then
            table.insert(suggestions, "Flash commands don't work in blind mode")
            return false, "Flash commands are not effective in blind mode", suggestions
        end
    end
    
    if context.mode == "live" then
        if lowerCmd:match("^%s*preview%s+") then
            table.insert(suggestions, "Use blind mode for preview operations")
            return false, "Preview commands should be used in blind mode", suggestions
        end
    end
    
    -- Check for conflicting operations
    if #context.activeObjects > 0 then
        local hasSequences = false
        for _, obj in ipairs(context.activeObjects) do
            if obj.type == "sequence" then
                hasSequences = true
                break
            end
        end
        
        if hasSequences and lowerCmd:match("^%s*go%s+") then
            table.insert(suggestions, "Consider stopping active sequences first")
            return false, "Starting new sequences while others are active may cause conflicts", suggestions
        end
    end
    
    return true, nil, #suggestions > 0 and suggestions or nil
end

-- ========================================
-- COMPREHENSIVE COMMAND VALIDATION
-- ========================================

---Perform comprehensive validation of a command
---@param command string Command to validate
---@param options? table Validation options {checkSyntax, checkParameters, checkSafety, checkContext}
---@param context? table Current context for context validation
---@return table result Validation result {valid, errors, warnings, suggestions}
---@usage
--- local result = ValidateCommand("Fixture 1 At 150", {
---     checkSyntax = true,
---     checkParameters = true,
---     checkSafety = true
--- })
--- 
--- if not result.valid then
---     for _, error in ipairs(result.errors) do
---         Printf("Error: " .. error)
---     end
--- end
function ValidateCommand(command, options, context)
    options = options or {
        checkSyntax = true,
        checkParameters = true,
        checkSafety = true,
        checkContext = false
    }
    
    local result = {
        valid = true,
        errors = {},
        warnings = {},
        suggestions = {}
    }
    
    -- Syntax validation
    if options.checkSyntax then
        local syntaxValid, syntaxError, syntaxWarnings = ValidateCommandSyntax(command)
        if not syntaxValid then
            result.valid = false
            table.insert(result.errors, syntaxError)
        end
        if syntaxWarnings then
            for _, warning in ipairs(syntaxWarnings) do
                table.insert(result.warnings, warning)
            end
        end
    end
    
    -- Parameter validation
    if options.checkParameters and result.valid then
        -- Extract and validate numeric parameters
        for intensityMatch in command:gmatch("%s+At%s+([%d%.]+)") do
            local paramValid, _, paramError = ValidateNumericParameter(intensityMatch, "intensity")
            if not paramValid then
                result.valid = false
                table.insert(result.errors, paramError)
            end
        end
        
        -- Validate color parameters
        for colorMatch in command:gmatch("%s+Color%s+([^%s]+)") do
            local colorValid, colorError = ValidateColorParameter(colorMatch)
            if not colorValid then
                result.valid = false
                table.insert(result.errors, colorError)
            end
        end
        
        -- Validate object references
        local fixtureMatch = command:match("Fixture%s+([^%s]+)")
        if fixtureMatch then
            local refValid, refError = ValidateObjectReference(fixtureMatch, "fixture")
            if not refValid then
                result.valid = false
                table.insert(result.errors, refError)
            end
        end
    end
    
    -- Safety validation
    if options.checkSafety then
        local destructive, reason, severity = IsDestructiveCommand(command)
        if destructive then
            if severity == "critical" then
                table.insert(result.warnings, "CRITICAL: " .. reason)
            elseif severity == "high" then
                table.insert(result.warnings, "WARNING: " .. reason)
            else
                table.insert(result.warnings, "Notice: " .. reason)
            end
            table.insert(result.suggestions, "Consider using confirmation dialog for this command")
        end
    end
    
    -- Context validation
    if options.checkContext and context then
        local contextValid, contextError, contextSuggestions = ValidateCommandContext(command, context)
        if not contextValid then
            result.valid = false
            table.insert(result.errors, contextError)
        end
        if contextSuggestions then
            for _, suggestion in ipairs(contextSuggestions) do
                table.insert(result.suggestions, suggestion)
            end
        end
    end
    
    return result
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Simple Syntax Validation:
   local valid, error = ValidateCommandSyntax(userInput)
   if not valid then
       ShowValidationError(error)
       return
   end
   Cmd(userInput)

2. Comprehensive Command Validation:
   local result = ValidateCommand(command, {
       checkSyntax = true,
       checkParameters = true,
       checkSafety = true
   })
   
   if not result.valid then
       Printf("Command validation failed:")
       for _, error in ipairs(result.errors) do
           Printf("  Error: " .. error)
       end
       return
   end
   
   if #result.warnings > 0 then
       Printf("Warnings:")
       for _, warning in ipairs(result.warnings) do
           Printf("  " .. warning)
       end
   end

3. Parameter Validation in Forms:
   local function validateIntensityInput(input)
       local valid, value, error = ValidateNumericParameter(input, "intensity")
       if not valid then
           HighlightInvalidInput(intensityField, true)
           ShowInputHint(intensityField, error)
           return false
       end
       HighlightInvalidInput(intensityField, false)
       return true, value
   end

4. Safety Checks Before Execution:
   local function safeExecuteCommand(command)
       local destructive, reason, severity = IsDestructiveCommand(command)
       if destructive then
           local title = severity == "critical" and "CRITICAL ACTION" or "Confirm Action"
           CreateConfirmDialog(title, reason .. "\n\nProceed?", function(confirmed)
               if confirmed then
                   Cmd(command)
               end
           end)
       else
           Cmd(command)
       end
   end

5. Context-Aware Validation:
   local function executeWithContext(command)
       local context = {
           mode = getCurrentMode(),
           selection = getCurrentSelection(),
           activeObjects = getActiveObjects()
       }
       
       local result = ValidateCommand(command, {
           checkSyntax = true,
           checkParameters = true,
           checkContext = true
       }, context)
       
       if result.valid then
           Cmd(command)
       else
           showValidationDialog(result)
       end
   end

6. Real-time Validation in UI:
   SetupTextChangeHandler(commandInput, function(newValue)
       local result = ValidateCommand(newValue, {checkSyntax = true})
       
       if result.valid then
           HighlightInvalidInput(commandInput, false)
           clearValidationMessages()
       else
           HighlightInvalidInput(commandInput, true)
           showValidationMessages(result.errors)
       end
   end)

INTEGRATION PATTERNS:
- Use with command building utilities for generated command validation
- Integrate with UI forms for real-time input validation
- Combine with error handling systems for robust command execution
- Connect with user confirmation dialogs for destructive operations

PERFORMANCE CONSIDERATIONS:
- Cache validation results for repeated command patterns
- Use appropriate validation levels based on context
- Implement debouncing for real-time validation
- Skip expensive validations for trusted internal commands

ERROR HANDLING:
- Provide clear, actionable error messages
- Offer suggestions for fixing invalid commands
- Handle edge cases gracefully (empty input, special characters)
- Distinguish between syntax errors and parameter errors
]]

return CommandValidation