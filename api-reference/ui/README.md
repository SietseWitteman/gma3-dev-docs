# UI API Reference

User interface creation, management, and interaction methods for building GrandMA3 plugin interfaces.

## Overview

The UI API enables plugins to create rich user interfaces:
- **Dialog Creation**: InputDialog, CheckBoxDialog, FaderDialog, and custom dialogs
- **Display Management**: Screen handling, layout management, and positioning
- **User Input**: Event handling, validation, and user interaction processing

## Available Documentation

### Dialog Creation (`dialog-creation.*`)
Complete reference for creating interactive dialogs:
- **Input Dialogs**: Text input, numeric input, selection dialogs
- **Choice Dialogs**: CheckBox, RadioButton, and selection interfaces
- **Custom Dialogs**: Advanced dialog creation with multiple elements
- **Dialog Events**: Handling user responses and button clicks

*Files: `dialog-creation.lua`, `dialog-creation.json`, `dialog-creation.md`*

### Display Management (`display-management.*`)
Screen and display handling operations:
- **Display Access**: Getting display objects and properties
- **Screen Layout**: Window positioning and sizing
- **Multi-Display**: Working with multiple screens and displays
- **Display Properties**: Resolution, color depth, and capabilities

*Files: `display-management.lua`, `display-management.json`, `display-management.md`*

### User Input (`user-input.*`)
Input capture and processing methods:
- **Keyboard Input**: Key press handling and shortcuts
- **Mouse Events**: Click, drag, and hover interactions
- **Touch Input**: Touch screen and gesture support
- **Input Validation**: Data validation and sanitization

*Files: `user-input.lua`, `user-input.json`, `user-input.md`*

## Key Concepts

### Dialog Types
MA3 supports several built-in dialog types:
```lua
-- Input dialog for text/numeric input
CreateInputDialog("Title", "Prompt", function(result) end)

-- Checkbox dialog for boolean choices
CreateCheckBoxDialog("Title", {"Option 1", "Option 2"}, function(result) end)

-- Fader dialog for numeric ranges
CreateFaderDialog("Title", 0, 100, 50, function(result) end)
```

### Event Handling
All UI interactions use callback functions:
```lua
local function handleUserInput(result)
    if result then
        -- Process user input
        Printf("User entered: " .. tostring(result))
    end
end
```

### Display Coordinates
MA3 uses a coordinate system for UI positioning:
- **Origin**: Top-left corner (0,0)
- **Units**: Pixel-based positioning
- **Scaling**: Automatic scaling for different display sizes

## Usage Patterns

### Simple Input Dialog
```lua
CreateInputDialog("Plugin Settings", "Enter value:", function(result)
    if result then
        -- Use the input value
        local userValue = tonumber(result) or 0
    end
end)
```

### Multi-Choice Dialog
```lua
local options = {"Option A", "Option B", "Option C"}
CreateCheckBoxDialog("Select Options", options, function(result)
    for i, selected in ipairs(result) do
        if selected then
            Printf("Selected: " .. options[i])
        end
    end
end)
```

### Error Handling
Always handle dialog cancellation and invalid input:
```lua
CreateInputDialog("Title", "Prompt", function(result)
    if not result or result == "" then
        -- User cancelled or entered empty value
        return
    end
    
    -- Validate input
    local value = tonumber(result)
    if not value then
        -- Invalid numeric input
        return
    end
    
    -- Process valid input
end)
```

## Cross-References

### Related Enums
- Dialog types and modes: `/enums/ui-elements.md`
- Input validation types: `/enums/data-types.md`
- Display properties: `/enums/system-states.md`

### Examples
- Simple dialogs: `/examples/ui-creation/01-simple-dialog.lua`
- Complex dialogs: `/examples/ui-creation/02-complex-dialog.lua`
- Custom layouts: `/examples/ui-creation/03-custom-layouts.lua`

### Templates
- UI plugin template: `/templates/ui-plugin/`
- Dialog creation patterns: `/templates/ui-plugin/dialogs.lua`

### Utilities
- UI helper functions: `/utilities/ui-helpers/`
- Input validation: `/utilities/validation/`

## Best Practices

### Dialog Design Guidelines
- **Keep it Simple**: Minimize the number of inputs per dialog
- **Clear Labels**: Use descriptive prompts and titles
- **Validation**: Always validate user input before processing
- **Feedback**: Provide clear feedback for user actions

### Performance Considerations
- **Dialog Lifecycle**: Create dialogs only when needed
- **Event Handlers**: Keep callback functions lightweight
- **Memory Management**: Properly clean up dialog resources

### Accessibility
- **Clear Text**: Use readable fonts and appropriate sizes
- **Logical Flow**: Organize inputs in logical order
- **Keyboard Support**: Ensure keyboard navigation works properly

## Compatibility

- **MA3 API 2.2**: Full support for all dialog types
- **Hardware**: Tested on all MA3 console types
- **Future Versions**: UI API designed for forward compatibility
- **Performance**: Optimized for real-time console operation