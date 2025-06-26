# Enemy Spawning Debug Guide

## 🔍 Debug Steps to Find the Issue

I've added extensive debug output and test scripts to help identify why enemies aren't spawning. Here's what to check:

### 1. **Run the Game and Check Console Output**

When you start the game, look for these debug messages:

**During Initialization:**
```
Main scene loaded
EnemyManager connected successfully  (or WARNING if not found)
EnemyManager initialized
Enemy scene loaded successfully  (or ERROR if failed)
```

**When Starting Game:**
```
Game started signal received
EnemyManager found, starting wave 1  (or ERROR if not found)
=== EnemyManager.start_wave() called with wave 1 ===
Starting wave 1
Wave 1 will spawn 12 enemies
Spawn queue has 12 positions
Enemy scene loaded: true
```

**During Enemy Spawning:**
```
Spawning enemy... (12 remaining)
spawn_next_enemy() called
Spawning enemy at formation position: (160, 100)
Enemy instantiated: true
Enemy added to scene. Total enemies alive: 1
```

### 2. **Manual Tests Available**

I've added two manual test scripts:

**DirectEnemyTest** (Press ESC after game loads):
- Creates an enemy directly at position (320, 100)
- Tests if basic enemy creation works
- Should show a red enemy sprite in the middle of screen

**EnemySpawnTest** (Press Enter after game loads):
- Tests the EnemyManager connection
- Manually triggers wave spawning
- Shows detailed debug info about scene structure

### 3. **Common Issues to Check**

Based on the debug output, the issue is likely one of these:

**A) EnemyManager Not Found:**
- Look for "WARNING: EnemyManager not found during initialization!"
- This means the @onready reference failed

**B) Enemy Scene Loading Failed:**
- Look for "ERROR: Could not load Enemy scene!"
- This means Enemy.tscn has issues

**C) Game State Issue:**
- EnemyManager found but start_wave() never called
- This means the game start signal isn't working

**D) Spawning Logic Issue:**
- start_wave() called but no "Spawning enemy..." messages
- This means the spawn timer/logic has problems

### 4. **Quick Fixes to Try**

**If EnemyManager not found:**
```gdscript
# In Main.gd _ready(), add this debug:
print("GameWorld node: ", $GameWorld)
print("EnemyManager node: ", $GameWorld/EnemyManager)
```

**If enemies spawn but aren't visible:**
- Check if they're spawning off-screen
- Check if they have proper sprites
- Check if they're being added to the right parent

**If spawning logic fails:**
- Check if `enemies_to_spawn` is > 0
- Check if `spawn_timer` is incrementing
- Check if `spawn_delay` is reasonable (0.5 seconds)

### 5. **Expected Behavior**

When working correctly, you should see:
1. 12 enemies spawn one by one (every 0.5 seconds)
2. They appear at the top of screen and move to formation
3. They form a 3x4 grid pattern
4. They gently sway in formation
5. Occasionally one will dive toward the bottom

### 6. **Test Controls**

- **Start Game**: Click "START GAME" button
- **Manual Enemy Test**: Press ESC key (creates one enemy directly)
- **Manual Spawn Test**: Press Enter key (tests EnemyManager)
- **Shoot**: Space bar (to test if enemies can be destroyed)

Run the game and let me know what debug messages you see - this will help pinpoint exactly where the issue is!
