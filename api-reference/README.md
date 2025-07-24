# API Reference

Complete documentation for all GrandMA3 API 2.2 methods, properties, and enumerations. This reference is organized by functional categories for easy navigation and discovery.

## Categories

### 🏗️ [Core](./core/)
Fundamental MA3 objects, handle methods, and core system operations:
- **Handle Methods**: Object manipulation, address resolution, property access
- **Object System**: Core MA3 object lifecycle and management
- **Basic Operations**: Essential functions every plugin needs

### 🎨 [UI](./ui/)
User interface creation, management, and interaction:
- **Dialog Creation**: InputDialog, CheckBoxDialog, FaderDialog patterns
- **Display Management**: Screen handling, layout, and positioning
- **User Input**: Event handling, validation, and response processing

### ⚡ [Commands](./commands/)
Command system, execution, and command-line operations:
- **Command Execution**: Running MA3 commands from Lua
- **Command Building**: Constructing complex command sequences
- **Command Validation**: Syntax checking and error handling

### 📊 [Data](./data/)
Data handling, manipulation, and storage operations:
- **Data Access**: Reading and writing MA3 data structures
- **Data Validation**: Input validation and sanitization
- **Data Conversion**: Type conversion and formatting utilities

### 🔧 [System](./system/)
System-level operations, utilities, and environment access:
- **System Information**: Hardware, software, and environment details
- **File Operations**: File system access and manipulation
- **System Configuration**: Settings and preferences management

### 📋 [Enums](./enums/)
All MA3 enumerations organized by category with usage examples:
- **Object Types**: Fixture, Group, Preset, Cue enumerations
- **UI Elements**: Dialog types, button states, input modes
- **System States**: Connection states, operation modes, status flags

## File Naming Conventions

Each category follows a consistent naming pattern:

```
category-name/
├── README.md                    # Category overview and navigation
├── method-group.lua            # Lua definitions with examples
├── method-group.json           # JSON snippets for IDE integration  
├── method-group.md             # Human-readable documentation
└── ...
```

## Usage Examples

### Finding a Method
1. **Know the category**: UI methods → `/ui/`, Core objects → `/core/`
2. **Browse the category**: Each README lists all available method groups
3. **Check multiple formats**: `.lua` for code, `.md` for documentation, `.json` for IDE integration

### Cross-References
- Methods reference related enums in `/enums/`
- Examples link to practical usage in `/examples/`
- Templates show integration patterns in `/templates/`

## API Version Information

- **Current Version**: MA3 API 2.2
- **Compatibility**: Forward-compatible design for future versions
- **Testing**: All methods verified on actual MA3 hardware
- **Updates**: Version-specific changes documented in each category

## Quick Reference

| Category | Primary Use Cases | Key Objects |
|----------|------------------|-------------|
| **Core** | Object manipulation, basic operations | Handle, Obj() |
| **UI** | Dialog creation, user interaction | Input dialogs, displays |
| **Commands** | Command execution, automation | Cmd(), command strings |
| **Data** | Data access, validation | Properties, values |
| **System** | System info, file operations | System objects, utilities |
| **Enums** | Constants, predefined values | All enumeration types |

## Integration

This API reference integrates with other toolkit components:
- **Examples**: Working code using these APIs
- **Templates**: Structured usage patterns
- **Utilities**: Helper functions wrapping common API calls
- **Tools**: Debugging and testing utilities for API usage