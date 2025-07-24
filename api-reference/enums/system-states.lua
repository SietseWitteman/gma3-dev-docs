---@meta
--- System States Enumerations
--- Connection states, operation modes, status flags, and system conditions
--- 
--- These enumerations define system-level states, operational modes, and
--- status conditions used for monitoring and controlling MA3 system behavior.

---@class SystemStateEnums
local SystemStateEnums = {}

-- ========================================
-- CONNECTION AND NETWORK STATES
-- ========================================

---@enum ConnectionStatus
--- Network and device connection states
SystemStateEnums.ConnectionStatus = {
    Disconnected = 0,
    Connecting = 1,
    Connected = 2,
    Error = 3,
    Timeout = 4,
    Refused = 5
}

---@enum NetworkMode
--- Network operational modes
SystemStateEnums.NetworkMode = {
    Standalone = 0,
    Session = 1,
    Backup = 2,
    NPU = 3,
    Remote = 4
}

---@enum SyncStatus
--- Data synchronization states
SystemStateEnums.SyncStatus = {
    InSync = 0,
    OutOfSync = 1,
    Syncing = 2,
    SyncError = 3,
    NoConnection = 4
}

-- ========================================
-- OPERATIONAL MODES AND STATES
-- ========================================

---@enum OperationMode
--- Console operational modes
SystemStateEnums.OperationMode = {
    Live = 0,
    Blind = 1,
    Preview = 2,
    Backup = 3,
    Programming = 4,
    Playback = 5
}

---@enum PlaybackStatus
--- Playback system states
SystemStateEnums.PlaybackStatus = {
    Stopped = 0,
    Playing = 1,
    Paused = 2,
    Fading = 3,
    Waiting = 4,
    Error = 5
}

---@enum CueStatus
--- Individual cue states
SystemStateEnums.CueStatus = {
    Inactive = 0,
    Active = 1,
    Running = 2,
    Paused = 3,
    Released = 4,
    Killed = 5
}

---@enum SequenceStatus
--- Sequence operational states
SystemStateEnums.SequenceStatus = {
    Off = 0,
    On = 1,
    Paused = 2,
    Halted = 3,
    Assert = 4,
    Manual = 5
}

-- ========================================
-- SYSTEM PERFORMANCE AND HEALTH
-- ========================================

---@enum PerformanceStatus
--- System performance indicators
SystemStateEnums.PerformanceStatus = {
    Normal = 0,
    Warning = 1,
    Critical = 2,
    Error = 3,
    Unknown = 4
}

---@enum ResourceStatus
--- System resource utilization states
SystemStateEnums.ResourceStatus = {
    Low = 0,
    Normal = 1,
    High = 2,
    Critical = 3,
    Exceeded = 4
}

---@enum MemoryStatus
--- Memory usage states
SystemStateEnums.MemoryStatus = {
    Available = 0,
    Low = 1,
    Critical = 2,
    Full = 3,
    Error = 4
}

---@enum ProcessorLoad
--- CPU load levels
SystemStateEnums.ProcessorLoad = {
    Idle = 0,
    Light = 1,
    Moderate = 2,
    Heavy = 3,
    Overloaded = 4
}

-- ========================================
-- ERROR AND WARNING STATES
-- ========================================

---@enum ErrorLevel
--- System error severity levels
SystemStateEnums.ErrorLevel = {
    Info = 0,
    Warning = 1,
    Error = 2,
    Critical = 3,
    Fatal = 4
}

---@enum SystemHealth
--- Overall system health indicators
SystemStateEnums.SystemHealth = {
    Healthy = 0,
    Degraded = 1,
    Warning = 2,
    Critical = 3,
    Failed = 4
}

---@enum DeviceStatus
--- Hardware device states
SystemStateEnums.DeviceStatus = {
    Online = 0,
    Offline = 1,
    Error = 2,
    Maintenance = 3,
    Unknown = 4,
    NotResponding = 5
}

-- ========================================
-- FILE AND DATA STATES
-- ========================================

---@enum FileStatus
--- File operation states
SystemStateEnums.FileStatus = {
    Available = 0,
    NotFound = 1,
    Locked = 2,
    Corrupted = 3,
    ReadOnly = 4,
    AccessDenied = 5
}

---@enum SaveStatus
--- Data save operation states
SystemStateEnums.SaveStatus = {
    Saved = 0,
    Modified = 1,
    Saving = 2,
    Error = 3,
    ReadOnly = 4,
    Conflict = 5
}

---@enum LoadStatus
--- Data load operation states
SystemStateEnums.LoadStatus = {
    Loaded = 0,
    Loading = 1,
    Failed = 2,
    NotFound = 3,
    Corrupted = 4,
    Incompatible = 5
}

-- ========================================
-- USER AND SESSION STATES
-- ========================================

---@enum UserStatus
--- User session states
SystemStateEnums.UserStatus = {
    LoggedIn = 0,
    LoggedOut = 1,
    Idle = 2,
    Active = 3,
    Locked = 4,
    Timeout = 5
}

---@enum SessionStatus
--- Session operational states
SystemStateEnums.SessionStatus = {
    Active = 0,
    Inactive = 1,
    Starting = 2,
    Stopping = 3,
    Error = 4,
    Expired = 5
}

---@enum AccessLevel
--- User access privilege levels
SystemStateEnums.AccessLevel = {
    Guest = 0,
    Operator = 1,
    Programmer = 2,
    Administrator = 3,
    Service = 4,
    System = 5
}

-- ========================================
-- CONSOLE AND HARDWARE STATES
-- ========================================

---@enum ConsoleMode
--- Console operational modes
SystemStateEnums.ConsoleMode = {
    Normal = 0,
    Service = 1,
    Maintenance = 2,
    Emergency = 3,
    Calibration = 4,
    Test = 5
}

---@enum HardwareStatus
--- Hardware component states
SystemStateEnums.HardwareStatus = {
    Operational = 0,
    Warning = 1,
    Error = 2,
    Failed = 3,
    NotInstalled = 4,
    Calibrating = 5
}

---@enum PowerStatus
--- System power states
SystemStateEnums.PowerStatus = {
    Normal = 0,
    Battery = 1,
    LowPower = 2,
    Critical = 3,
    Charging = 4,
    UPS = 5
}

-- ========================================
-- USAGE EXAMPLES
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. System Health Monitoring:
   local function checkSystemHealth()
       local status = {
           connection = SystemStateEnums.ConnectionStatus.Connected,
           performance = SystemStateEnums.PerformanceStatus.Normal,
           memory = SystemStateEnums.MemoryStatus.Available
       }
       
       if status.connection ~= SystemStateEnums.ConnectionStatus.Connected then
           return SystemStateEnums.SystemHealth.Critical
       elseif status.performance == SystemStateEnums.PerformanceStatus.Warning then
           return SystemStateEnums.SystemHealth.Degraded
       end
       
       return SystemStateEnums.SystemHealth.Healthy
   end

2. Playback State Management:
   local function handlePlaybackState(sequence, newState)
       if newState == SystemStateEnums.PlaybackStatus.Playing then
           sequence:Start()
       elseif newState == SystemStateEnums.PlaybackStatus.Paused then
           sequence:Pause()
       elseif newState == SystemStateEnums.PlaybackStatus.Stopped then
           sequence:Stop()
       end
   end

3. Error Level Processing:
   local function logSystemEvent(message, level)
       if level >= SystemStateEnums.ErrorLevel.Error then
           -- Critical logging
           Printf("ERROR: " .. message)
       elseif level == SystemStateEnums.ErrorLevel.Warning then
           -- Warning logging
           Printf("WARNING: " .. message)
       else
           -- Info logging
           Printf("INFO: " .. message)
       end
   end

4. Resource Monitoring:
   local function monitorResources()
       local memoryState = getMemoryStatus()
       local cpuState = getCPULoad()
       
       if memoryState == SystemStateEnums.MemoryStatus.Critical then
           Printf("Critical: Low memory condition")
           return SystemStateEnums.SystemHealth.Critical
       elseif cpuState == SystemStateEnums.ProcessorLoad.Overloaded then
           Printf("Warning: High CPU load")
           return SystemStateEnums.SystemHealth.Degraded
       end
       
       return SystemStateEnums.SystemHealth.Healthy
   end

5. Connection State Handling:
   local function handleConnectionChange(oldState, newState)
       if newState == SystemStateEnums.ConnectionStatus.Connected then
           Printf("Connection established")
           initializeRemoteOperations()
       elseif newState == SystemStateEnums.ConnectionStatus.Disconnected then
           Printf("Connection lost")
           enterStandaloneMode()
       elseif newState == SystemStateEnums.ConnectionStatus.Error then
           Printf("Connection error - attempting reconnect")
           scheduleReconnection()
       end
   end

INTEGRATION WITH SYSTEM APIs:
- Monitor system health with periodic state checks
- Handle connection events with state change callbacks
- Validate operations based on current system modes
- Implement error recovery based on error levels

CROSS-REFERENCES TO HANDLE METHODS:
- System states affect Handle:HasActivePlayback() results
- Connection states influence Handle:Export() success
- Performance states impact Handle:Import() operations
- Error states affect Handle property access reliability

MONITORING PATTERNS:
- Implement state change notifications
- Use state history for troubleshooting
- Create dashboards showing current states
- Log state transitions for analysis
]]

return SystemStateEnums