# All Enemies Despawn Debug

## 🚨 **Critical Issue**
When you shoot ONE enemy, ALL enemies disappear. This is a severe bug that suggests:

1. **Mass destruction trigger** - Something is calling destroy on all enemies
2. **clear_all_enemies() called incorrectly** - Wave completion logic firing too early  
3. **Signal cascade** - One enemy destruction triggering mass destruction
4. **Scene management issue** - Something removing the entire enemy container

## 🔍 **Debug Added**

### 1. **Enemy Removal Tracking**
- Added `tree_exiting` signal to track when each enemy is removed
- Shows which enemies are being removed and why
- Distinguishes between normal destroy() and unexpected removal

### 2. **clear_all_enemies() Stack Trace**
- Added warning and stack trace when clear_all_enemies() is called
- Will show exactly what function is calling the mass enemy clear
- Should NOT be called during normal gameplay

### 3. **Enemy List Debugging**
- Shows all current enemies before/after each destruction
- Tracks enemy positions and validity
- Disabled wave completion check temporarily

### 4. **Signal Connection Safety**
- Added checks to prevent duplicate signal connections
- Warns if signals are already connected (could cause double-firing)

## 🎯 **Expected Debug Output**

### **Normal Single Enemy Hit:**
```
=== ENEMY TAKE DAMAGE ===
Enemy: Enemy
=== ENEMY DESTROY CALLED ===
=== ENEMY MANAGER: Enemy destroyed ===
Current enemies list:
  0: Enemy at (100, 80)
  1: Enemy at (180, 80)  ← This one being destroyed
  2: Enemy at (260, 80)
  ...
Enemies alive after removal: 11
Skipping wave completion check for debugging
```

### **If All Enemies Disappear (BAD):**
```
=== CLEARING ALL ENEMIES ===
WARNING: clear_all_enemies() called!
Call stack trace: [shows what called it]
```

OR

```
=== ENEMY BEING REMOVED FROM SCENE ===
Enemy name: Enemy
Removal reason: unknown  ← Not from destroy()
```

## 🚀 **Test Instructions**

1. **Start the game** and let enemies spawn
2. **Shoot ONE enemy** 
3. **Immediately check console** for debug output
4. **Look for these key indicators:**

**If clear_all_enemies() is called:**
- You'll see "WARNING: clear_all_enemies() called!"
- Stack trace will show what triggered it
- This should NOT happen during normal gameplay

**If enemies are removed unexpectedly:**
- You'll see multiple "ENEMY BEING REMOVED FROM SCENE" messages
- With "Removal reason: unknown"
- This indicates something other than destroy() is removing them

**If it's a signal cascade:**
- You'll see multiple "ENEMY DESTROY CALLED" messages
- For different enemies, not just the one that was hit

## 🔧 **Most Likely Causes**

1. **Wave completion firing too early** - complete_wave() → clear_all_enemies()
2. **Signal connection error** - One destroy signal triggering multiple enemies
3. **Scene tree manipulation** - Something removing the enemy container node
4. **Game state change** - Game over or scene switch triggered incorrectly

The debug output will pinpoint exactly which scenario is happening!
