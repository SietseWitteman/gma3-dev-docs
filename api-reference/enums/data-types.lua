---@meta
--- Data Types Enumerations
--- Property types, value ranges, format types, and validation rules
--- 
--- These enumerations define data types, formats, and validation rules
--- used throughout the MA3 system for property handling and data validation.

---@class DataTypeEnums
local DataTypeEnums = {}

-- ========================================
-- BASIC DATA TYPES
-- ========================================

---@enum PropertyType
--- Basic property data types in MA3
DataTypeEnums.PropertyType = {
    Integer = 1,
    Float = 2,
    String = 3,
    Boolean = 4,
    Handle = 5,
    Enum = 6,
    Array = 7,
    Object = 8
}

---@enum ValueType
--- Value type classifications
DataTypeEnums.ValueType = {
    Numeric = 0,
    Text = 1,
    Boolean = 2,
    Reference = 3,
    Composite = 4,
    Unknown = 5
}

---@enum NumberFormat
--- Numeric value formatting types
DataTypeEnums.NumberFormat = {
    Integer = 0,
    Decimal = 1,
    Percentage = 2,
    Time = 3,
    Angle = 4,
    DMX = 5
}

-- ========================================
-- STRING AND TEXT FORMATS
-- ========================================

---@enum StringFormat
--- String formatting and validation types
DataTypeEnums.StringFormat = {
    Plain = 0,
    Name = 1,
    Path = 2,
    Address = 3,
    Command = 4,
    Expression = 5
}

---@enum TextEncoding
--- Text encoding formats
DataTypeEnums.TextEncoding = {
    ASCII = 0,
    UTF8 = 1,
    UTF16 = 2,
    Latin1 = 3,
    Unicode = 4
}

---@enum CaseFormat
--- Text case formatting options
DataTypeEnums.CaseFormat = {
    None = 0,
    Lower = 1,
    Upper = 2,
    Title = 3,
    Sentence = 4
}

-- ========================================
-- NUMERIC RANGES AND CONSTRAINTS
-- ========================================

---@enum IntensityRange
--- Intensity value ranges and formats
DataTypeEnums.IntensityRange = {
    Percent = 0,      -- 0-100%
    DMX = 1,          -- 0-255
    Decimal = 2,      -- 0.0-1.0
    Raw = 3           -- Raw device values
}

---@enum AngleRange
--- Angle measurement ranges
DataTypeEnums.AngleRange = {
    Degrees = 0,      -- 0-360 degrees
    Radians = 1,      -- 0-2π radians
    Percent = 2,      -- -100% to +100%
    DMX = 3           -- 0-255 DMX
}

---@enum TimeFormat
--- Time value formats and ranges
DataTypeEnums.TimeFormat = {
    Seconds = 0,      -- Decimal seconds
    Frames = 1,       -- Frame count
    SMPTE = 2,        -- HH:MM:SS:FF
    Milliseconds = 3, -- Integer milliseconds
    Beats = 4         -- Musical beats
}

---@enum ColorFormat
--- Color value formats
DataTypeEnums.ColorFormat = {
    RGB = 0,          -- Red, Green, Blue (0-255)
    HSV = 1,          -- Hue, Saturation, Value
    CMY = 2,          -- Cyan, Magenta, Yellow
    RGBW = 3,         -- Red, Green, Blue, White
    HSI = 4,          -- Hue, Saturation, Intensity
    CIE = 5           -- CIE color space
}

-- ========================================
-- VALIDATION TYPES AND RULES
-- ========================================

---@enum ValidationType
--- Input validation rule types
DataTypeEnums.ValidationType = {
    Required = 1,
    Range = 2,
    Format = 3,
    Custom = 4,
    Reference = 5,
    Unique = 6
}

---@enum ValidationResult
--- Validation operation results
DataTypeEnums.ValidationResult = {
    Valid = 0,
    Invalid = 1,
    Warning = 2,
    Error = 3,
    Missing = 4,
    OutOfRange = 5
}

---@enum ConstraintType
--- Data constraint types
DataTypeEnums.ConstraintType = {
    None = 0,
    MinMax = 1,
    List = 2,
    Pattern = 3,
    Reference = 4,
    Function = 5
}

-- ========================================
-- FILE AND STORAGE FORMATS
-- ========================================

---@enum FileFormat
--- Supported file formats
DataTypeEnums.FileFormat = {
    XML = 0,
    JSON = 1,
    CSV = 2,
    Binary = 3,
    Text = 4,
    MA3 = 5
}

---@enum CompressionType
--- Data compression formats
DataTypeEnums.CompressionType = {
    None = 0,
    ZIP = 1,
    GZIP = 2,
    BZIP2 = 3,
    LZ4 = 4,
    Custom = 5
}

---@enum EncodingType
--- Data encoding types
DataTypeEnums.EncodingType = {
    Binary = 0,
    Base64 = 1,
    Hex = 2,
    URL = 3,
    JSON = 4,
    XML = 5
}

-- ========================================
-- PROPERTY ATTRIBUTES
-- ========================================

---@enum PropertyAccess
--- Property access permissions
DataTypeEnums.PropertyAccess = {
    ReadOnly = 0,
    WriteOnly = 1,
    ReadWrite = 2,
    None = 3,
    Special = 4
}

---@enum PropertyScope
--- Property visibility scope
DataTypeEnums.PropertyScope = {
    Public = 0,
    Private = 1,
    Protected = 2,
    Internal = 3,
    System = 4
}

---@enum PropertyState
--- Property state indicators
DataTypeEnums.PropertyState = {
    Default = 0,
    Modified = 1,
    Inherited = 2,
    Overridden = 3,
    Locked = 4,
    Calculated = 5
}

-- ========================================
-- CONVERSION AND TRANSFORMATION
-- ========================================

---@enum ConversionType
--- Data type conversion operations
DataTypeEnums.ConversionType = {
    Implicit = 0,
    Explicit = 1,
    Format = 2,
    Scale = 3,
    Transform = 4,
    Validate = 5
}

---@enum TransformOperation
--- Data transformation operations
DataTypeEnums.TransformOperation = {
    Scale = 0,
    Offset = 1,
    Invert = 2,
    Clamp = 3,
    Round = 4,
    Truncate = 5
}

---@enum ScalingMode
--- Value scaling modes
DataTypeEnums.ScalingMode = {
    Linear = 0,
    Logarithmic = 1,
    Exponential = 2,
    Custom = 3,
    Stepped = 4,
    Curve = 5
}

-- ========================================
-- USAGE EXAMPLES
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Property Type Validation:
   local function validatePropertyType(value, expectedType)
       if expectedType == DataTypeEnums.PropertyType.Integer then
           local num = tonumber(value)
           return num and math.floor(num) == num
       elseif expectedType == DataTypeEnums.PropertyType.Float then
           return tonumber(value) ~= nil
       elseif expectedType == DataTypeEnums.PropertyType.String then
           return type(value) == "string"
       elseif expectedType == DataTypeEnums.PropertyType.Boolean then
           return type(value) == "boolean"
       end
       return false
   end

2. Value Range Checking:
   local function validateIntensity(value, rangeType)
       local num = tonumber(value)
       if not num then return false end
       
       if rangeType == DataTypeEnums.IntensityRange.Percent then
           return num >= 0 and num <= 100
       elseif rangeType == DataTypeEnums.IntensityRange.DMX then
           return num >= 0 and num <= 255
       elseif rangeType == DataTypeEnums.IntensityRange.Decimal then
           return num >= 0.0 and num <= 1.0
       end
       return false
   end

3. Format Conversion:
   local function convertValue(value, fromFormat, toFormat)
       if fromFormat == DataTypeEnums.IntensityRange.Percent and 
          toFormat == DataTypeEnums.IntensityRange.DMX then
           return math.floor((value / 100) * 255)
       elseif fromFormat == DataTypeEnums.IntensityRange.DMX and 
              toFormat == DataTypeEnums.IntensityRange.Percent then
           return (value / 255) * 100
       end
       return value
   end

4. String Format Validation:
   local function validateStringFormat(str, format)
       if format == DataTypeEnums.StringFormat.Name then
           -- Check for valid name characters
           return str:match("^[%w%s_-]+$") ~= nil
       elseif format == DataTypeEnums.StringFormat.Path then
           -- Check for valid path format
           return str:match("^[%w%s/\\._-]+$") ~= nil
       elseif format == DataTypeEnums.StringFormat.Address then
           -- Check for valid address format
           return str:match("^%d+%.?%d*$") ~= nil
       end
       return true
   end

5. Property Access Control:
   local function canModifyProperty(property, accessLevel)
       if property.access == DataTypeEnums.PropertyAccess.ReadOnly then
           return false
       elseif property.access == DataTypeEnums.PropertyAccess.WriteOnly then
           return true
       elseif property.access == DataTypeEnums.PropertyAccess.ReadWrite then
           return true
       end
       return false
   end

6. Data Validation Pipeline:
   local function validateData(data, schema)
       local results = {}
       
       for fieldName, rules in pairs(schema) do
           local value = data[fieldName]
           local result = DataTypeEnums.ValidationResult.Valid
           
           -- Check required fields
           if rules.required and (value == nil or value == "") then
               result = DataTypeEnums.ValidationResult.Missing
           end
           
           -- Check data type
           if value and not validatePropertyType(value, rules.type) then
               result = DataTypeEnums.ValidationResult.Invalid
           end
           
           -- Check range constraints
           if value and rules.range then
               if not validateRange(value, rules.range) then
                   result = DataTypeEnums.ValidationResult.OutOfRange
               end
           end
           
           results[fieldName] = result
       end
       
       return results
   end

INTEGRATION WITH HANDLE METHODS:
- Property types match Handle:Get() return values
- Validation rules apply to Handle property setting
- Format types affect Handle:Export() output
- Range constraints apply to Handle:SetFader() values

CROSS-REFERENCES TO OTHER ENUMS:
- Object types define property schemas
- UI elements use validation for input
- System states affect property access rights
- Command types influence property formats

PERFORMANCE CONSIDERATIONS:
- Cache validation results for repeated checks
- Use appropriate data types for efficiency
- Validate at input boundaries, not everywhere
- Consider validation cost vs. safety trade-offs
]]

return DataTypeEnums