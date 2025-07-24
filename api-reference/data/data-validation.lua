---@meta
--- Data Validation API Reference
--- Comprehensive validation utilities for MA3 data types and object properties
--- 
--- This module provides robust validation functions for MA3 objects, properties,
--- and data types, ensuring data integrity and preventing invalid operations.

---@class DataValidation
local DataValidation = {}

-- ========================================
-- OBJECT VALIDATION
-- ========================================

---Validate if an object handle is valid and accessible
---@param object Handle Object handle to validate
---@return boolean valid True if object is valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = DataValidation.ValidateObject(fixture)
--- if not valid then
---     Printf("Invalid object: " .. error)
---     return
--- end
function DataValidation.ValidateObject(object)
    if not object then
        return false, "Object is nil"
    end
    
    local success, result = pcall(function()
        return object:GetClass()
    end)
    
    if not success then
        return false, "Object handle is invalid or corrupted"
    end
    
    if not result or result == "" then
        return false, "Object class is undefined"
    end
    
    return true, nil
end

---Validate object type against expected class
---@param object Handle Object handle to validate
---@param expectedClass string Expected object class name
---@return boolean valid True if object matches expected class
---@return string|nil error Error message if invalid
---@usage
--- local valid, error = DataValidation.ValidateObjectType(sequence, "Sequence")
function DataValidation.ValidateObjectType(object, expectedClass)
    local valid, error = DataValidation.ValidateObject(object)
    if not valid then
        return false, error
    end
    
    local actualClass = object:GetClass()
    if actualClass ~= expectedClass then
        return false, "Expected " .. expectedClass .. " but got " .. actualClass
    end
    
    return true, nil
end

---Validate object has required properties
---@param object Handle Object handle to validate
---@param requiredProperties table Array of required property names
---@return boolean valid True if all properties exist
---@return table missing Array of missing property names
---@usage
--- local valid, missing = DataValidation.ValidateObjectProperties(fixture, {"name", "intensity", "color"})
function DataValidation.ValidateObjectProperties(object, requiredProperties)
    local valid, error = DataValidation.ValidateObject(object)
    if not valid then
        return false, {error}
    end
    
    local missing = {}
    for _, property in ipairs(requiredProperties) do
        local value = object:Get(property)
        if not value or value == "" then
            table.insert(missing, property)
        end
    end
    
    return #missing == 0, missing
end

---Validate object exists at specified address
---@param address string Object address to validate
---@return boolean valid True if object exists
---@return Handle|nil object Object handle if found
---@return string|nil error Error message if invalid
---@usage
--- local valid, object, error = DataValidation.ValidateObjectAddress("Fixture 1")
function DataValidation.ValidateObjectAddress(address)
    if not address or address == "" then
        return false, nil, "Address cannot be empty"
    end
    
    local success, object = pcall(function()
        return Obj(address)
    end)
    
    if not success then
        return false, nil, "Failed to resolve address: " .. address
    end
    
    if not object then
        return false, nil, "No object found at address: " .. address
    end
    
    local valid, error = DataValidation.ValidateObject(object)
    if not valid then
        return false, nil, "Object at " .. address .. " is invalid: " .. error
    end
    
    return true, object, nil
end

-- ========================================
-- PROPERTY VALIDATION
-- ========================================

---Validate property value against type and constraints
---@param value any Property value to validate
---@param dataType string Expected data type ("string", "number", "boolean", "table")
---@param constraints? table Optional constraints {min, max, pattern, enum}
---@return boolean valid True if value is valid
---@return any converted Converted value if valid
---@return string|nil error Error message if invalid
---@usage
--- local valid, converted, error = DataValidation.ValidateProperty("75", "number", {min = 0, max = 100})
function DataValidation.ValidateProperty(value, dataType, constraints)
    constraints = constraints or {}
    
    -- Handle nil values
    if value == nil then
        if constraints.required then
            return false, nil, "Property value is required"
        else
            return true, nil, nil
        end
    end
    
    -- Type conversion and validation
    local converted = value
    
    if dataType == "number" then
        converted = tonumber(value)
        if not converted then
            return false, nil, "Value must be a number"
        end
        
        if constraints.min and converted < constraints.min then
            return false, nil, "Value must be at least " .. constraints.min
        end
        
        if constraints.max and converted > constraints.max then
            return false, nil, "Value must be at most " .. constraints.max
        end
        
    elseif dataType == "string" then
        converted = tostring(value)
        
        if constraints.minLength and #converted < constraints.minLength then
            return false, nil, "String must be at least " .. constraints.minLength .. " characters"
        end
        
        if constraints.maxLength and #converted > constraints.maxLength then
            return false, nil, "String must be at most " .. constraints.maxLength .. " characters"
        end
        
        if constraints.pattern and not converted:match(constraints.pattern) then
            return false, nil, "String does not match required pattern"
        end
        
    elseif dataType == "boolean" then
        if type(value) == "boolean" then
            converted = value
        elseif type(value) == "string" then
            local lower = value:lower()
            converted = lower == "true" or lower == "yes" or lower == "1" or lower == "on"
        elseif type(value) == "number" then
            converted = value ~= 0
        else
            return false, nil, "Cannot convert value to boolean"
        end
        
    elseif dataType == "table" then
        if type(value) ~= "table" then
            return false, nil, "Value must be a table"
        end
        converted = value
    end
    
    -- Enum validation
    if constraints.enum then
        local found = false
        for _, enumValue in ipairs(constraints.enum) do
            if converted == enumValue then
                found = true
                break
            end
        end
        if not found then
            return false, nil, "Value must be one of: " .. table.concat(constraints.enum, ", ")
        end
    end
    
    return true, converted, nil
end

---Validate intensity value (0-100%)
---@param intensity any Intensity value to validate
---@return boolean valid True if intensity is valid
---@return number|nil converted Converted intensity value
---@return string|nil error Error message if invalid
---@usage
--- local valid, intensity, error = DataValidation.ValidateIntensity("75")
function DataValidation.ValidateIntensity(intensity)
    return DataValidation.ValidateProperty(intensity, "number", {
        min = 0,
        max = 100,
        required = true
    })
end

---Validate color value (name, hex, or RGB)
---@param color any Color value to validate
---@return boolean valid True if color is valid
---@return string|nil converted Converted color value
---@return string|nil error Error message if invalid
---@usage
--- local valid, color, error = DataValidation.ValidateColor("Red")
function DataValidation.ValidateColor(color)
    if not color or color == "" then
        return false, nil, "Color value cannot be empty"
    end
    
    local colorStr = tostring(color)
    
    -- Check hex color format
    if colorStr:match("^#[%da-fA-F]+$") then
        local hex = colorStr:sub(2)
        if #hex == 6 or #hex == 3 then
            return true, colorStr, nil
        else
            return false, nil, "Invalid hex color format"
        end
    end
    
    -- Check RGB format
    local r, g, b = colorStr:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
    if r and g and b then
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r <= 255 and g <= 255 and b <= 255 then
            return true, colorStr, nil
        else
            return false, nil, "RGB values must be 0-255"
        end
    end
    
    -- Check named colors
    local validColors = {
        "red", "green", "blue", "white", "black", "yellow", "cyan", "magenta",
        "orange", "purple", "pink", "brown", "gray", "grey", "amber", "lime"
    }
    
    local lowerColor = colorStr:lower()
    for _, validColor in ipairs(validColors) do
        if lowerColor == validColor then
            return true, colorStr, nil
        end
    end
    
    return false, nil, "Invalid color format"
end

---Validate position values (pan/tilt in degrees)
---@param pan any Pan value to validate
---@param tilt any Tilt value to validate
---@return boolean valid True if positions are valid
---@return number|nil panConverted Converted pan value
---@return number|nil tiltConverted Converted tilt value
---@return string|nil error Error message if invalid
---@usage
--- local valid, pan, tilt, error = DataValidation.ValidatePosition(45, -30)
function DataValidation.ValidatePosition(pan, tilt)
    local panValid, panConverted, panError = DataValidation.ValidateProperty(pan, "number", {
        min = -270,
        max = 270,
        required = true
    })
    
    if not panValid then
        return false, nil, nil, "Pan " .. panError
    end
    
    local tiltValid, tiltConverted, tiltError = DataValidation.ValidateProperty(tilt, "number", {
        min = -135,
        max = 135,
        required = true
    })
    
    if not tiltValid then
        return false, nil, nil, "Tilt " .. tiltError
    end
    
    return true, panConverted, tiltConverted, nil
end

-- ========================================
-- COLLECTION VALIDATION
-- ========================================

---Validate array of objects
---@param objects table Array of object handles
---@param expectedType? string Optional expected object type
---@return boolean valid True if all objects are valid
---@return table invalid Array of invalid object indices and errors
---@usage
--- local valid, invalid = DataValidation.ValidateObjectArray(fixtures, "Fixture")
function DataValidation.ValidateObjectArray(objects, expectedType)
    if type(objects) ~= "table" then
        return false, {{index = 0, error = "Objects must be provided as an array"}}
    end
    
    local invalid = {}
    
    for i, object in ipairs(objects) do
        local valid, error
        
        if expectedType then
            valid, error = DataValidation.ValidateObjectType(object, expectedType)
        else
            valid, error = DataValidation.ValidateObject(object)
        end
        
        if not valid then
            table.insert(invalid, {index = i, error = error})
        end
    end
    
    return #invalid == 0, invalid
end

---Validate property values across multiple objects
---@param objects table Array of object handles
---@param propertyName string Property name to validate
---@param dataType string Expected data type
---@param constraints? table Optional validation constraints
---@return boolean valid True if all properties are valid
---@return table invalid Array of invalid entries with object index and error
---@usage
--- local valid, invalid = DataValidation.ValidatePropertyAcrossObjects(fixtures, "intensity", "number", {min = 0, max = 100})
function DataValidation.ValidatePropertyAcrossObjects(objects, propertyName, dataType, constraints)
    local invalid = {}
    
    for i, object in ipairs(objects) do
        local objectValid, objectError = DataValidation.ValidateObject(object)
        if not objectValid then
            table.insert(invalid, {index = i, error = "Invalid object: " .. objectError})
        else
            local value = object:Get(propertyName)
            local propValid, _, propError = DataValidation.ValidateProperty(value, dataType, constraints)
            if not propValid then
                table.insert(invalid, {
                    index = i,
                    error = "Property '" .. propertyName .. "': " .. propError
                })
            end
        end
    end
    
    return #invalid == 0, invalid
end

-- ========================================
-- RANGE AND FORMAT VALIDATION
-- ========================================

---Validate numeric range specification
---@param rangeStr string Range string (e.g., "1", "1 Thru 10", "1 + 2 + 5")
---@param minValue? number Optional minimum allowed value
---@param maxValue? number Optional maximum allowed value
---@return boolean valid True if range is valid
---@return table|nil parsed Parsed range data
---@return string|nil error Error message if invalid
---@usage
--- local valid, parsed, error = DataValidation.ValidateRange("1 Thru 10", 1, 100)
function DataValidation.ValidateRange(rangeStr, minValue, maxValue)
    if not rangeStr or rangeStr == "" then
        return false, nil, "Range cannot be empty"
    end
    
    local trimmed = rangeStr:match("^%s*(.-)%s*$")
    minValue = minValue or 1
    maxValue = maxValue or 9999
    
    -- Single number
    if trimmed:match("^%d+$") then
        local num = tonumber(trimmed)
        if num < minValue or num > maxValue then
            return false, nil, "Number must be between " .. minValue .. " and " .. maxValue
        end
        return true, {type = "single", value = num}, nil
    end
    
    -- Range (e.g., "1 Thru 10")
    local startNum, endNum = trimmed:match("^(%d+)%s+[Tt]hru%s+(%d+)$")
    if startNum and endNum then
        local start, endVal = tonumber(startNum), tonumber(endNum)
        if start >= endVal then
            return false, nil, "Range start must be less than end"
        end
        if start < minValue or endVal > maxValue then
            return false, nil, "Range values must be between " .. minValue .. " and " .. maxValue
        end
        return true, {type = "range", start = start, end = endVal}, nil
    end
    
    -- Multi-selection (e.g., "1 + 2 + 5")
    if trimmed:match("^%d+(%s*%+%s*%d+)+$") then
        local numbers = {}
        for numStr in trimmed:gmatch("%d+") do
            local num = tonumber(numStr)
            if num < minValue or num > maxValue then
                return false, nil, "Selection numbers must be between " .. minValue .. " and " .. maxValue
            end
            table.insert(numbers, num)
        end
        return true, {type = "multi", values = numbers}, nil
    end
    
    return false, nil, "Invalid range format"
end

---Validate time format (seconds, frames, or MM:SS format)
---@param timeStr string Time string to validate
---@return boolean valid True if time format is valid
---@return number|nil seconds Converted time in seconds
---@return string|nil error Error message if invalid
---@usage
--- local valid, seconds, error = DataValidation.ValidateTime("3.5")
--- local valid2, seconds2, error2 = DataValidation.ValidateTime("1:30")
function DataValidation.ValidateTime(timeStr)
    if not timeStr or timeStr == "" then
        return false, nil, "Time value cannot be empty"
    end
    
    local trimmed = timeStr:match("^%s*(.-)%s*$")
    
    -- MM:SS format
    local minutes, seconds = trimmed:match("^(%d+):(%d+)$")
    if minutes and seconds then
        local totalSeconds = tonumber(minutes) * 60 + tonumber(seconds)
        if totalSeconds < 0 then
            return false, nil, "Time cannot be negative"
        end
        return true, totalSeconds, nil
    end
    
    -- Decimal seconds
    local numSeconds = tonumber(trimmed)
    if numSeconds then
        if numSeconds < 0 then
            return false, nil, "Time cannot be negative"
        end
        return true, numSeconds, nil
    end
    
    return false, nil, "Invalid time format (use seconds or MM:SS)"
end

-- ========================================
-- COMPREHENSIVE VALIDATION FUNCTIONS
-- ========================================

---Validate complete fixture data structure
---@param fixtureData table Fixture data to validate
---@return boolean valid True if fixture data is valid
---@return table errors Array of validation errors
---@usage
--- local fixtureData = {
---     id = 1,
---     name = "Moving Light 1",
---     intensity = 75,
---     color = "Red",
---     position = {pan = 45, tilt = -30}
--- }
--- local valid, errors = DataValidation.ValidateFixtureData(fixtureData)
function DataValidation.ValidateFixtureData(fixtureData)
    local errors = {}
    
    if type(fixtureData) ~= "table" then
        table.insert(errors, "Fixture data must be a table")
        return false, errors
    end
    
    -- Validate ID
    if fixtureData.id then
        local valid, _, error = DataValidation.ValidateProperty(fixtureData.id, "number", {
            min = 1,
            max = 9999,
            required = true
        })
        if not valid then
            table.insert(errors, "ID: " .. error)
        end
    end
    
    -- Validate name
    if fixtureData.name then
        local valid, _, error = DataValidation.ValidateProperty(fixtureData.name, "string", {
            minLength = 1,
            maxLength = 50
        })
        if not valid then
            table.insert(errors, "Name: " .. error)
        end
    end
    
    -- Validate intensity
    if fixtureData.intensity then
        local valid, _, error = DataValidation.ValidateIntensity(fixtureData.intensity)
        if not valid then
            table.insert(errors, "Intensity: " .. error)
        end
    end
    
    -- Validate color
    if fixtureData.color then
        local valid, _, error = DataValidation.ValidateColor(fixtureData.color)
        if not valid then
            table.insert(errors, "Color: " .. error)
        end
    end
    
    -- Validate position
    if fixtureData.position then
        if type(fixtureData.position) ~= "table" then
            table.insert(errors, "Position must be a table with pan and tilt")
        else
            local valid, _, _, error = DataValidation.ValidatePosition(
                fixtureData.position.pan,
                fixtureData.position.tilt
            )
            if not valid then
                table.insert(errors, "Position: " .. error)
            end
        end
    end
    
    return #errors == 0, errors
end

---Validate batch operation data
---@param batchData table Batch operation data
---@param requiredFields table Array of required field names
---@return boolean valid True if batch data is valid
---@return table errors Array of validation errors per item
---@usage
--- local batchData = {
---     {fixture = "1", intensity = 75},
---     {fixture = "2", intensity = 100}
--- }
--- local valid, errors = DataValidation.ValidateBatchData(batchData, {"fixture", "intensity"})
function DataValidation.ValidateBatchData(batchData, requiredFields)
    if type(batchData) ~= "table" then
        return false, {{"Batch data must be an array"}}
    end
    
    if #batchData == 0 then
        return false, {{"Batch data cannot be empty"}}
    end
    
    local allErrors = {}
    
    for i, item in ipairs(batchData) do
        local itemErrors = {}
        
        if type(item) ~= "table" then
            table.insert(itemErrors, "Item must be a table")
        else
            -- Check required fields
            for _, field in ipairs(requiredFields) do
                if not item[field] then
                    table.insert(itemErrors, "Missing required field: " .. field)
                end
            end
        end
        
        allErrors[i] = itemErrors
    end
    
    -- Check if any items have errors
    local hasErrors = false
    for _, itemErrors in pairs(allErrors) do
        if #itemErrors > 0 then
            hasErrors = true
            break
        end
    end
    
    return not hasErrors, allErrors
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Simple Object Validation:
   local valid, error = DataValidation.ValidateObject(fixture)
   if not valid then
       Printf("Cannot proceed: " .. error)
       return
   end

2. Type-Safe Property Access:
   local valid, intensity, error = DataValidation.ValidateIntensity(userInput)
   if valid then
       fixture:Set("intensity", intensity)
   else
       ShowInputError(error)
   end

3. Batch Object Validation:
   local valid, invalid = DataValidation.ValidateObjectArray(selectedFixtures, "Fixture")
   if not valid then
       Printf("Invalid fixtures found:")
       for _, item in ipairs(invalid) do
           Printf("  Index " .. item.index .. ": " .. item.error)
       end
   end

4. Form Input Validation:
   local function validateForm(formData)
       local errors = {}
       
       local intensityValid, _, intensityError = DataValidation.ValidateIntensity(formData.intensity)
       if not intensityValid then
           errors.intensity = intensityError
       end
       
       local colorValid, _, colorError = DataValidation.ValidateColor(formData.color)
       if not colorValid then
           errors.color = colorError
       end
       
       return #errors == 0, errors
   end

5. Range Validation for User Input:
   local valid, parsed, error = DataValidation.ValidateRange(userInput, 1, 100)
   if valid then
       if parsed.type == "single" then
           processFixture(parsed.value)
       elseif parsed.type == "range" then
           processFixtureRange(parsed.start, parsed.end)
       end
   end

6. Comprehensive Data Structure Validation:
   local cueData = {
       name = "Main Look",
       fade = 3.5,
       fixtures = {
           {id = 1, intensity = 75, color = "Red"},
           {id = 2, intensity = 100, color = "Blue"}
       }
   }
   
   local valid, errors = DataValidation.ValidateFixtureData(cueData.fixtures[1])
   if not valid then
       Printf("Fixture data errors:")
       for _, error in ipairs(errors) do
           Printf("  " .. error)
       end
   end

INTEGRATION PATTERNS:
- Use with data access functions for safe property retrieval
- Combine with command building for parameter validation
- Integrate with UI forms for real-time validation feedback
- Connect with error handling systems for robust data processing

PERFORMANCE CONSIDERATIONS:
- Cache validation results for repeated operations
- Use appropriate validation levels based on data sensitivity
- Validate early to prevent cascading errors
- Batch validate multiple items for efficiency

ERROR HANDLING BEST PRACTICES:
- Provide specific, actionable error messages
- Validate at input boundaries (user interface, API calls)
- Handle edge cases gracefully (null, empty, malformed data)
- Log validation failures for debugging and monitoring
]]

return DataValidation