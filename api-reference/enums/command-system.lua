---@meta
--- Command System Enumerations
--- Command types, parameter formats, execution modes, and result codes
--- 
--- These enumerations define the command system structure, including
--- command categories, parameter types, execution modes, and status codes.

---@class CommandSystemEnums
local CommandSystemEnums = {}

-- ========================================
-- COMMAND CATEGORIES AND TYPES
-- ========================================

---@enum CommandType
--- Categories of MA3 commands
CommandSystemEnums.CommandType = {
    Selection = 0,    -- Object selection commands
    Property = 1,     -- Property modification commands
    Storage = 2,      -- Store/recall commands
    Playback = 3,     -- Playback control commands
    System = 4,       -- System operation commands
    Navigation = 5,   -- View and navigation commands
    Tool = 6,         -- Tool and utility commands
    Macro = 7         -- Macro execution commands
}

---@enum SelectionCommand
--- Object selection command types
CommandSystemEnums.SelectionCommand = {
    Select = 0,       -- Select objects
    All = 1,          -- Select all objects
    Clear = 2,        -- Clear selection
    Invert = 3,       -- Invert selection
    Last = 4,         -- Select last used
    Next = 5,         -- Select next object
    Previous = 6      -- Select previous object
}

---@enum PropertyCommand
--- Property modification command types
CommandSystemEnums.PropertyCommand = {
    At = 0,           -- Set intensity
    Color = 1,        -- Set color
    Position = 2,     -- Set position
    Gobo = 3,         -- Set gobo
    Beam = 4,         -- Set beam parameters
    Focus = 5,        -- Set focus
    Control = 6,      -- Set control channels
    Fade = 7,         -- Set fade time
    Delay = 8         -- Set delay time
}

---@enum StorageCommand
--- Storage and recall command types
CommandSystemEnums.StorageCommand = {
    Store = 0,        -- Store current state
    Update = 1,       -- Update existing
    Copy = 2,         -- Copy object
    Move = 3,         -- Move object
    Delete = 4,       -- Delete object
    Import = 5,       -- Import data
    Export = 6,       -- Export data
    Merge = 7         -- Merge data
}

---@enum PlaybackCommand
--- Playback control command types
CommandSystemEnums.PlaybackCommand = {
    Go = 0,           -- Start playback
    Pause = 1,        -- Pause playback
    Off = 2,          -- Stop playback
    On = 3,           -- Enable playback
    Toggle = 4,       -- Toggle playback state
    Flash = 5,        -- Flash playback
    Black = 6,        -- Blackout
    Rate = 7,         -- Set playback rate
    Time = 8          -- Set timing
}

-- ========================================
-- PARAMETER TYPES AND FORMATS
-- ========================================

---@enum ParameterType
--- Command parameter data types
CommandSystemEnums.ParameterType = {
    None = 0,         -- No parameters
    Numeric = 1,      -- Numeric value
    String = 2,       -- Text string
    Object = 3,       -- Object reference
    Range = 4,        -- Value range
    List = 5,         -- Value list
    Expression = 6,   -- Mathematical expression
    Time = 7,         -- Time value
    Color = 8         -- Color value
}

---@enum NumericFormat
--- Numeric parameter formats
CommandSystemEnums.NumericFormat = {
    Integer = 0,      -- Whole numbers
    Decimal = 1,      -- Decimal numbers
    Percentage = 2,   -- Percentage values
    DMX = 3,          -- DMX values (0-255)
    Degrees = 4,      -- Angle in degrees
    Seconds = 5,      -- Time in seconds
    Frames = 6        -- Frame count
}

---@enum ObjectReference
--- Object reference formats in commands
CommandSystemEnums.ObjectReference = {
    Index = 0,        -- Numeric index
    Name = 1,         -- Object name
    Range = 2,        -- Index range (1 thru 10)
    Selection = 3,    -- Current selection
    All = 4,          -- All objects
    Group = 5,        -- Group reference
    Pattern = 6       -- Pattern matching
}

-- ========================================
-- EXECUTION MODES AND STATES
-- ========================================

---@enum ExecutionMode
--- Command execution modes
CommandSystemEnums.ExecutionMode = {
    Immediate = 0,    -- Execute immediately
    Queued = 1,       -- Add to command queue
    Batch = 2,        -- Part of batch operation
    Deferred = 3,     -- Execute later
    Conditional = 4,  -- Execute if condition met
    Loop = 5          -- Execute repeatedly
}

---@enum ExecutionState
--- Command execution states
CommandSystemEnums.ExecutionState = {
    Pending = 0,      -- Waiting to execute
    Running = 1,      -- Currently executing
    Completed = 2,    -- Finished successfully
    Failed = 3,       -- Execution failed
    Cancelled = 4,    -- Cancelled by user
    Timeout = 5       -- Execution timed out
}

---@enum Priority
--- Command execution priority levels
CommandSystemEnums.Priority = {
    Low = 0,          -- Low priority
    Normal = 1,       -- Normal priority
    High = 2,         -- High priority
    Critical = 3,     -- Critical priority
    Emergency = 4     -- Emergency priority
}

-- ========================================
-- RESULT CODES AND STATUS
-- ========================================

---@enum ResultCode
--- Command execution result codes
CommandSystemEnums.ResultCode = {
    Success = 0,      -- Command succeeded
    Warning = 1,      -- Succeeded with warnings
    Error = 2,        -- Command failed
    InvalidSyntax = 3, -- Syntax error
    InvalidObject = 4, -- Object not found
    InvalidValue = 5, -- Invalid parameter value
    AccessDenied = 6, -- Insufficient permissions
    Timeout = 7,      -- Operation timed out
    Cancelled = 8,    -- Cancelled by user
    NotSupported = 9  -- Operation not supported
}

---@enum ErrorType
--- Command error categories
CommandSystemEnums.ErrorType = {
    Syntax = 0,       -- Syntax errors
    Semantic = 1,     -- Logical errors
    Runtime = 2,      -- Execution errors
    Permission = 3,   -- Access errors
    Resource = 4,     -- Resource errors
    Network = 5,      -- Network errors
    Hardware = 6,     -- Hardware errors
    Data = 7          -- Data errors
}

---@enum WarningType
--- Command warning categories
CommandSystemEnums.WarningType = {
    Deprecated = 0,   -- Deprecated syntax
    Performance = 1,  -- Performance impact
    Precision = 2,    -- Precision loss
    Compatibility = 3, -- Compatibility issue
    Resource = 4,     -- Resource usage
    Security = 5      -- Security concern
}

-- ========================================
-- SYNTAX AND FORMATTING
-- ========================================

---@enum SyntaxElement
--- Command syntax elements
CommandSystemEnums.SyntaxElement = {
    Keyword = 0,      -- Command keyword
    Object = 1,       -- Object identifier
    Property = 2,     -- Property name
    Value = 3,        -- Parameter value
    Operator = 4,     -- Operator symbol
    Separator = 5,    -- Separator character
    Modifier = 6,     -- Command modifier
    Comment = 7       -- Comment text
}

---@enum Operator
--- Command operators
CommandSystemEnums.Operator = {
    At = 0,           -- @ (at/to value)
    Thru = 1,         -- Thru (range)
    Plus = 2,         -- + (add/increment)
    Minus = 3,        -- - (subtract/decrement)
    Times = 4,        -- * (multiply)
    Divide = 5,       -- / (divide)
    Percent = 6,      -- % (percentage)
    And = 7,          -- + (logical and)
    Or = 8,           -- + (logical or)
    Not = 9           -- ! (logical not)
}

---@enum Modifier
--- Command modifiers
CommandSystemEnums.Modifier = {
    If = 0,           -- Conditional execution
    Unless = 1,       -- Negative conditional
    Time = 2,         -- Time modifier
    Fade = 3,         -- Fade modifier
    Delay = 4,        -- Delay modifier
    Part = 5,         -- Part modifier
    Cue = 6,          -- Cue modifier
    Page = 7          -- Page modifier
}

-- ========================================
-- COMMAND CONTEXT AND SCOPE
-- ========================================

---@enum CommandScope
--- Command execution scope
CommandSystemEnums.CommandScope = {
    Global = 0,       -- Affects entire system
    Session = 1,      -- Affects current session
    User = 2,         -- Affects current user
    Selection = 3,    -- Affects current selection
    Object = 4,       -- Affects specific object
    Local = 5         -- Affects local context
}

---@enum ContextType
--- Command execution context
CommandSystemEnums.ContextType = {
    Live = 0,         -- Live output context
    Blind = 1,        -- Blind programming context
    Preview = 2,      -- Preview context
    Backup = 3,       -- Backup context
    Offline = 4,      -- Offline context
    Remote = 5        -- Remote context
}

-- ========================================
-- USAGE EXAMPLES
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Command Type Classification:
   local function classifyCommand(commandString)
       local cmd = commandString:lower()
       if cmd:match("^select") or cmd:match("^all") or cmd:match("^clear") then
           return CommandSystemEnums.CommandType.Selection
       elseif cmd:match("at %d") or cmd:match("color") or cmd:match("position") then
           return CommandSystemEnums.CommandType.Property
       elseif cmd:match("store") or cmd:match("copy") or cmd:match("delete") then
           return CommandSystemEnums.CommandType.Storage
       elseif cmd:match("go") or cmd:match("pause") or cmd:match("off") then
           return CommandSystemEnums.CommandType.Playback
       end
       return CommandSystemEnums.CommandType.System
   end

2. Parameter Validation:
   local function validateParameter(value, paramType)
       if paramType == CommandSystemEnums.ParameterType.Numeric then
           return tonumber(value) ~= nil
       elseif paramType == CommandSystemEnums.ParameterType.String then
           return type(value) == "string"
       elseif paramType == CommandSystemEnums.ParameterType.Range then
           return value:match("%d+%s+thru%s+%d+") ~= nil
       end
       return false
   end

3. Result Code Handling:
   local function handleCommandResult(resultCode, message)
       if resultCode == CommandSystemEnums.ResultCode.Success then
           Printf("Command executed successfully")
       elseif resultCode == CommandSystemEnums.ResultCode.Warning then
           Printf("Warning: " .. message)
       elseif resultCode == CommandSystemEnums.ResultCode.Error then
           Printf("Error: " .. message)
       elseif resultCode == CommandSystemEnums.ResultCode.InvalidSyntax then
           Printf("Syntax error: " .. message)
       end
   end

4. Command Builder:
   local function buildCommand(commandType, objects, parameters)
       local cmd = ""
       
       if commandType == CommandSystemEnums.CommandType.Selection then
           cmd = "Select " .. objects
       elseif commandType == CommandSystemEnums.CommandType.Property then
           cmd = objects .. " At " .. parameters.intensity
           if parameters.color then
               cmd = cmd .. " Color " .. parameters.color
           end
       elseif commandType == CommandSystemEnums.CommandType.Storage then
           cmd = "Store " .. parameters.destination
       end
       
       return cmd
   end

5. Execution Priority Management:
   local function executeCommand(command, priority)
       local queue = getCommandQueue()
       
       if priority == CommandSystemEnums.Priority.Emergency then
           -- Execute immediately, bypass queue
           return executeImmediate(command)
       elseif priority == CommandSystemEnums.Priority.High then
           -- Insert at front of queue
           queue:insertFront(command)
       else
           -- Add to end of queue
           queue:append(command)
       end
   end

6. Syntax Validation:
   local function validateSyntax(commandString)
       local tokens = parseCommand(commandString)
       local errors = {}
       
       for i, token in ipairs(tokens) do
           if token.type == CommandSystemEnums.SyntaxElement.Keyword then
               if not isValidKeyword(token.value) then
                   table.insert(errors, "Invalid keyword: " .. token.value)
               end
           elseif token.type == CommandSystemEnums.SyntaxElement.Value then
               if not validateValue(token.value, token.expectedType) then
                   table.insert(errors, "Invalid value: " .. token.value)
               end
           end
       end
       
       return #errors == 0, errors
   end

INTEGRATION WITH CMD() FUNCTION:
- Command types determine valid Cmd() parameters
- Result codes match Cmd() return values
- Parameter types guide Cmd() argument formatting
- Execution modes affect Cmd() timing behavior

CROSS-REFERENCES TO HANDLE METHODS:
- Object references work with Handle:Addr() output
- Property commands use Handle:Get() and Handle:Set()
- Storage commands integrate with Handle:Export/Import()
- Playback commands affect Handle:HasActivePlayback()

ERROR HANDLING PATTERNS:
- Always check result codes after command execution
- Implement retry logic for temporary failures
- Log command execution for debugging
- Provide user feedback for command results
]]

return CommandSystemEnums