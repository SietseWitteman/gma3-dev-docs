# UI Creation Examples

User interface patterns for creating interactive plugin dialogs and user experiences. Learn to build professional-quality interfaces for your MA3 plugins.

## Overview

Master MA3 UI development with examples covering:
- Dialog creation and management
- User input handling and validation
- Custom layouts and advanced interfaces
- Event processing and user feedback

## Available Examples

### 01-simple-dialog.lua
**Difficulty**: Beginner  
**API Used**: `CreateInputDialog`, dialog callbacks, user input  
**Description**: Create basic input dialogs for collecting user data with proper validation and error handling.

**Key Concepts**:
- Creating input dialogs with titles and prompts
- Handling user responses with callback functions
- Input validation and error feedback
- Dialog positioning and display management

**Usage Patterns**:
```lua
-- Basic input dialog
CreateInputDialog("Plugin Setup", "Enter value:", function(result)
    if result and result ~= "" then
        ProcessUserInput(result)
    end
end)
```

**Based on**: Enhanced version of existing `CreateInputDialog.txt` example

### 02-complex-dialog.lua
**Difficulty**: Intermediate  
**API Used**: `CreateCheckBoxDialog`, `CreateFaderDialog`, multiple inputs  
**Description**: Build multi-element dialogs combining different input types for comprehensive user interfaces.

**Key Concepts**:
- Combining multiple dialog types
- Managing complex user input flows
- State management across dialog interactions
- Advanced validation and user feedback

**Usage Patterns**:
```lua
-- Multi-step dialog process
local function createComplexDialog()
    -- First get basic settings
    CreateInputDialog("Step 1", "Enter name:", function(name)
        if name then
            -- Then get options
            CreateCheckBoxDialog("Step 2", options, function(selections)
                -- Process combined results
                processCombinedInput(name, selections)
            end)
        end
    end)
end
```

**Based on**: Extended patterns from `CreateCheckBoxDialog.txt` and `CreateFaderDialog.txt`

### 03-custom-layouts.lua
**Difficulty**: Advanced  
**API Used**: Display positioning, custom UI elements, layout management  
**Description**: Create advanced dialog layouts with custom positioning and multiple display support.

**Key Concepts**:
- Custom dialog positioning and sizing
- Multi-display dialog management
- Advanced layout techniques
- Display-aware interface design

**Usage Patterns**:
```lua
-- Custom positioned dialog
local function createCustomDialog(displayHandle)
    local displayIndex = Obj.Index(GetFocusDisplay())
    if displayIndex > 5 then displayIndex = 1 end
    
    -- Create dialog with custom positioning
    -- Implementation varies by MA3 API capabilities
end
```

### 04-event-handling.lua
**Difficulty**: Intermediate  
**API Used**: Dialog callbacks, event processing, state management  
**Description**: Advanced event handling patterns for responsive and interactive user interfaces.

**Key Concepts**:
- Event-driven programming patterns
- State management in UI applications
- User interaction feedback
- Asynchronous UI operations

**Usage Patterns**:
```lua
-- Event-driven dialog management
local DialogState = {
    current = nil,
    data = {},
    callbacks = {}
}

local function handleDialogEvent(eventType, data)
    -- Process events and update state
    if DialogState.callbacks[eventType] then
        DialogState.callbacks[eventType](data)
    end
end
```

### 05-validation-feedback.lua
**Difficulty**: Intermediate  
**API Used**: Input validation, user feedback, error dialogs  
**Description**: Provide clear user feedback for validation errors and guide users to correct input.

**Key Concepts**:
- Real-time input validation
- User-friendly error messages
- Input correction guidance
- Progressive validation strategies

**Usage Patterns**:
```lua
-- Validation with user feedback
local function validateAndProcess(input, callback)
    local isValid, errorMessage = validateInput(input)
    
    if not isValid then
        CreateInputDialog("Error", errorMessage .. "\nPlease try again:", 
            function(newInput)
                validateAndProcess(newInput, callback)
            end)
    else
        callback(input)
    end
end
```

### 06-theming-colors.lua
**Difficulty**: Advanced  
**API Used**: Color themes, UI styling, display properties  
**Description**: Use MA3 color themes and styling for consistent, professional-looking interfaces.

**Key Concepts**:
- Accessing MA3 color themes
- Consistent UI styling
- Display-appropriate color schemes
- Theme-aware interface design

**Usage Patterns**:
```lua
-- Access MA3 color theme
local function getThemeColors()
    local colors = {
        background = Root().ColorTheme.ColorGroups.Button.Background,
        transparent = Root().ColorTheme.ColorGroups.Global.Transparent,
        selected = Root().ColorTheme.ColorGroups.Global.PartlySelected
    }
    return colors
end
```

**Based on**: Color patterns from existing `CreateInputDialog.txt` example

## Learning Path

### Phase 1: Basic Dialogs (Examples 01-02)
- Understand dialog creation fundamentals
- Learn callback pattern usage
- Master basic input validation
- Practice simple user interaction

### Phase 2: Advanced Interactions (Examples 03-04)
- Custom layouts and positioning
- Event-driven programming
- State management techniques
- Multi-step user workflows

### Phase 3: Professional Polish (Examples 05-06)
- Comprehensive validation and feedback
- Theme-aware styling
- Error recovery strategies
- Professional user experience

## Common UI Patterns

### Dialog Creation Template
```lua
local function createStandardDialog(title, prompt, validator, callback)
    CreateInputDialog(title, prompt, function(result)
        if not result or result == "" then
            return -- User cancelled
        end
        
        local isValid, processedValue = validator(result)
        if isValid then
            callback(processedValue)
        else
            -- Show error and retry
            createStandardDialog(title, "Invalid input. " .. prompt, validator, callback)
        end
    end)
end
```

### Multi-Choice Processing
```lua
local function processCheckboxResults(options, results)
    local selected = {}
    for i, isSelected in ipairs(results) do
        if isSelected then
            table.insert(selected, options[i])
        end
    end
    return selected
end
```

### Safe Dialog Display
```lua
local function safeCreateDialog(dialogFunction, ...)
    local success, error = pcall(dialogFunction, ...)
    if not success then
        Printf("Dialog creation failed: " .. tostring(error))
        return false
    end
    return true
end
```

## Integration Points

### API References
UI examples demonstrate APIs from:
- [UI API](../../api-reference/ui/) - Dialog creation and management
- [Core API](../../api-reference/core/) - Object access and display handling
- [Data API](../../api-reference/data/) - Input validation and processing

### Utility Functions
Examples leverage utilities from:
- [UI Helpers](../../utilities/ui-helpers/) - Dialog creation shortcuts
- [Validation Utils](../../utilities/validation/) - Input validation
- [String Utils](../../utilities/string-utils/) - Text processing

### Template Integration
UI patterns appear in:
- [UI Plugin Template](../../templates/ui-plugin/) - Complete UI-focused plugin
- [Basic Plugin Template](../../templates/basic-plugin/) - Simple UI integration
- [Advanced Plugin Template](../../templates/advanced-plugin/) - Complex UI management

## Best Practices

### User Experience
- **Clear Labels**: Use descriptive dialog titles and prompts
- **Validation Feedback**: Provide helpful error messages
- **Consistent Styling**: Use MA3 color themes and conventions
- **Responsive Design**: Handle different display sizes gracefully

### Error Handling
- **Graceful Degradation**: Handle dialog creation failures
- **User Guidance**: Guide users to correct invalid input
- **Cancel Handling**: Always handle user cancellation appropriately
- **State Recovery**: Maintain application state across dialog interactions

### Performance
- **Dialog Lifecycle**: Create dialogs only when needed
- **Memory Management**: Clean up dialog resources properly
- **Event Efficiency**: Keep callback functions lightweight
- **Display Awareness**: Optimize for target display capabilities

### Code Organization
- **Modular Functions**: Break complex UIs into manageable functions
- **State Management**: Use consistent patterns for UI state
- **Reusable Components**: Create reusable dialog components
- **Clear Naming**: Use descriptive names for UI elements and functions

## Advanced Techniques

### Multi-Display Support
```lua
local function getOptimalDisplay()
    local displayIndex = Obj.Index(GetFocusDisplay())
    return displayIndex <= 5 and displayIndex or 1
end
```

### Dynamic Dialog Content
```lua
local function createDynamicDialog(options)
    local dialogContent = buildDialogContent(options)
    CreateInputDialog(dialogContent.title, dialogContent.prompt, dialogContent.callback)
end
```

### State-Driven UI
```lua
local UIState = {
    currentDialog = nil,
    userProgress = {},
    validationRules = {}
}

local function updateUIState(newState)
    UIState = mergeTables(UIState, newState)
    refreshCurrentDialog()
end
```

## Testing and Validation

All UI examples include:
- ✅ **Hardware Testing**: Verified on actual MA3 consoles
- ✅ **Display Compatibility**: Tested on different display configurations
- ✅ **User Scenarios**: Validated with common user interaction patterns
- ✅ **Error Conditions**: Tested with invalid input and edge cases
- ✅ **Performance**: Optimized for console responsiveness

## Next Steps

After mastering UI creation:
1. **Data Management**: Learn data processing → [Data Examples](../data-management/)
2. **Advanced Patterns**: Complex architectures → [Advanced Examples](../advanced-patterns/)
3. **Complete Plugins**: Full implementations → [Complete Plugins](../complete-plugins/)

## Resources

### Existing Examples
Building upon existing MA3 examples:
- `CreateInputDialog.txt` → Enhanced in `01-simple-dialog.lua`
- `CreateCheckBoxDialog.txt` → Extended in `02-complex-dialog.lua`
- `CreateFaderDialog.txt` → Integrated in `02-complex-dialog.lua`

### MA3 Documentation
- Color theme system documentation
- Display management guidelines
- UI best practices for console applications