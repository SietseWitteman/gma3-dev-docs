---@meta
--- Command Execution API Reference
--- Core command execution methods and patterns for MA3 plugins
--- 
--- This module provides methods for executing MA3 commands programmatically,
--- including direct execution, indirect execution, and command result handling.

---@class CommandExecution
local CommandExecution = {}

-- ========================================
-- CORE COMMAND EXECUTION FUNCTIONS
-- ========================================

---Execute a MA3 command directly
---@param command string MA3 command string to execute
---@param undoHandle? Handle Optional undo handle for command rollback
---@return string result Command execution result
---@usage
--- -- Simple command execution
--- Cmd("Clear")
--- Cmd("Fixture 1 At 100")
--- 
--- -- Command with result processing
--- local result = Cmd("Fixture 1 At 50")
--- Printf("Command result: " .. result)
--- 
--- -- Command with undo handle
--- local undoHandle = Obj()
--- Cmd("Store Cue 1", undoHandle)
function Cmd(command, undoHandle)
    return ""
end

---Execute command indirectly (asynchronous)
---Non-blocking command execution that returns immediately
---@param command string MA3 command string to execute
---@param undoHandle? Handle Optional undo handle for command rollback
---@param handleTarget? Handle Optional target handle for command context
---@usage
--- -- Indirect command execution (non-blocking)
--- CmdIndirect("Go Cue 1")
--- CmdIndirect("Flash Group 1", nil, groupHandle)
--- 
--- -- Continue with other operations immediately
--- Printf("Command queued for execution")
function CmdIndirect(command, undoHandle, handleTarget)
end

---Execute command indirectly and wait for completion
---Blocking command execution that waits for the command to finish
---@param command string MA3 command string to execute
---@param undoHandle? Handle Optional undo handle for command rollback
---@param handleTarget? Handle Optional target handle for command context
---@usage
--- -- Indirect command with wait (blocking)
--- CmdIndirectWait("Go Cue 1")
--- Printf("Cue execution completed")
--- 
--- -- Use when you need to ensure command completion before proceeding
--- CmdIndirectWait("Store Cue 2")
--- local cue2 = Obj("Cue 2")
--- if cue2 then
---     Printf("Cue 2 successfully stored")
--- end
function CmdIndirectWait(command, undoHandle, handleTarget)
end

---Get command object handle
---@return Handle commandObject Handle to the command system object
---@usage
--- local cmdObj = CmdObj()
--- local cmdHistory = cmdObj:Children() -- Get command history
--- Printf("Command object class: " .. cmdObj:GetClass())
function CmdObj()
    return Handle:new()
end

-- ========================================
-- COMMAND BUILDING AND FORMATTING
-- ========================================

---Build a command string from components
---@param action string Base command action (e.g., "At", "Color", "Store")
---@param target? string Optional target specification
---@param parameters? table Optional parameters table
---@return string command Complete command string
---@usage
--- local cmd = BuildCommand("At", "Fixture 1 Thru 10", {intensity = 75, fade = 3})
--- -- Returns: "Fixture 1 Thru 10 At 75 Fade 3"
--- Cmd(cmd)
function BuildCommand(action, target, parameters)
    local command = ""
    
    if target and target ~= "" then
        command = target .. " "
    end
    
    command = command .. action
    
    if parameters then
        for key, value in pairs(parameters) do
            if key == "intensity" and action == "At" then
                command = command .. " " .. value
            elseif key == "fade" then
                command = command .. " Fade " .. value
            elseif key == "delay" then
                command = command .. " Delay " .. value
            elseif key == "time" then
                command = command .. " Time " .. value
            elseif key == "color" then
                command = command .. " Color " .. value
            else
                command = command .. " " .. key .. " " .. value
            end
        end
    end
    
    return command
end

---Format object selection for command use
---@param objectType string Object type ("Fixture", "Group", "Preset", etc.)
---@param selection string|table Selection specification (number, range, or array)
---@return string formatted Formatted selection string
---@usage
--- local sel1 = FormatSelection("Fixture", "1")           -- "Fixture 1"
--- local sel2 = FormatSelection("Fixture", "1 Thru 10")   -- "Fixture 1 Thru 10"
--- local sel3 = FormatSelection("Group", {1, 2, 5})       -- "Group 1 + 2 + 5"
function FormatSelection(objectType, selection)
    local formatted = objectType .. " "
    
    if type(selection) == "table" then
        -- Handle array of selections
        local parts = {}
        for _, item in ipairs(selection) do
            table.insert(parts, tostring(item))
        end
        formatted = formatted .. table.concat(parts, " + ")
    else
        -- Handle string selection
        formatted = formatted .. tostring(selection)
    end
    
    return formatted
end

---Escape special characters in command strings
---@param input string Input string that may contain special characters
---@return string escaped Escaped string safe for command use
---@usage
--- local safeName = EscapeCommandString("My Group with Spaces")
--- local cmd = "Group \"" .. safeName .. "\" At 100"
function EscapeCommandString(input)
    if not input then return "" end
    
    -- Escape quotes and special characters
    local escaped = input:gsub('"', '\\"')
    
    -- If string contains spaces or special characters, wrap in quotes
    if escaped:match("[%s%+%-%*/%@%!%#%$%%%^%&%(%)]") then
        escaped = '"' .. escaped .. '"'
    end
    
    return escaped
end

-- ========================================
-- COMMAND VALIDATION AND SYNTAX CHECKING
-- ========================================

---Validate command syntax before execution
---@param command string Command string to validate
---@return boolean valid True if command syntax appears valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = ValidateCommandSyntax("Fixture 1 At 101")
--- if not valid then
---     Printf("Invalid command: " .. error)
--- else
---     Cmd("Fixture 1 At 101")
--- end
function ValidateCommandSyntax(command, error)
    if not command or command == "" then
        return false, "Command cannot be empty"
    end
    
    -- Basic syntax validation
    local trimmed = command:match("^%s*(.-)%s*$")
    if not trimmed or trimmed == "" then
        return false, "Command contains only whitespace"
    end
    
    -- Check for balanced quotes
    local quoteCount = 0
    for char in trimmed:gmatch('"') do
        quoteCount = quoteCount + 1
    end
    if quoteCount % 2 ~= 0 then
        return false, "Unbalanced quotes in command"
    end
    
    -- Check for common syntax errors
    if trimmed:match("^%s*At%s*$") then
        return false, "Missing intensity value for 'At' command"
    end
    
    if trimmed:match("Thru%s*$") then
        return false, "Incomplete 'Thru' range specification"
    end
    
    return true, nil
end

---Check if command requires confirmation
---@param command string Command string to check
---@return boolean requiresConfirmation True if command is potentially destructive
---@return string reason Reason why confirmation is needed
---@usage
--- local needsConfirm, reason = CommandRequiresConfirmation("Delete All")
--- if needsConfirm then
---     -- Show confirmation dialog
---     CreateConfirmDialog("Confirm Action", reason, function(confirmed)
---         if confirmed then Cmd(command) end
---     end)
--- end
function CommandRequiresConfirmation(command)
    if not command then return false, "" end
    
    local lowerCmd = command:lower()
    
    -- Destructive operations
    if lowerCmd:match("^%s*delete") then
        return true, "This command will permanently delete data"
    end
    
    if lowerCmd:match("^%s*clear%s*all") or lowerCmd:match("^%s*clear%s*$") then
        return true, "This command will clear all current data"
    end
    
    if lowerCmd:match("^%s*off%s+all") then
        return true, "This command will turn off all active playback"
    end
    
    if lowerCmd:match("^%s*blackout") then
        return true, "This command will blackout all output"
    end
    
    return false, ""
end

-- ========================================
-- SAFE COMMAND EXECUTION PATTERNS
-- ========================================

---Execute command with error handling
---@param command string Command to execute
---@param options? table Optional execution options {retries, timeout, confirmDestructive}
---@return boolean success True if command executed successfully
---@return string|nil result Command result or error message
---@usage
--- local success, result = SafeCmd("Fixture 1 At 100", {retries = 3})
--- if success then
---     Printf("Command executed: " .. result)
--- else
---     Printf("Command failed: " .. result)
--- end
function SafeCmd(command, options)
    options = options or {}
    local maxRetries = options.retries or 1
    local confirmDestructive = options.confirmDestructive ~= false
    
    -- Validate command syntax
    local valid, syntaxError = ValidateCommandSyntax(command)
    if not valid then
        return false, "Syntax error: " .. syntaxError
    end
    
    -- Check for destructive operations
    if confirmDestructive then
        local needsConfirm, reason = CommandRequiresConfirmation(command)
        if needsConfirm then
            return false, "Destructive command requires confirmation: " .. reason
        end
    end
    
    -- Execute with retries
    for attempt = 1, maxRetries do
        local success, result = pcall(function()
            return Cmd(command)
        end)
        
        if success then
            return true, result
        else
            Printf("Command attempt " .. attempt .. " failed: " .. tostring(result))
            if attempt == maxRetries then
                return false, "Command failed after " .. maxRetries .. " attempts: " .. tostring(result)
            end
        end
    end
    
    return false, "Unexpected error in command execution"
end

---Execute multiple commands in sequence
---@param commands table Array of command strings
---@param options? table Optional execution options {stopOnError, parallel}
---@return table results Array of execution results {success, result, command}
---@usage
--- local commands = {"Clear", "Fixture 1 At 50", "Store Cue 1"}
--- local results = ExecuteCommandSequence(commands, {stopOnError = true})
--- for i, result in ipairs(results) do
---     Printf("Command " .. i .. ": " .. (result.success and "OK" or "FAILED"))
--- end
function ExecuteCommandSequence(commands, options)
    options = options or {}
    local stopOnError = options.stopOnError ~= false -- Default to true
    local results = {}
    
    for i, command in ipairs(commands) do
        local success, result = SafeCmd(command)
        
        table.insert(results, {
            success = success,
            result = result,
            command = command,
            index = i
        })
        
        if not success and stopOnError then
            Printf("Command sequence stopped at command " .. i .. " due to error: " .. result)
            break
        end
    end
    
    return results
end

---Execute command with timeout
---@param command string Command to execute
---@param timeoutSeconds number Timeout in seconds
---@return boolean success True if command completed within timeout
---@return string|nil result Command result or timeout message
---@usage
--- local success, result = ExecuteCommandWithTimeout("Go Cue 1", 10)
--- if not success then
---     Printf("Command timed out or failed: " .. result)
--- end
function ExecuteCommandWithTimeout(command, timeoutSeconds)
    local startTime = os.clock()
    local completed = false
    local result = ""
    
    -- Execute command indirectly (non-blocking)
    CmdIndirect(command)
    
    -- Wait for completion or timeout
    while not completed and (os.clock() - startTime) < timeoutSeconds do
        -- This is a simplified timeout implementation
        -- In practice, you'd need a way to check command completion status
        -- For now, we simulate with a short delay
        completed = true -- Assume completion for this example
        result = "Command executed"
    end
    
    if not completed then
        return false, "Command timed out after " .. timeoutSeconds .. " seconds"
    end
    
    return true, result
end

-- ========================================
-- COMMAND HISTORY AND LOGGING
-- ========================================

---Log command execution for debugging
---@param command string Command that was executed
---@param result string Command execution result
---@param success boolean Whether command succeeded
---@usage
--- LogCommand("Fixture 1 At 100", "OK", true)
function LogCommand(command, result, success)
    local timestamp = os.date("%H:%M:%S")
    local status = success and "SUCCESS" or "FAILED"
    local logEntry = string.format("[%s] %s: %s -> %s", timestamp, status, command, result)
    
    Printf("CMD_LOG: " .. logEntry)
end

---Get recent command history
---@param count? integer Number of recent commands to retrieve (default: 10)
---@return table history Array of command history entries
---@usage
--- local history = GetCommandHistory(5)
--- for _, entry in ipairs(history) do
---     Printf("Previous command: " .. entry.command)
--- end
function GetCommandHistory(count)
    count = count or 10
    local cmdObj = CmdObj()
    local history = {}
    
    -- This would need to be implemented based on actual MA3 API
    -- for accessing command history
    -- For now, return empty array
    
    return history
end

-- ========================================
-- SPECIALIZED COMMAND BUILDERS
-- ========================================

---Build selection command
---@param objectType string Type of object to select
---@param selection string|table Selection specification
---@return string command Selection command string
---@usage
--- local cmd = BuildSelectionCommand("Fixture", "1 Thru 10")
--- Cmd(cmd) -- Executes "Select Fixture 1 Thru 10"
function BuildSelectionCommand(objectType, selection)
    local formatted = FormatSelection(objectType, selection)
    return "Select " .. formatted
end

---Build property setting command
---@param target string Target selection
---@param property string Property to set ("At", "Color", "Position", etc.)
---@param value any Property value
---@param modifiers? table Optional modifiers (Fade, Delay, etc.)
---@return string command Property setting command
---@usage
--- local cmd = BuildPropertyCommand("Fixture 1", "At", 75, {Fade = 3, Delay = 1})
--- -- Returns: "Fixture 1 At 75 Fade 3 Delay 1"
function BuildPropertyCommand(target, property, value, modifiers)
    local command = target .. " " .. property .. " " .. tostring(value)
    
    if modifiers then
        for modifier, modValue in pairs(modifiers) do
            command = command .. " " .. modifier .. " " .. tostring(modValue)
        end
    end
    
    return command
end

---Build storage command
---@param action string Storage action ("Store", "Update", "Copy", "Move", "Delete")
---@param target string Target for storage
---@param options? table Optional storage options
---@return string command Storage command string
---@usage
--- local cmd = BuildStorageCommand("Store", "Cue 1")
--- -- Returns: "Store Cue 1"
--- 
--- local cmd2 = BuildStorageCommand("Copy", "Cue 1 At 2")
--- -- Returns: "Copy Cue 1 At 2"
function BuildStorageCommand(action, target, options)
    local command = action .. " " .. target
    
    if options then
        for key, value in pairs(options) do
            command = command .. " " .. key .. " " .. tostring(value)
        end
    end
    
    return command
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Simple Command Execution:
   Cmd("Clear")
   Cmd("Fixture 1 At 100")
   Cmd("Store Cue 1")

2. Safe Command Execution with Error Handling:
   local success, result = SafeCmd("Fixture 1 At 100")
   if success then
       Printf("Command executed successfully")
   else
       Printf("Command failed: " .. result)
   end

3. Dynamic Command Building:
   local fixtures = {1, 2, 3, 4, 5}
   local intensity = 75
   
   for _, fixtureNum in ipairs(fixtures) do
       local cmd = BuildPropertyCommand("Fixture " .. fixtureNum, "At", intensity)
       SafeCmd(cmd)
   end

4. Command Sequence Execution:
   local setupSequence = {
       "Clear",
       "Fixture 1 Thru 10 At 50",
       "Color Red",
       "Store Cue 1"
   }
   
   local results = ExecuteCommandSequence(setupSequence)
   local allSucceeded = true
   for _, result in ipairs(results) do
       if not result.success then
           allSucceeded = false
           Printf("Failed: " .. result.command .. " - " .. result.result)
       end
   end

5. User-Initiated Commands with Validation:
   CreateInputDialog("Enter Command", "MA3 Command:", function(command)
       if command and command ~= "" then
           local valid, error = ValidateCommandSyntax(command)
           if valid then
               local needsConfirm, reason = CommandRequiresConfirmation(command)
               if needsConfirm then
                   CreateConfirmDialog("Confirm", reason, function(confirmed)
                       if confirmed then
                           SafeCmd(command)
                       end
                   end)
               else
                   SafeCmd(command)
               end
           else
               ShowValidationError(error)
           end
       end
   end)

6. Indirect Command Execution for Long Operations:
   -- Start long-running operation without blocking
   CmdIndirect("Go Sequence 1")
   
   -- Continue with other operations
   Printf("Sequence started, continuing with other tasks...")
   
   -- Wait for critical operation to complete
   CmdIndirectWait("Store Cue 2")
   Printf("Cue 2 storage completed")

INTEGRATION WITH OTHER APIS:
- Use Handle:Addr() to get object addresses for commands
- Combine with UI dialogs for user command input
- Integrate with validation utilities for parameter checking
- Connect with error handling systems for robust execution

PERFORMANCE CONSIDERATIONS:
- Use CmdIndirect for non-critical, non-blocking operations
- Batch related commands when possible
- Validate syntax before execution to avoid unnecessary API calls
- Cache frequently used command patterns

ERROR HANDLING BEST PRACTICES:
- Always validate command syntax before execution
- Use SafeCmd wrapper for automatic error handling
- Log command execution for debugging purposes
- Provide user feedback for command results
- Implement retry logic for transient failures
]]

return CommandExecution