# Shoot Despawn Fix - Root Cause Found!

## 🎯 **Root Cause Identified**

The issue was **input action conflict**! When you pressed Space to shoot, it was triggering TWO actions simultaneously:

1. **`shoot` action** (Space key) → Player fires bullet ✅
2. **`ui_accept` action** (also Space key by default) → Manual wave start → `clear_all_enemies()` ❌

## 🔧 **The Problem Chain**

```
Press Space to shoot
    ↓
Player.shoot() fires bullet (correct)
    ↓
Main._input() detects ui_accept (Space)
    ↓
enemy_manager.start_wave(current_wave + 1)
    ↓
clear_all_enemies() called
    ↓
ALL enemies despawn immediately!
```

## ✅ **Fix Applied**

**Removed the conflicting `_input()` function** from Main.gd that was listening for `ui_accept` (Enter/Space) to manually start waves.

### **Before (Problematic):**
```gdscript
func _input(event):
    if event.is_action_pressed("ui_accept"):  # Space triggers this!
        enemy_manager.start_wave(current_wave + 1)  # Clears all enemies
```

### **After (Fixed):**
```gdscript
# Removed _input function that was conflicting with shoot action
```

## 🎮 **Expected Behavior Now**

### **When You Press Space:**
1. **Player shoots bullet** (correct)
2. **No other actions triggered** (fixed)
3. **Enemies stay on screen** (fixed)
4. **Bullet travels and can hit enemies** (correct)

### **Wave Progression:**
- **Automatic wave progression** still works when all enemies are destroyed
- **No manual wave start** (removed the conflicting feature)
- **Clean separation** between shooting and wave management

## 🚀 **Test Results Expected**

1. **Press Space** → Only bullet fires, enemies stay visible
2. **Bullet hits enemy** → Enemy destroyed, others remain
3. **Destroy all enemies** → Wave completes, next wave starts automatically
4. **No more mass despawning** when shooting

## 🔍 **Why This Happened**

Godot's default `ui_accept` action is mapped to both **Enter** and **Space** keys. When I added the manual wave start feature for debugging, I didn't realize it would conflict with the shoot action (Space).

This is a common Godot gotcha - always check default input mappings when adding custom input handlers!

## 📋 **Lesson Learned**

- **Be careful with `ui_*` actions** - they have default key mappings
- **Test input conflicts** when adding debug features
- **Use specific custom actions** instead of generic UI actions for game-specific features

The shooting system should now work perfectly without any enemy despawning issues!
