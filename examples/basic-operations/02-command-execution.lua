---@meta
--- Basic Command Execution Examples
--- Demonstrates fundamental command execution patterns in MA3
--- 
--- This example covers:
--- - Direct command execution with Cmd()
--- - Indirect command execution with CmdIndirect()
--- - Command result handling and validation
--- - Error handling for command execution
--- - Building dynamic commands with variables

---@class CommandExecutionExamples
local CommandExecutionExamples = {}

-- ========================================
-- BASIC COMMAND EXECUTION PATTERNS
-- ========================================

---Execute a simple MA3 command with error handling
---@param command string MA3 command to execute
---@return string|nil result Command result or nil if failed
---@usage
--- local result = executeCommand("Clear")
--- if result then
---   Printf("Command succeeded: " .. result)
--- end
local function executeCommand(command)
    if not command or command == "" then
        Printf("Error: Empty command provided")
        return nil
    end
    
    Printf("Executing command: " .. command)
    
    -- Use pcall for safe command execution
    local success, result = pcall(function()
        return Cmd(command)
    end)
    
    if success then
        Printf("Command executed successfully")
        if result and result ~= "" then
            Printf("Command result: " .. result)
        end
        return result
    else
        Printf("Error executing command: " .. tostring(result))
        return nil
    end
end

---Execute command indirectly (non-blocking)
---@param command string MA3 command to execute
---@param description? string Optional description for logging
---@usage
--- executeCommandIndirect("Go Cue 1", "Starting main sequence")
local function executeCommandIndirect(command, description)
    if not command or command == "" then
        Printf("Error: Empty command provided")
        return
    end
    
    local desc = description or "Indirect command"
    Printf(desc .. ": " .. command)
    
    -- Execute command indirectly (non-blocking)
    local success, error = pcall(function()
        CmdIndirect(command)
    end)
    
    if success then
        Printf("Command queued for execution")
    else
        Printf("Error queuing command: " .. tostring(error))
    end
end

-- ========================================
-- FIXTURE CONTROL COMMANDS
-- ========================================

---Set fixture intensity with error handling
---@param fixtureId number|string Fixture ID or range
---@param intensity number Intensity value (0-100)
---@return boolean success True if command executed successfully
---@usage
--- setFixtureIntensity(1, 50)
--- setFixtureIntensity("1+2+5", 75)
local function setFixtureIntensity(fixtureId, intensity)
    -- Validate input parameters
    if not fixtureId then
        Printf("Error: Fixture ID is required")
        return false
    end
    
    if not intensity or intensity < 0 or intensity > 100 then
        Printf("Error: Intensity must be between 0 and 100")
        return false
    end
    
    -- Build and execute command
    local command = "Fixture " .. tostring(fixtureId) .. " At " .. tostring(intensity)
    local result = executeCommand(command)
    
    return result ~= nil
end

---Set fixture color using RGB values
---@param fixtureId number|string Fixture ID or range
---@param red number Red component (0-255)
---@param green number Green component (0-255)
---@param blue number Blue component (0-255)
---@return boolean success True if command executed successfully
---@usage
--- setFixtureColor(1, 255, 0, 0)  -- Set fixture 1 to red
local function setFixtureColor(fixtureId, red, green, blue)
    -- Validate input parameters
    if not fixtureId then
        Printf("Error: Fixture ID is required")
        return false
    end
    
    -- Validate color values
    local function validateColorValue(value, name)
        if not value or value < 0 or value > 255 then
            Printf("Error: " .. name .. " must be between 0 and 255")
            return false
        end
        return true
    end
    
    if not (validateColorValue(red, "Red") and 
            validateColorValue(green, "Green") and 
            validateColorValue(blue, "Blue")) then
        return false
    end
    
    -- Build and execute color command
    local command = string.format("Fixture %s At Color RGB %d %d %d", 
                                  tostring(fixtureId), red, green, blue)
    local result = executeCommand(command)
    
    return result ~= nil
end

-- ========================================
-- GROUP AND PRESET COMMANDS
-- ========================================

---Flash a group with specified intensity
---@param groupId number Group ID to flash
---@param intensity? number Flash intensity (default: 100)
---@return boolean success True if command executed successfully
---@usage
--- flashGroup(1, 75)  -- Flash group 1 at 75%
local function flashGroup(groupId, intensity)
    if not groupId then
        Printf("Error: Group ID is required")
        return false
    end
    
    local flashIntensity = intensity or 100
    
    -- Validate intensity
    if flashIntensity < 0 or flashIntensity > 100 then
        Printf("Error: Flash intensity must be between 0 and 100")
        return false
    end
    
    -- Build and execute flash command
    local command = "Group " .. tostring(groupId) .. " Flash At " .. tostring(flashIntensity)
    local result = executeCommand(command)
    
    return result ~= nil
end

---Call a preset by ID
---@param presetType string Preset type (e.g., "Intensity", "Color", "Beam")
---@param presetId number Preset ID to call
---@return boolean success True if command executed successfully
---@usage
--- callPreset("Color", 1)
local function callPreset(presetType, presetId)
    if not presetType or presetType == "" then
        Printf("Error: Preset type is required")
        return false
    end
    
    if not presetId then
        Printf("Error: Preset ID is required")
        return false
    end
    
    -- Build and execute preset command
    local command = "Preset " .. presetType .. " " .. tostring(presetId)
    local result = executeCommand(command)
    
    return result ~= nil
end

-- ========================================
-- SEQUENCE AND CUE COMMANDS
-- ========================================

---Go to a specific cue in a sequence
---@param sequenceId number Sequence ID
---@param cueId number Cue ID to go to
---@param fadeTime? number Optional fade time in seconds
---@return boolean success True if command executed successfully
---@usage
--- goToCue(1, 5, 3.0)  -- Go to cue 5 in sequence 1 with 3-second fade
local function goToCue(sequenceId, cueId, fadeTime)
    if not sequenceId then
        Printf("Error: Sequence ID is required")
        return false
    end
    
    if not cueId then
        Printf("Error: Cue ID is required")
        return false
    end
    
    -- Build command with optional fade time
    local command = "Goto Sequence " .. tostring(sequenceId) .. " Cue " .. tostring(cueId)
    
    if fadeTime and fadeTime > 0 then
        command = command .. " Fade " .. tostring(fadeTime)
    end
    
    local result = executeCommand(command)
    return result ~= nil
end

---Pause or resume a sequence
---@param sequenceId number Sequence ID to control
---@param action string Action: "Pause" or "Resume"
---@return boolean success True if command executed successfully
---@usage
--- controlSequence(1, "Pause")
local function controlSequence(sequenceId, action)
    if not sequenceId then
        Printf("Error: Sequence ID is required")
        return false
    end
    
    if not action or (action ~= "Pause" and action ~= "Resume") then
        Printf("Error: Action must be 'Pause' or 'Resume'")
        return false
    end
    
    -- Build and execute sequence control command
    local command = action .. " Sequence " .. tostring(sequenceId)
    local result = executeCommand(command)
    
    return result ~= nil
end

-- ========================================
-- ADVANCED COMMAND BUILDING
-- ========================================

---Build command for multiple fixtures with different values
---@param fixtureIntensities table Table of fixture_id = intensity pairs
---@return boolean success True if all commands executed successfully
---@usage
--- setMultipleFixtures({[1] = 50, [2] = 75, [5] = 100})
local function setMultipleFixtures(fixtureIntensities)
    if not fixtureIntensities or type(fixtureIntensities) ~= "table" then
        Printf("Error: Fixture intensities table is required")
        return false
    end
    
    local allSuccessful = true
    
    Printf("Setting multiple fixtures:")
    for fixtureId, intensity in pairs(fixtureIntensities) do
        Printf("  Setting Fixture " .. tostring(fixtureId) .. " to " .. tostring(intensity) .. "%")
        
        if not setFixtureIntensity(fixtureId, intensity) then
            Printf("  Failed to set Fixture " .. tostring(fixtureId))
            allSuccessful = false
        end
    end
    
    return allSuccessful
end

---Execute a sequence of commands with optional delays
---@param commandSequence table Array of command tables with command and optional delay
---@return boolean success True if all commands executed successfully
---@usage
--- local sequence = {
---   {command = "Clear", delay = 1},
---   {command = "Fixture 1 At 50", delay = 2},
---   {command = "Go Cue 1"}
--- }
--- executeCommandSequence(sequence)
local function executeCommandSequence(commandSequence)
    if not commandSequence or type(commandSequence) ~= "table" then
        Printf("Error: Command sequence table is required")
        return false
    end
    
    Printf("Executing command sequence with " .. #commandSequence .. " commands:")
    
    for i, cmdInfo in ipairs(commandSequence) do
        if not cmdInfo.command then
            Printf("Error: Command " .. i .. " is missing command text")
            return false
        end
        
        Printf("Step " .. i .. ": " .. cmdInfo.command)
        
        -- Execute the command
        local result = executeCommand(cmdInfo.command)
        if not result then
            Printf("Command sequence failed at step " .. i)
            return false
        end
        
        -- Handle optional delay
        if cmdInfo.delay and cmdInfo.delay > 0 then
            Printf("Waiting " .. cmdInfo.delay .. " seconds...")
            -- Note: In real implementation, you might want to use a proper sleep function
            -- For now, we'll just log the intended delay
        end
    end
    
    Printf("Command sequence completed successfully!")
    return true
end

-- ========================================
-- MAIN DEMONSTRATION FUNCTION
-- ========================================

---Run all basic command execution examples
---This function demonstrates all the patterns above
---@usage
--- -- Run from plugin or command line:
--- runCommandExecutionDemo()
function runCommandExecutionDemo()
    Printf("Starting Basic Command Execution Examples...")
    Printf("")
    
    -- Example 1: Simple command execution
    Printf("1. Basic command execution:")
    executeCommand("Clear")
    Printf("")
    
    -- Example 2: Fixture control
    Printf("2. Fixture control:")
    setFixtureIntensity(1, 50)
    setFixtureColor(1, 255, 0, 0)
    Printf("")
    
    -- Example 3: Group operations
    Printf("3. Group operations:")
    flashGroup(1, 75)
    Printf("")
    
    -- Example 4: Preset calls
    Printf("4. Preset operations:")
    callPreset("Intensity", 1)
    callPreset("Color", 2)
    Printf("")
    
    -- Example 5: Sequence control
    Printf("5. Sequence control:")
    goToCue(1, 1, 2.0)
    controlSequence(1, "Pause")
    Printf("")
    
    -- Example 6: Multiple fixtures
    Printf("6. Multiple fixture control:")
    setMultipleFixtures({[1] = 25, [2] = 50, [3] = 75, [4] = 100})
    Printf("")
    
    -- Example 7: Command sequence
    Printf("7. Command sequence execution:")
    local sequence = {
        {command = "Clear", delay = 1},
        {command = "Fixture 1+2+3 At 50", delay = 1},
        {command = "Fixture 1+2+3 At Color Red", delay = 2},
        {command = "Clear"}
    }
    executeCommandSequence(sequence)
    Printf("")
    
    -- Example 8: Indirect commands
    Printf("8. Indirect command execution:")
    executeCommandIndirect("Go Cue 1", "Starting sequence playback")
    executeCommandIndirect("Flash Group 1 At 100", "Emergency flash")
    
    Printf("")
    Printf("Basic Command Execution Examples completed!")
end

-- Export functions for external use
return {
    runDemo = runCommandExecutionDemo,
    executeCommand = executeCommand,
    executeCommandIndirect = executeCommandIndirect,
    setFixtureIntensity = setFixtureIntensity,
    setFixtureColor = setFixtureColor,
    flashGroup = flashGroup,
    callPreset = callPreset,
    goToCue = goToCue,
    controlSequence = controlSequence,
    setMultipleFixtures = setMultipleFixtures,
    executeCommandSequence = executeCommandSequence
}