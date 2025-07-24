---@meta
--- Command Building API Reference
--- Dynamic command construction and formatting utilities for MA3 plugins
--- 
--- This module provides advanced utilities for building complex MA3 commands
--- dynamically, including templates, parameter validation, and syntax helpers.

---@class CommandBuilding
local CommandBuilding = {}

-- ========================================
-- COMMAND TEMPLATE SYSTEM
-- ========================================

---Command template for reusable command patterns
---@class CommandTemplate
---@field pattern string Command pattern with placeholders like {fixture}, {intensity}
---@field parameters table Required parameter definitions
---@field validation table Validation rules for parameters
local CommandTemplate = {}

---Create a new command template
---@param pattern string Command pattern with placeholders
---@param parameters table Parameter definitions
---@param validation? table Optional validation rules
---@return CommandTemplate template New command template
---@usage
--- local intensityTemplate = CreateCommandTemplate(
---     "Fixture {fixtures} At {intensity}",
---     {fixtures = "string", intensity = "number"},
---     {intensity = {min = 0, max = 100}}
--- )
function CreateCommandTemplate(pattern, parameters, validation)
    return {
        pattern = pattern,
        parameters = parameters or {},
        validation = validation or {},
        
        ---Generate command from template
        ---@param values table Parameter values
        ---@return string|nil command Generated command or nil if validation fails
        ---@return string|nil error Error message if validation fails
        generate = function(self, values)
            -- Validate required parameters
            for param, paramType in pairs(self.parameters) do
                if not values[param] then
                    return nil, "Missing required parameter: " .. param
                end
                
                -- Type validation
                local value = values[param]
                if paramType == "number" and not tonumber(value) then
                    return nil, "Parameter '" .. param .. "' must be a number"
                elseif paramType == "string" and type(value) ~= "string" then
                    return nil, "Parameter '" .. param .. "' must be a string"
                end
                
                -- Custom validation
                if self.validation[param] then
                    local rules = self.validation[param]
                    if rules.min and tonumber(value) and tonumber(value) < rules.min then
                        return nil, "Parameter '" .. param .. "' must be at least " .. rules.min
                    end
                    if rules.max and tonumber(value) and tonumber(value) > rules.max then
                        return nil, "Parameter '" .. param .. "' must be at most " .. rules.max
                    end
                end
            end
            
            -- Generate command by replacing placeholders
            local command = self.pattern
            for param, value in pairs(values) do
                local placeholder = "{" .. param .. "}"
                command = command:gsub(placeholder, tostring(value))
            end
            
            -- Check for unreplaced placeholders
            if command:match("{[^}]+}") then
                return nil, "Command contains unreplaced placeholders"
            end
            
            return command, nil
        end
    }
end

-- ========================================
-- PREDEFINED COMMAND TEMPLATES
-- ========================================

---Collection of commonly used command templates
local CommandTemplates = {
    -- Selection templates
    selectFixtures = CreateCommandTemplate(
        "Select Fixture {fixtures}",
        {fixtures = "string"},
        {}
    ),
    
    selectGroups = CreateCommandTemplate(
        "Select Group {groups}",
        {groups = "string"},
        {}
    ),
    
    -- Property setting templates
    setIntensity = CreateCommandTemplate(
        "{target} At {intensity}",
        {target = "string", intensity = "number"},
        {intensity = {min = 0, max = 100}}
    ),
    
    setColor = CreateCommandTemplate(
        "{target} Color {color}",
        {target = "string", color = "string"},
        {}
    ),
    
    setPosition = CreateCommandTemplate(
        "{target} Position {pan} {tilt}",
        {target = "string", pan = "number", tilt = "number"},
        {pan = {min = -270, max = 270}, tilt = {min = -135, max = 135}}
    ),
    
    -- Storage templates
    storeCue = CreateCommandTemplate(
        "Store Cue {cue}",
        {cue = "string"},
        {}
    ),
    
    storeGroup = CreateCommandTemplate(
        "Store Group {group}",
        {group = "string"},
        {}
    ),
    
    -- Playback templates
    goCue = CreateCommandTemplate(
        "Go Cue {cue}",
        {cue = "string"},
        {}
    ),
    
    pauseSequence = CreateCommandTemplate(
        "Pause Sequence {sequence}",
        {sequence = "string"},
        {}
    )
}

---Get a predefined command template
---@param templateName string Name of the template
---@return CommandTemplate|nil template Command template or nil if not found
---@usage
--- local template = GetCommandTemplate("setIntensity")
--- local cmd, error = template:generate({target = "Fixture 1", intensity = 75})
function GetCommandTemplate(templateName)
    return CommandTemplates[templateName]
end

-- ========================================
-- DYNAMIC SELECTION BUILDERS
-- ========================================

---Build fixture selection string from various input formats
---@param fixtures string|table|number Fixture specification
---@return string selection Formatted fixture selection
---@usage
--- local sel1 = BuildFixtureSelection(1)              -- "1" 
--- local sel2 = BuildFixtureSelection("1 Thru 10")    -- "1 Thru 10"
--- local sel3 = BuildFixtureSelection({1, 2, 5, 7})   -- "1 + 2 + 5 + 7"
--- local sel4 = BuildFixtureSelection({{1, 5}, {10, 15}}) -- "1 Thru 5 + 10 Thru 15"
function BuildFixtureSelection(fixtures)
    if type(fixtures) == "number" then
        return tostring(fixtures)
    elseif type(fixtures) == "string" then
        return fixtures
    elseif type(fixtures) == "table" then
        local parts = {}
        for _, item in ipairs(fixtures) do
            if type(item) == "table" and #item == 2 then
                -- Range specification [start, end]
                table.insert(parts, item[1] .. " Thru " .. item[2])
            else
                -- Individual fixture
                table.insert(parts, tostring(item))
            end
        end
        return table.concat(parts, " + ")
    end
    return ""
end

---Build group selection string
---@param groups string|table|number Group specification
---@return string selection Formatted group selection
---@usage
--- local sel = BuildGroupSelection({1, 2, "MyGroup"})
--- -- Returns: "1 + 2 + \"MyGroup\""
function BuildGroupSelection(groups)
    if type(groups) == "number" then
        return tostring(groups)
    elseif type(groups) == "string" then
        return groups
    elseif type(groups) == "table" then
        local parts = {}
        for _, item in ipairs(groups) do
            if type(item) == "string" and item:match("[^%w]") then
                -- Escape string with spaces or special characters
                table.insert(parts, '"' .. item .. '"')
            else
                table.insert(parts, tostring(item))
            end
        end
        return table.concat(parts, " + ")
    end
    return ""
end

---Build mixed object selection (fixtures, groups, etc.)
---@param objects table Object specifications {type, selection}
---@return string selection Formatted mixed selection
---@usage
--- local objects = {
---     {type = "Fixture", selection = "1 Thru 10"},
---     {type = "Group", selection = "MyGroup"}
--- }
--- local sel = BuildMixedSelection(objects)
--- -- Returns: "Fixture 1 Thru 10 + Group \"MyGroup\""
function BuildMixedSelection(objects)
    local parts = {}
    for _, obj in ipairs(objects) do
        local formatted = obj.type .. " " .. obj.selection
        table.insert(parts, formatted)
    end
    return table.concat(parts, " + ")
end

-- ========================================
-- PARAMETER FORMATTING UTILITIES
-- ========================================

---Format intensity value with proper range checking
---@param intensity number Intensity value (0-100)
---@param format? string Format type ("percent", "dmx", "decimal")
---@return string formatted Formatted intensity value
---@usage
--- local int1 = FormatIntensity(75)          -- "75"
--- local int2 = FormatIntensity(0.75, "decimal") -- "0.75"
--- local int3 = FormatIntensity(75, "dmx")   -- "191"
function FormatIntensity(intensity, format)
    format = format or "percent"
    
    if format == "percent" then
        return tostring(math.max(0, math.min(100, intensity)))
    elseif format == "decimal" then
        return string.format("%.2f", math.max(0, math.min(1, intensity)))
    elseif format == "dmx" then
        local dmxValue = math.floor((intensity / 100) * 255)
        return tostring(math.max(0, math.min(255, dmxValue)))
    end
    
    return tostring(intensity)
end

---Format color value for command use
---@param color string|table Color specification
---@return string formatted Formatted color value
---@usage
--- local col1 = FormatColor("Red")                    -- "Red"
--- local col2 = FormatColor({r=255, g=0, b=0})       -- "255,0,0"
--- local col3 = FormatColor("#FF0000")               -- "\"#FF0000\""
function FormatColor(color)
    if type(color) == "string" then
        -- Named color or hex color
        if color:match("^#") or color:match("[%s%+%-%*/%@]") then
            return '"' .. color .. '"'
        else
            return color
        end
    elseif type(color) == "table" then
        -- RGB color object
        if color.r and color.g and color.b then
            return color.r .. "," .. color.g .. "," .. color.b
        end
    end
    return tostring(color)
end

---Format position values (pan/tilt)
---@param pan number Pan value in degrees
---@param tilt number Tilt value in degrees
---@param format? string Format type ("degrees", "percent", "dmx")
---@return string panFormatted Formatted pan value
---@return string tiltFormatted Formatted tilt value
---@usage
--- local pan, tilt = FormatPosition(45, -30)
--- local cmd = "Fixture 1 Position " .. pan .. " " .. tilt
function FormatPosition(pan, tilt, format)
    format = format or "degrees"
    
    if format == "degrees" then
        return tostring(pan), tostring(tilt)
    elseif format == "percent" then
        -- Convert degrees to percentage (assuming full range)
        local panPercent = (pan + 270) / 540 * 100
        local tiltPercent = (tilt + 135) / 270 * 100
        return string.format("%.1f", panPercent), string.format("%.1f", tiltPercent)
    elseif format == "dmx" then
        -- Convert to DMX values (0-255)
        local panDmx = math.floor(((pan + 270) / 540) * 255)
        local tiltDmx = math.floor(((tilt + 135) / 270) * 255)
        return tostring(panDmx), tostring(tiltDmx)
    end
    
    return tostring(pan), tostring(tilt)
end

---Format time values for command use
---@param time number Time value in seconds
---@param format? string Format type ("seconds", "frames", "beats")
---@return string formatted Formatted time value
---@usage
--- local time1 = FormatTime(3.5)              -- "3.5"
--- local time2 = FormatTime(3.5, "frames")    -- "84" (assuming 24fps)
function FormatTime(time, format)
    format = format or "seconds"
    
    if format == "seconds" then
        return string.format("%.1f", time)
    elseif format == "frames" then
        -- Assume 24 fps
        local frames = math.floor(time * 24)
        return tostring(frames)
    elseif format == "beats" then
        -- Would need BPM information for accurate conversion
        return string.format("%.2f", time)
    end
    
    return tostring(time)
end

-- ========================================
-- COMPLEX COMMAND BUILDERS
-- ========================================

---Build a comprehensive property setting command
---@param target string Target selection
---@param properties table Properties to set {intensity, color, position, gobo, etc.}
---@param modifiers? table Optional modifiers {fade, delay, time}
---@return string command Complete property command
---@usage
--- local cmd = BuildPropertyCommand("Fixture 1 Thru 10", {
---     intensity = 75,
---     color = "Red",
---     position = {pan = 45, tilt = -30}
--- }, {fade = 3, delay = 1})
function BuildPropertyCommand(target, properties, modifiers)
    local parts = {target}
    
    -- Add intensity
    if properties.intensity then
        table.insert(parts, "At " .. FormatIntensity(properties.intensity))
    end
    
    -- Add color
    if properties.color then
        table.insert(parts, "Color " .. FormatColor(properties.color))
    end
    
    -- Add position
    if properties.position then
        local pan, tilt = FormatPosition(properties.position.pan, properties.position.tilt)
        table.insert(parts, "Position " .. pan .. " " .. tilt)
    end
    
    -- Add gobo
    if properties.gobo then
        table.insert(parts, "Gobo " .. tostring(properties.gobo))
    end
    
    -- Add beam properties
    if properties.zoom then
        table.insert(parts, "Zoom " .. tostring(properties.zoom))
    end
    
    if properties.focus then
        table.insert(parts, "Focus " .. tostring(properties.focus))
    end
    
    if properties.iris then
        table.insert(parts, "Iris " .. tostring(properties.iris))
    end
    
    -- Add modifiers
    if modifiers then
        if modifiers.fade then
            table.insert(parts, "Fade " .. FormatTime(modifiers.fade))
        end
        if modifiers.delay then
            table.insert(parts, "Delay " .. FormatTime(modifiers.delay))
        end
        if modifiers.time then
            table.insert(parts, "Time " .. FormatTime(modifiers.time))
        end
    end
    
    return table.concat(parts, " ")
end

---Build a sequence of related commands
---@param commandSpecs table Array of command specifications
---@param options? table Optional execution options {separator, validate}
---@return table commands Array of generated commands
---@usage
--- local specs = {
---     {type = "selection", target = "Fixture", selection = "1 Thru 10"},
---     {type = "property", properties = {intensity = 75}, modifiers = {fade = 3}},
---     {type = "storage", action = "Store", target = "Cue 1"}
--- }
--- local commands = BuildCommandSequence(specs)
function BuildCommandSequence(commandSpecs, options)
    options = options or {}
    local commands = {}
    local currentTarget = ""
    
    for _, spec in ipairs(commandSpecs) do
        local command = ""
        
        if spec.type == "selection" then
            currentTarget = spec.target .. " " .. spec.selection
            command = "Select " .. currentTarget
        elseif spec.type == "property" then
            local target = spec.target or currentTarget
            command = BuildPropertyCommand(target, spec.properties, spec.modifiers)
        elseif spec.type == "storage" then
            command = spec.action .. " " .. spec.target
        elseif spec.type == "playback" then
            command = spec.action .. " " .. spec.target
        elseif spec.type == "custom" then
            command = spec.command
        end
        
        if command ~= "" then
            table.insert(commands, command)
        end
    end
    
    return commands
end

-- ========================================
-- COMMAND OPTIMIZATION
-- ========================================

---Optimize command sequence by combining compatible commands
---@param commands table Array of command strings
---@return table optimized Array of optimized commands
---@usage
--- local original = {"Select Fixture 1", "At 50", "Color Red", "Select Fixture 2", "At 75"}
--- local optimized = OptimizeCommandSequence(original)
--- -- May combine compatible operations
function OptimizeCommandSequence(commands)
    local optimized = {}
    local currentSelection = ""
    local pendingProperties = {}
    
    for _, command in ipairs(commands) do
        local cmd = command:match("^%s*(.-)%s*$") -- Trim whitespace
        
        if cmd:match("^Select ") then
            -- New selection, flush pending properties
            if currentSelection ~= "" and #pendingProperties > 0 then
                local combined = currentSelection .. " " .. table.concat(pendingProperties, " ")
                table.insert(optimized, combined)
                pendingProperties = {}
            end
            currentSelection = cmd:gsub("^Select ", "")
        elseif cmd:match("^At ") or cmd:match("^Color ") or cmd:match("^Position ") then
            -- Property command, can be combined
            table.insert(pendingProperties, cmd)  
        else
            -- Other command, flush pending and add as-is
            if currentSelection ~= "" and #pendingProperties > 0 then
                local combined = currentSelection .. " " .. table.concat(pendingProperties, " ")
                table.insert(optimized, combined)
                pendingProperties = {}
                currentSelection = ""
            end
            table.insert(optimized, cmd)
        end
    end
    
    -- Flush any remaining pending properties
    if currentSelection ~= "" and #pendingProperties > 0 then
        local combined = currentSelection .. " " .. table.concat(pendingProperties, " ")
        table.insert(optimized, combined)
    end
    
    return optimized
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Template-Based Command Generation:
   local template = GetCommandTemplate("setIntensity")
   local cmd, error = template:generate({
       target = "Fixture 1 Thru 10",
       intensity = 75
   })
   if cmd then
       Cmd(cmd)
   end

2. Dynamic Fixture Selection:
   local selectedFixtures = {1, 2, 5, {10, 15}} -- Individual and ranges
   local selection = BuildFixtureSelection(selectedFixtures)
   local cmd = "Select Fixture " .. selection
   Cmd(cmd)

3. Complex Property Setting:
   local cmd = BuildPropertyCommand("Fixture 1 Thru 10", {
       intensity = 75,
       color = {r = 255, g = 0, b = 0},
       position = {pan = 45, tilt = -30},
       gobo = 1
   }, {
       fade = 3,
       delay = 1
   })
   Cmd(cmd)

4. Multi-Step Command Sequence:
   local specs = {
       {type = "selection", target = "Fixture", selection = "1 Thru 10"},
       {type = "property", properties = {intensity = 50, color = "Red"}},
       {type = "storage", action = "Store", target = "Cue 1"},
       {type = "selection", target = "Group", selection = "1"},
       {type = "property", properties = {intensity = 100}},
       {type = "storage", action = "Store", target = "Cue 2"}
   }
   
   local commands = BuildCommandSequence(specs)
   for _, cmd in ipairs(commands) do
       local success, result = SafeCmd(cmd)
       if not success then
           Printf("Command failed: " .. cmd)
           break
       end
   end

5. Custom Template Creation:
   local myTemplate = CreateCommandTemplate(
       "Fixture {fixtures} At {intensity} Color {color} Fade {fade}",
       {fixtures = "string", intensity = "number", color = "string", fade = "number"},
       {
           intensity = {min = 0, max = 100},
           fade = {min = 0, max = 60}
       }
   )
   
   local cmd, error = myTemplate:generate({
       fixtures = "1 Thru 10",
       intensity = 75,
       color = "Red",
       fade = 3
   })

6. Command Optimization:
   local commands = {
       "Select Fixture 1",
       "At 50",
       "Color Red",
       "Select Fixture 2", 
       "At 75",
       "Color Blue"
   }
   
   local optimized = OptimizeCommandSequence(commands)
   -- Results in fewer, more efficient commands

INTEGRATION WITH VALIDATION:
- Use ValidateCommandSyntax() before executing generated commands
- Implement parameter validation in custom templates
- Check command requirements before building complex sequences

PERFORMANCE CONSIDERATIONS:
- Cache frequently used templates
- Optimize command sequences to reduce MA3 API calls
- Use batch operations where possible
- Pre-validate parameters to avoid failed command generation

ERROR HANDLING:
- Always check template generation results
- Validate parameter types and ranges
- Handle missing required parameters gracefully
- Provide meaningful error messages for debugging
]]

return CommandBuilding