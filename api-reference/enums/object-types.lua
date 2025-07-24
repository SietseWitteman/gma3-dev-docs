---@meta
--- Object Types Enumerations
--- Categories and types of MA3 objects (fixtures, groups, cues, etc.)
--- 
--- These enumerations define the various object types available in the MA3 system
--- and are used for object identification, classification, and type-specific operations.

---@class ObjectTypeEnums
local ObjectTypeEnums = {}

-- ========================================
-- ASSIGNMENT AND OBJECT TYPES
-- ========================================

---@enum AssignType
--- Types of objects that can be assigned to buttons and controls
ObjectTypeEnums.AssignType = {
    ["FixtureType Presets"] = 0,
    Group = 1,
    Preset = 2,
    Sequence = 3,
    Cue = 4,
    Page = 5,
    Macro = 6,
    Plugin = 7,
    User = 8,
    World = 9,
    ScreenConfig = 10,
    View = 11,
    SoundFile = 12
}

---@enum ClassType
--- MA3 object class types for type identification
ObjectTypeEnums.ClassType = {
    Fixture = "Fixture",
    Group = "Group", 
    Preset = "Preset",
    Cue = "Cue",
    Sequence = "Sequence",
    Page = "Page",
    Macro = "Macro",
    Plugin = "Plugin",
    User = "User",
    World = "World",
    View = "View"
}

---@enum ArrangementMarcType
--- Types of arrangement markers for object organization
ObjectTypeEnums.ArrangementMarcType = {
    Divider = 0,
    Group = 1,
    Single = 2
}

---@enum AxisGroupType
--- Types of axis groups for fixture positioning
ObjectTypeEnums.AxisGroupType = {
    Position = 0,
    Color = 1,
    Beam = 2,
    Control = 3
}

---@enum BeamType
--- Types of beam characteristics for fixtures
ObjectTypeEnums.BeamType = {
    Wash = 0,
    Spot = 1,
    Beam = 2,
    None = 3
}

---@enum BuildType
--- Types of build operations for object construction
ObjectTypeEnums.BuildType = {
    Normal = 0,
    Global = 1,
    Universal = 2
}

-- ========================================
-- FIXTURE AND DEVICE TYPES
-- ========================================

---@enum FixtureType
--- Categories of lighting fixtures
ObjectTypeEnums.FixtureType = {
    Generic = 0,
    MovingLight = 1,
    LEDFixture = 2,
    Conventional = 3,
    Dimmer = 4,
    Media = 5,
    Pyro = 6,
    Smoke = 7,
    MultiInstance = 8
}

---@enum ChannelFunction
--- Types of fixture channel functions
ObjectTypeEnums.ChannelFunction = {
    Dimmer = 0,
    Pan = 1,
    Tilt = 2,
    ColorMixR = 3,
    ColorMixG = 4,
    ColorMixB = 5,
    ColorMixC = 6,
    ColorMixM = 7,
    ColorMixY = 8,
    ColorWheel = 9,
    Gobo = 10,
    Zoom = 11,
    Focus = 12,
    Iris = 13,
    Frost = 14,
    Prism = 15,
    Speed = 16,
    Control = 17
}

---@enum DmxMode
--- DMX addressing and patching modes
ObjectTypeEnums.DmxMode = {
    Single = 0,
    Multi = 1,
    Clone = 2
}

-- ========================================
-- SELECTION AND FILTER TYPES
-- ========================================

---@enum SelectionType
--- Types of object selection operations
ObjectTypeEnums.SelectionType = {
    Replace = 0,
    Add = 1,
    Remove = 2,
    Toggle = 3
}

---@enum FilterType
--- Types of object filters for selection and display
ObjectTypeEnums.FilterType = {
    All = 0,
    Active = 1,
    Selected = 2,
    Modified = 3,
    Parked = 4
}

---@enum SortType
--- Types of object sorting methods
ObjectTypeEnums.SortType = {
    Number = 0,
    Name = 1,
    Type = 2,
    Modified = 3,
    Created = 4
}

-- ========================================
-- STORAGE AND REFERENCE TYPES
-- ========================================

---@enum StorageType
--- Types of object storage operations
ObjectTypeEnums.StorageType = {
    Overwrite = 0,
    Merge = 1,
    Remove = 2,
    Selective = 3
}

---@enum ReferenceType
--- Types of object references and dependencies
ObjectTypeEnums.ReferenceType = {
    Direct = 0,
    Indirect = 1,
    Inherited = 2,
    Global = 3
}

---@enum LinkType
--- Types of object linking relationships
ObjectTypeEnums.LinkType = {
    None = 0,
    Master = 1,
    Slave = 2,
    Peer = 3
}

-- ========================================
-- USAGE EXAMPLES
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Object Type Checking:
   local obj = Obj()
   if obj and obj:GetClass() == ObjectTypeEnums.ClassType.Fixture then
       -- Handle fixture-specific operations
   end

2. Assignment Type Validation:
   local function canAssignToButton(objectType)
       for _, validType in pairs(ObjectTypeEnums.AssignType) do
           if validType == objectType then
               return true
           end
       end
       return false
   end

3. Selection Type Operations:
   local function selectObjects(objects, selectionType)
       local typeValue = ObjectTypeEnums.SelectionType[selectionType]
       if typeValue == ObjectTypeEnums.SelectionType.Replace then
           -- Replace current selection
       elseif typeValue == ObjectTypeEnums.SelectionType.Add then
           -- Add to current selection
       end
   end

4. Fixture Type Classification:
   local function getFixtureCategory(fixtureType)
       if fixtureType == ObjectTypeEnums.FixtureType.MovingLight then
           return "Intelligent Lighting"
       elseif fixtureType == ObjectTypeEnums.FixtureType.Conventional then
           return "Conventional Lighting"
       end
       return "Other"
   end

5. Storage Operation Control:
   local function storeObject(obj, storageType)
       local operation = ObjectTypeEnums.StorageType[storageType]
       if operation == ObjectTypeEnums.StorageType.Overwrite then
           -- Overwrite existing data
       elseif operation == ObjectTypeEnums.StorageType.Merge then
           -- Merge with existing data
       end
   end

CROSS-REFERENCES TO HANDLE METHODS:
- Use with Handle:GetClass() to identify object types
- Apply in selection operations with object filtering
- Reference in assignment operations for UI elements
- Utilize in storage operations for data management

INTEGRATION WITH COMMAND API:
- Object types determine valid command syntax
- Selection types affect command target resolution
- Storage types influence command behavior and results
]]

return ObjectTypeEnums