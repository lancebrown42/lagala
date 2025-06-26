# Troubleshooting Guide

## Issue: Start Game Button Not Working

### Problem
The "START GAME" button appears but doesn't respond when clicked.

### Debugging Steps

1. **Test with Simple Version**
   - The project is now set to use `MainSimple.tscn` as the main scene
   - This is a minimal version that should work
   - Run the game (F5) and test if the simple "START GAME" button works

2. **Check Console Output**
   When you run the simple version, you should see:
   ```
   === SIMPLE MAIN LOADED ===
   GameManager: [GameManager instance]
   StartScreen: [Control instance]
   GameScreen: [Control instance]  
   StartButton: [Button instance]
   Connecting start button...
   Start button connected successfully!
   Game manager connected!
   ```

3. **Test Button Click**
   When you click "START GAME", you should see:
   ```
   🎉 START BUTTON PRESSED!
   Calling game_manager.start_game()...
   🎮 GAME STARTED SIGNAL RECEIVED!
   ```

### If Simple Version Works:
The issue is in the complex Main.tscn scene. Possible causes:
- Scene node structure corruption
- @onready variable references failing
- Signal connection timing issues

### If Simple Version Doesn't Work:
The issue is more fundamental:
- Godot version compatibility
- Project configuration issues
- Input system problems

### Solutions:

#### Solution 1: Use Simple Version
If the simple version works, you can build from there:
1. Keep using `MainSimple.tscn`
2. Gradually add features back
3. Test after each addition

#### Solution 2: Fix Complex Version
1. Change project.godot back to use `Main.tscn`:
   ```
   run/main_scene="res://scenes/Main.tscn"
   ```
2. Check the console for error messages
3. Look for null reference errors in @onready variables

#### Solution 3: Manual Button Connection
Add this to Main.gd in _ready():
```gdscript
# Manual button connection as fallback
await get_tree().process_frame
if not start_button.pressed.is_connected(_on_start_button_pressed):
    start_button.pressed.connect(_on_start_button_pressed)
```

### Common Godot Issues:

1. **@onready timing**: Sometimes @onready variables aren't ready when _ready() is called
2. **Scene references**: Node paths might be incorrect
3. **Signal connections**: Connections might fail silently
4. **Scene loading**: Complex scenes might have loading order issues

### Testing Commands:
- Press `T` key in GameManagerTest to manually trigger start_game()
- Check console for debug output from ButtonDebugger
- Look for error messages in Godot's debugger

### Next Steps:
1. Test the simple version first
2. Report which version works/doesn't work
3. Check console output for error messages
4. We can then fix the specific issue found
