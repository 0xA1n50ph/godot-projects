# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HorrorPrototype01 is a first-person horror game built with Godot 4.6 using GDScript. It features a low-resolution retro aesthetic (640x480 viewport) with Forward Plus rendering and multiple post-processing shaders.

## Running the Project

Open the project in Godot 4.6+ and press F5 to run, or use command line:
```bash
godot --path . --editor  # Open in editor
godot --path .           # Run directly
```

## Composition Design Pattern

This project follows the **Composition over Inheritance** pattern. Instead of deep inheritance hierarchies, behavior is delegated to reusable component nodes. This enables:
- **Reusability**: Components can be shared across different objects
- **Flexibility**: Mix and match components to create new behaviors
- **Testability**: Components can be tested in isolation
- **Maintainability**: Changes to one component don't affect others

### Component Guidelines
When adding new features or refactoring existing code, follow these principles:
1. **Extract reusable logic into components** - If behavior could be used elsewhere, make it a component
2. **Components are Node children** - Attach components as child nodes, reference via `@onready`
3. **Use signals for communication** - Components emit signals; parent objects connect to them
4. **Keep components focused** - Each component should have a single responsibility
5. **Base classes define interfaces** - Use abstract base classes (like `InteractableBase`) for polymorphism
6. **Refactor towards composition** - When refactoring, prefer breaking monolithic scripts into components if it improves reusability or maintainability

## Architecture

### Autoloads (Singletons)
- **PauseManager** (`scripts/pause_manager.gd`): Global pause state manager. Emits `game_paused` and `game_unpaused` signals. Uses `PROCESS_MODE_ALWAYS` to handle input while paused. Toggles on ESC key.
- **PauseMenu** (`levels/menus/pause_menu.tscn`): CanvasLayer (layer 100) with VHS shader effect. Connects to PauseManager signals for visibility.

### Scene Structure
```
levels/prototype.tscn                              - Main game level with environment and player
scenes/player.tscn                                 - Player prefab (CharacterBody3D + components)
levels/menus/pause_menu.tscn                       - Pause menu overlay
scenes/assets/PC_Parts/                            - Modular interactive PC system
scenes/assets/PROTO_apartment.tscn                 - Apartment environment
scripts/Components/                                - Player components (InputComponent, AnimationComponent)
scripts/Components/Interactables/                  - Interactable components (base class + reusable behaviors)
```

### Player System (Component-Based)
The player (`scripts/player.gd`) extends CharacterBody3D and delegates to components:

- **InputComponent** (`scripts/Components/InputComponent.gd`): Handles movement, crouch, sprint, camera control, and interaction. Emits `walking_changed(is_walking: bool)` signal.
- **AnimationComponent** (`scripts/Components/AnimationComponent.gd`): Manages headbob animation.

**Player hierarchy:**
```
Player (CharacterBody3D)
├── InputComponent
├── AnimationComponent
├── CameraHolder (Node3D)
│   └── Camera3D
│       └── FrontCheckShapeCast3D (interaction raycast)
├── CollisionShape3D (CapsuleShape3D)
├── TopCheckRayCast (ceiling detection for crouch)
├── FootstepAudio3D
└── HeadbobAnim (AnimationPlayer)
```

**Key exports in player.gd:**
- `SPEED`, `SPRINT_SPEED`, `CROUCH_SPEED` - Movement speeds
- `MOUSE_SENSITIVITY` - Camera sensitivity
- `PLAYER_HEIGHT`, `CROUCH_HEIGHT`, `CROUCH_TRANSITION_SPEED` - Crouch system
- `JUMP_ENABLE` - Toggle jump functionality

### Interactable System (Component-Based)
The interactable system uses composition to enable reusable interaction behaviors.

**Base Class:**
- **InteractableBase** (`scripts/Components/Interactables/InteractableBase.gd`): Abstract base extending StaticBody3D. Defines `interact(player)` and `is_in_use()` interface. Emits `interaction_started` and `interaction_ended` signals.

**Reusable Components** (`scripts/Components/Interactables/`):
- **InteractionStateComponent**: Tracks player reference and interaction state. Emits `state_changed(is_using: bool)`.
- **CameraTransitionComponent**: Smooth camera transitions with configurable duration and easing. Exports: `transition_duration`, `ease_type`, `trans_type`.
- **VirtualInputComponent**: Forwards mouse/keyboard input to a SubViewport for virtual UI interaction. Handles mouse position clamping and event transformation.

**Concrete Implementation:**
- **InteractableComputer** (`scenes/assets/PC_Parts/sm_pc.gd`): Computer the player can use. Composes all three components.

**SM_PC hierarchy:**
```
SM_PC (StaticBody3D, extends InteractableBase)
├── InteractionStateComponent
├── CameraTransitionComponent
├── VirtualInputComponent (target_viewport_path -> SubViewport)
├── SubViewport
│   └── pc_ui (Control)
├── interaction_camera (Camera3D)
├── computer_monitor2, computer_mouse2, computer_keyboard2, computer_tower2
├── computer_screen (MeshInstance3D with ViewportTexture)
└── CollisionShape3D
```

**Creating New Interactables:**
1. Extend `InteractableBase`
2. Add needed components as child nodes
3. Override `interact(player)` and `is_in_use()`
4. Add to appropriate group (e.g., "computers", "terminals")

Objects in "computers" group are detected by player's ShapeCast3D.

### Input Actions
Defined in `project.godot`:
- Movement: `forward` (W), `backward` (S), `left` (A), `right` (D)
- Actions: `jump` (Space), `sprint` (LShift), `crouch` (LCtrl)
- Interaction: `interact` (E), `flashlight` (F), `exit_pc` (RMB)
- UI: `ui_cancel` (Esc)

### Physics Layers
1. **player** - Player collision
2. **enemies** - Enemy entities
3. **world** - Static geometry
4. **items** - Collectible/interactive items

Player collision mask: layers 2 & 3 (enemies & world)

### Addons
- **sky_3d** (`addons/sky_3d/`): Dynamic sky with day/night cycle, atmospheric scattering, sun/moon positioning. Main script: `Sky3D.gd`.
- **GodotRetro** (`addons/GodotRetro/`): Retro shader library including VHS, grain, CRT, PSX-style effects, and dithering.

### Shaders
- `shaders/dithering_effect.gdshader`: Custom Bayer matrix dithering with posterization and pixelation.
- `levels/prototype_shaders.gd`: Applies Dithering, Grain, and BetterCC shaders to the level.
- Pause menu uses `VHSPause.gdshader` for distortion effect.

### UI Themes
Retro Windows themes in `ui_themes/`:
- **Classic95** - Windows 95 style
- **Classic311** - Windows 3.11 style
- **Modern11** - Windows 11 style

## Conventions

### Code Style
- Scripts use typed GDScript with explicit return types
- Export variables use `:=` for type inference with default values
- Physics logic goes in `_physics_process()`, input handling in `_input()` or `_unhandled_input()`
- Player movement modifies `velocity` directly, then calls `move_and_slide()`
- All functions end with explicit `return` statement

### Composition Pattern
- **Use composition over inheritance** - Delegate behavior to component nodes
- **Components location**: `scripts/Components/` for player, `scripts/Components/Interactables/` for interactables
- **Reference components via `@onready`**: `@onready var component: ComponentType = $ComponentNode`
- **Components define `class_name`**: Enables type hints and reuse across scenes
- **Connect signals in `_ready()`**: Parent objects wire up component signals
- **Refactoring**: When refactoring, always consider if the Composition Design Pattern applies. Extract reusable behaviors into components when it improves code organization or enables reuse

### Interaction System
- Interaction uses object groups ("computers", "collectible") and ShapeCast3D detection
- Interactable objects extend `InteractableBase` and implement `interact(player)` and `is_in_use()`
- Signal-based communication between systems (PauseManager signals, InputComponent.walking_changed, InteractableBase signals)
