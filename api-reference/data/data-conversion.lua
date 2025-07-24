---@meta
--- Data Conversion API Reference
--- Type conversion, format transformation, and data serialization utilities for MA3
--- 
--- This module provides comprehensive utilities for converting between different
--- data formats, types, and representations commonly used in MA3 lighting console operations.

---@class DataConversion
local DataConversion = {}

-- ========================================
-- BASIC TYPE CONVERSIONS
-- ========================================

---Convert value to number with validation and default
---@param value any Value to convert
---@param defaultValue? number Default value if conversion fails
---@return number result Converted number or default
---@usage
--- local intensity = DataConversion.ToNumber(userInput, 0)
--- local fadeTime = DataConversion.ToNumber(formData.fade, 3.0)
function DataConversion.ToNumber(value, defaultValue)
    defaultValue = defaultValue or 0
    
    if type(value) == "number" then
        return value
    elseif type(value) == "string" then
        local num = tonumber(value)
        return num or defaultValue
    elseif type(value) == "boolean" then
        return value and 1 or 0
    else
        return defaultValue
    end
end

---Convert value to string with formatting options
---@param value any Value to convert
---@param format? string Format specification ("%.2f" for numbers, etc.)
---@return string result Converted string
---@usage
--- local text = DataConversion.ToString(75)          -- "75"
--- local text2 = DataConversion.ToString(75.456, "%.2f") -- "75.46"
function DataConversion.ToString(value, format)
    if type(value) == "string" then
        return value
    elseif type(value) == "number" and format then
        return string.format(format, value)
    else
        return tostring(value)
    end
end

---Convert value to boolean with flexible interpretation
---@param value any Value to convert
---@param defaultValue? boolean Default value if conversion is ambiguous
---@return boolean result Converted boolean
---@usage
--- local enabled = DataConversion.ToBoolean("true")     -- true
--- local active = DataConversion.ToBoolean("1")        -- true
--- local visible = DataConversion.ToBoolean("off")     -- false
function DataConversion.ToBoolean(value, defaultValue)
    defaultValue = defaultValue or false
    
    if type(value) == "boolean" then
        return value
    elseif type(value) == "number" then
        return value ~= 0
    elseif type(value) == "string" then
        local lower = value:lower()
        if lower == "true" or lower == "yes" or lower == "on" or lower == "1" then
            return true
        elseif lower == "false" or lower == "no" or lower == "off" or lower == "0" then
            return false
        else
            return defaultValue
        end
    else
        return defaultValue
    end
end

-- ========================================
-- INTENSITY CONVERSIONS
-- ========================================

---Convert intensity between different formats
---@param intensity number Intensity value to convert
---@param fromFormat string Source format ("percent", "decimal", "dmx", "16bit")
---@param toFormat string Target format ("percent", "decimal", "dmx", "16bit")
---@return number converted Converted intensity value
---@usage
--- local dmx = DataConversion.ConvertIntensity(75, "percent", "dmx")      -- 191
--- local percent = DataConversion.ConvertIntensity(191, "dmx", "percent") -- 75
function DataConversion.ConvertIntensity(intensity, fromFormat, toFormat)
    -- First convert to decimal (0-1) as common base
    local decimal
    
    if fromFormat == "percent" then
        decimal = intensity / 100
    elseif fromFormat == "decimal" then
        decimal = intensity
    elseif fromFormat == "dmx" then
        decimal = intensity / 255
    elseif fromFormat == "16bit" then
        decimal = intensity / 65535
    else
        decimal = intensity -- assume decimal
    end
    
    -- Clamp to valid range
    decimal = math.max(0, math.min(1, decimal))
    
    -- Convert from decimal to target format
    if toFormat == "percent" then
        return decimal * 100
    elseif toFormat == "decimal" then
        return decimal
    elseif toFormat == "dmx" then
        return math.floor(decimal * 255 + 0.5)
    elseif toFormat == "16bit" then
        return math.floor(decimal * 65535 + 0.5)
    else
        return decimal
    end
end

---Convert intensity with precision control
---@param intensity number Intensity value
---@param precision integer Number of decimal places
---@return number rounded Rounded intensity value
---@usage
--- local rounded = DataConversion.RoundIntensity(75.6789, 1) -- 75.7
function DataConversion.RoundIntensity(intensity, precision)
    precision = precision or 0
    local multiplier = 10 ^ precision
    return math.floor(intensity * multiplier + 0.5) / multiplier
end

-- ========================================
-- COLOR CONVERSIONS
-- ========================================

---Convert color between different formats
---@param color string|table Color value in various formats
---@param targetFormat string Target format ("hex", "rgb", "hsl", "name")
---@return string|table|nil converted Converted color or nil if invalid
---@usage
--- local hex = DataConversion.ConvertColor("Red", "hex")           -- "#FF0000"
--- local rgb = DataConversion.ConvertColor("#FF0000", "rgb")       -- {r=255, g=0, b=0}
--- local name = DataConversion.ConvertColor({r=255, g=0, b=0}, "name") -- "Red"
function DataConversion.ConvertColor(color, targetFormat)
    -- Parse input color to RGB values
    local r, g, b = DataConversion.ParseColorToRGB(color)
    if not r then
        return nil
    end
    
    if targetFormat == "rgb" then
        return {r = r, g = g, b = b}
    elseif targetFormat == "hex" then
        return string.format("#%02X%02X%02X", r, g, b)
    elseif targetFormat == "hsl" then
        return DataConversion.RGBToHSL(r, g, b)
    elseif targetFormat == "name" then
        return DataConversion.RGBToColorName(r, g, b)
    else
        return {r = r, g = g, b = b}
    end
end

---Parse various color formats to RGB values
---@param color string|table Color in any supported format
---@return number|nil r Red component (0-255)
---@return number|nil g Green component (0-255) 
---@return number|nil b Blue component (0-255)
---@usage
--- local r, g, b = DataConversion.ParseColorToRGB("Red")      -- 255, 0, 0
--- local r2, g2, b2 = DataConversion.ParseColorToRGB("#FF0000") -- 255, 0, 0
function DataConversion.ParseColorToRGB(color)
    if type(color) == "table" and color.r and color.g and color.b then
        return color.r, color.g, color.b
    elseif type(color) == "string" then
        -- Hex format
        if color:match("^#[%da-fA-F]+$") then
            local hex = color:sub(2)
            if #hex == 6 then
                local r = tonumber(hex:sub(1, 2), 16)
                local g = tonumber(hex:sub(3, 4), 16)
                local b = tonumber(hex:sub(5, 6), 16)
                return r, g, b
            elseif #hex == 3 then
                local r = tonumber(hex:sub(1, 1), 16) * 17
                local g = tonumber(hex:sub(2, 2), 16) * 17
                local b = tonumber(hex:sub(3, 3), 16) * 17
                return r, g, b
            end
        end
        
        -- RGB format (r,g,b)
        local r, g, b = color:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
        if r and g and b then
            return tonumber(r), tonumber(g), tonumber(b)
        end
        
        -- Named color
        local namedColors = {
            ["red"] = {255, 0, 0},
            ["green"] = {0, 255, 0},
            ["blue"] = {0, 0, 255},
            ["white"] = {255, 255, 255},
            ["black"] = {0, 0, 0},
            ["yellow"] = {255, 255, 0},
            ["cyan"] = {0, 255, 255},
            ["magenta"] = {255, 0, 255},
            ["orange"] = {255, 165, 0},
            ["purple"] = {128, 0, 128},
            ["pink"] = {255, 192, 203},
            ["brown"] = {165, 42, 42},
            ["gray"] = {128, 128, 128},
            ["grey"] = {128, 128, 128},
            ["amber"] = {255, 191, 0},
            ["lime"] = {0, 255, 0}
        }
        
        local lowerColor = color:lower()
        if namedColors[lowerColor] then
            local rgb = namedColors[lowerColor]
            return rgb[1], rgb[2], rgb[3]
        end
    end
    
    return nil, nil, nil
end

---Convert RGB to HSL color space
---@param r number Red component (0-255)
---@param g number Green component (0-255)
---@param b number Blue component (0-255)
---@return table hsl HSL color {h=0-360, s=0-100, l=0-100}
---@usage
--- local hsl = DataConversion.RGBToHSL(255, 0, 0) -- Red to HSL
function DataConversion.RGBToHSL(r, g, b)
    r, g, b = r/255, g/255, b/255
    
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, l = 0, 0, (max + min) / 2
    
    if max == min then
        h, s = 0, 0 -- achromatic
    else
        local d = max - min
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)
        
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    
    return {
        h = math.floor(h * 360 + 0.5),
        s = math.floor(s * 100 + 0.5),
        l = math.floor(l * 100 + 0.5)
    }
end

---Convert RGB values to closest color name
---@param r number Red component (0-255)
---@param g number Green component (0-255)
---@param b number Blue component (0-255)
---@return string name Closest color name
---@usage
--- local name = DataConversion.RGBToColorName(255, 0, 0) -- "Red"
function DataConversion.RGBToColorName(r, g, b)
    local namedColors = {
        {name = "Red", r = 255, g = 0, b = 0},
        {name = "Green", r = 0, g = 255, b = 0},
        {name = "Blue", r = 0, g = 0, b = 255},
        {name = "White", r = 255, g = 255, b = 255},
        {name = "Black", r = 0, g = 0, b = 0},
        {name = "Yellow", r = 255, g = 255, b = 0},
        {name = "Cyan", r = 0, g = 255, b = 255},
        {name = "Magenta", r = 255, g = 0, b = 255},
        {name = "Orange", r = 255, g = 165, b = 0},
        {name = "Purple", r = 128, g = 0, b = 128},
        {name = "Pink", r = 255, g = 192, b = 203},
        {name = "Brown", r = 165, g = 42, b = 42},
        {name = "Gray", r = 128, g = 128, b = 128},
        {name = "Amber", r = 255, g = 191, b = 0}
    }
    
    local minDistance = math.huge
    local closestName = "Unknown"
    
    for _, color in ipairs(namedColors) do
        local distance = math.sqrt(
            (r - color.r)^2 + (g - color.g)^2 + (b - color.b)^2
        )
        if distance < minDistance then
            minDistance = distance
            closestName = color.name
        end
    end
    
    return closestName
end

-- ========================================
-- POSITION CONVERSIONS
-- ========================================

---Convert position between different coordinate systems
---@param pan number Pan value
---@param tilt number Tilt value
---@param fromSystem string Source system ("degrees", "percent", "dmx", "16bit")
---@param toSystem string Target system ("degrees", "percent", "dmx", "16bit")
---@return number panConverted Converted pan value
---@return number tiltConverted Converted tilt value
---@usage
--- local panDmx, tiltDmx = DataConversion.ConvertPosition(45, -30, "degrees", "dmx")
function DataConversion.ConvertPosition(pan, tilt, fromSystem, toSystem)
    -- Convert to normalized values (-1 to 1) as common base
    local panNorm, tiltNorm
    
    if fromSystem == "degrees" then
        panNorm = pan / 270    -- Assume ±270° range
        tiltNorm = tilt / 135  -- Assume ±135° range
    elseif fromSystem == "percent" then
        panNorm = (pan - 50) / 50     -- 0-100% to -1 to 1
        tiltNorm = (tilt - 50) / 50   -- 0-100% to -1 to 1
    elseif fromSystem == "dmx" then
        panNorm = (pan - 127.5) / 127.5   -- 0-255 to -1 to 1
        tiltNorm = (tilt - 127.5) / 127.5 -- 0-255 to -1 to 1
    elseif fromSystem == "16bit" then
        panNorm = (pan - 32767.5) / 32767.5   -- 0-65535 to -1 to 1
        tiltNorm = (tilt - 32767.5) / 32767.5 -- 0-65535 to -1 to 1
    else
        panNorm, tiltNorm = pan, tilt
    end
    
    -- Clamp to valid range
    panNorm = math.max(-1, math.min(1, panNorm))
    tiltNorm = math.max(-1, math.min(1, tiltNorm))
    
    -- Convert to target system
    if toSystem == "degrees" then
        return panNorm * 270, tiltNorm * 135
    elseif toSystem == "percent" then
        return panNorm * 50 + 50, tiltNorm * 50 + 50
    elseif toSystem == "dmx" then
        return math.floor(panNorm * 127.5 + 127.5 + 0.5), 
               math.floor(tiltNorm * 127.5 + 127.5 + 0.5)
    elseif toSystem == "16bit" then
        return math.floor(panNorm * 32767.5 + 32767.5 + 0.5),
               math.floor(tiltNorm * 32767.5 + 32767.5 + 0.5)
    else
        return panNorm, tiltNorm
    end
end

-- ========================================
-- TIME CONVERSIONS
-- ========================================

---Convert time between different formats
---@param time number Time value
---@param fromFormat string Source format ("seconds", "frames", "timecode", "beats")
---@param toFormat string Target format ("seconds", "frames", "timecode", "beats")
---@param frameRate? number Frame rate for frame conversions (default 25fps)
---@param bpm? number BPM for beat conversions (default 120bpm)
---@return number|string converted Converted time value
---@usage
--- local frames = DataConversion.ConvertTime(3.5, "seconds", "frames", 25) -- 87.5
--- local timecode = DataConversion.ConvertTime(125.5, "seconds", "timecode") -- "2:05.5"
function DataConversion.ConvertTime(time, fromFormat, toFormat, frameRate, bpm)
    frameRate = frameRate or 25
    bpm = bpm or 120
    
    -- Convert to seconds as common base
    local seconds
    
    if fromFormat == "seconds" then
        seconds = time
    elseif fromFormat == "frames" then
        seconds = time / frameRate
    elseif fromFormat == "timecode" then
        -- Parse MM:SS.FF or HH:MM:SS.FF format
        if type(time) == "string" then
            local h, m, s, f = time:match("^(%d+):(%d+):(%d+)%.(%d+)$")
            if h then
                seconds = tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s) + tonumber(f) / 100
            else
                local m2, s2, f2 = time:match("^(%d+):(%d+)%.(%d+)$")
                if m2 then
                    seconds = tonumber(m2) * 60 + tonumber(s2) + tonumber(f2) / 100
                else
                    seconds = tonumber(time) or 0
                end
            end
        else
            seconds = time
        end
    elseif fromFormat == "beats" then
        seconds = time * 60 / bpm
    else
        seconds = time
    end
    
    -- Convert from seconds to target format
    if toFormat == "seconds" then
        return seconds
    elseif toFormat == "frames" then
        return seconds * frameRate
    elseif toFormat == "timecode" then
        local hours = math.floor(seconds / 3600)
        local minutes = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        
        if hours > 0 then
            return string.format("%d:%02d:%05.2f", hours, minutes, secs)
        else
            return string.format("%d:%05.2f", minutes, secs)
        end
    elseif toFormat == "beats" then
        return seconds * bpm / 60
    else
        return seconds
    end
end

-- ========================================
-- DATA STRUCTURE CONVERSIONS
-- ========================================

---Convert flat table to nested structure
---@param flatTable table Flat table with dot-notation keys
---@return table nested Nested table structure
---@usage
--- local flat = {"fixture.1.intensity" = 75, "fixture.1.color" = "Red"}
--- local nested = DataConversion.FlattenToNested(flat)
--- -- Result: {fixture = {["1"] = {intensity = 75, color = "Red"}}}
function DataConversion.FlattenToNested(flatTable)
    local nested = {}
    
    for key, value in pairs(flatTable) do
        local parts = {}
        for part in key:gmatch("[^%.]+") do
            table.insert(parts, part)
        end
        
        local current = nested
        for i = 1, #parts - 1 do
            local part = parts[i]
            if not current[part] then
                current[part] = {}
            end
            current = current[part]
        end
        
        current[parts[#parts]] = value
    end
    
    return nested
end

---Convert nested table to flat structure with dot notation
---@param nestedTable table Nested table structure
---@param prefix? string Key prefix for recursion
---@return table flat Flat table with dot-notation keys
---@usage
--- local nested = {fixture = {["1"] = {intensity = 75, color = "Red"}}}
--- local flat = DataConversion.NestedToFlatten(nested)
--- -- Result: {"fixture.1.intensity" = 75, "fixture.1.color" = "Red"}
function DataConversion.NestedToFlatten(nestedTable, prefix)
    prefix = prefix or ""
    local flat = {}
    
    for key, value in pairs(nestedTable) do
        local newKey = prefix == "" and key or prefix .. "." .. key
        
        if type(value) == "table" then
            local subFlat = DataConversion.NestedToFlatten(value, newKey)
            for subKey, subValue in pairs(subFlat) do
                flat[subKey] = subValue
            end
        else
            flat[newKey] = value
        end
    end
    
    return flat
end

---Convert array of objects to lookup table
---@param array table Array of objects
---@param keyField string Field name to use as key
---@return table lookup Lookup table indexed by key field
---@usage
--- local fixtures = {{id = 1, name = "Light1"}, {id = 2, name = "Light2"}}
--- local lookup = DataConversion.ArrayToLookup(fixtures, "id")
--- -- Result: {["1"] = {id = 1, name = "Light1"}, ["2"] = {id = 2, name = "Light2"}}
function DataConversion.ArrayToLookup(array, keyField)
    local lookup = {}
    
    for _, item in ipairs(array) do
        if type(item) == "table" and item[keyField] then
            lookup[tostring(item[keyField])] = item
        end
    end
    
    return lookup
end

-- ========================================
-- SERIALIZATION UTILITIES
-- ========================================

---Serialize table to JSON-like string
---@param data table Data to serialize
---@param compact? boolean Use compact format (default false)
---@return string json JSON representation
---@usage
--- local json = DataConversion.TableToJSON({name = "Test", value = 42})
function DataConversion.TableToJSON(data, compact)
    local function serializeValue(value, indent)
        indent = indent or 0
        local spacing = compact and "" or string.rep("  ", indent)
        local newline = compact and "" or "\n"
        
        if type(value) == "string" then
            return '"' .. value:gsub('"', '\\"') .. '"'
        elseif type(value) == "number" then
            return tostring(value)
        elseif type(value) == "boolean" then
            return tostring(value)
        elseif type(value) == "table" then
            local isArray = true
            local maxIndex = 0
            
            -- Check if it's an array
            for k, _ in pairs(value) do
                if type(k) ~= "number" or k <= 0 or k ~= math.floor(k) then
                    isArray = false
                    break
                end
                maxIndex = math.max(maxIndex, k)
            end
            
            if isArray then
                local parts = {}
                for i = 1, maxIndex do
                    table.insert(parts, serializeValue(value[i], indent + 1))
                end
                return "[" .. table.concat(parts, compact and "," or ", ") .. "]"
            else
                local parts = {}
                for k, v in pairs(value) do
                    local key = type(k) == "string" and k or tostring(k)
                    table.insert(parts, '"' .. key .. '":' .. (compact and "" or " ") .. 
                                serializeValue(v, indent + 1))
                end
                return "{" .. newline .. spacing .. 
                       table.concat(parts, compact and "," or ("," .. newline .. spacing)) .. 
                       newline .. string.rep("  ", math.max(0, indent - 1)) .. "}"
            end
        else
            return "null"
        end
    end
    
    return serializeValue(data)
end

---Parse simple JSON-like string to table
---@param jsonStr string JSON string to parse
---@return table|nil data Parsed data or nil if invalid
---@usage
--- local data = DataConversion.JSONToTable('{"name": "Test", "value": 42}')
function DataConversion.JSONToTable(jsonStr)
    -- Simple JSON parser - for basic cases only
    -- In production, use a proper JSON library
    
    if not jsonStr or jsonStr == "" then
        return nil
    end
    
    -- Remove whitespace
    jsonStr = jsonStr:gsub("%s+", "")
    
    -- Very basic parsing - handles simple objects only
    if jsonStr:match("^{.*}$") then
        local result = {}
        local content = jsonStr:sub(2, -2) -- Remove { }
        
        for pair in content:gmatch('[^,]+') do
            local key, value = pair:match('"([^"]+)":(.+)')
            if key and value then
                if value:match('^".*"$') then
                    -- String value
                    result[key] = value:sub(2, -2)
                elseif value == "true" then
                    result[key] = true
                elseif value == "false" then
                    result[key] = false
                elseif value == "null" then
                    result[key] = nil
                else
                    -- Number value
                    result[key] = tonumber(value)
                end
            end
        end
        
        return result
    end
    
    return nil
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Safe Type Conversion:
   local intensity = DataConversion.ToNumber(userInput, 0)
   local enabled = DataConversion.ToBoolean(formData.enabled, false)
   local name = DataConversion.ToString(objectId, "Unnamed")

2. Intensity Format Conversion:
   local dmxValue = DataConversion.ConvertIntensity(75, "percent", "dmx")
   local rounded = DataConversion.RoundIntensity(75.6789, 1)

3. Color Format Conversion:
   local hex = DataConversion.ConvertColor("Red", "hex")      -- "#FF0000"
   local rgb = DataConversion.ConvertColor("#FF0000", "rgb")  -- {r=255, g=0, b=0}
   local r, g, b = DataConversion.ParseColorToRGB("Blue")    -- 0, 0, 255

4. Position System Conversion:
   local panDmx, tiltDmx = DataConversion.ConvertPosition(45, -30, "degrees", "dmx")
   local panPercent, tiltPercent = DataConversion.ConvertPosition(128, 96, "dmx", "percent")

5. Time Format Conversion:
   local frames = DataConversion.ConvertTime(3.5, "seconds", "frames", 25)
   local timecode = DataConversion.ConvertTime(125.5, "seconds", "timecode")

6. Data Structure Conversion:
   local lookup = DataConversion.ArrayToLookup(fixtures, "id")
   local json = DataConversion.TableToJSON(data, false)
   local parsed = DataConversion.JSONToTable(jsonString)

7. Form Data Processing:
   local function processFormData(formData)
       return {
           intensity = DataConversion.ToNumber(formData.intensity, 0),
           color = DataConversion.ConvertColor(formData.color, "hex"),
           enabled = DataConversion.ToBoolean(formData.enabled, true),
           fadeTime = DataConversion.ConvertTime(formData.fade, "seconds", "seconds")
       }
   end

INTEGRATION PATTERNS:
- Use with validation functions for robust data processing
- Combine with data access functions for format consistency
- Integrate with UI forms for user input processing
- Connect with command building for parameter formatting

PERFORMANCE CONSIDERATIONS:
- Cache conversion results for repeated operations
- Use appropriate precision for numeric conversions
- Consider memory usage for large data structure conversions
- Optimize JSON serialization for large datasets

ERROR HANDLING:
- Always provide sensible default values
- Validate input parameters before conversion
- Handle edge cases (null, empty, malformed data)
- Log conversion failures for debugging
]]

return DataConversion