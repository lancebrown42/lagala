# Collision Layers Fixed

## 🎯 **Collision Layer System**

### **Layer Assignments:**
- **Layer 1:** World/Environment (unused currently)
- **Layer 2:** Player CharacterBody2D
- **Layer 4:** Enemy CharacterBody2D

### **Collision Setup:**

#### **Player (CharacterBody2D):**
- `collision_layer = 2` (Player layer)
- `collision_mask = 0` (Collides with nothing - no physics pushing)

#### **Player HitBox (Area2D):**
- `collision_layer = 0` (No layer)
- `collision_mask = 4` (Detects Enemy layer)

#### **Enemy (CharacterBody2D):**
- `collision_layer = 4` (Enemy layer)
- `collision_mask = 0` (Collides with nothing - no physics pushing)

#### **Enemy Area2D:**
- `collision_layer = 0` (No layer)
- `collision_mask = 2` (Detects Player layer)

#### **PlayerBullet (Area2D):**
- `collision_layer = 0` (No layer)
- `collision_mask = 4` (Detects Enemy layer)

## 🔧 **How It Works:**

### **Player-Enemy Collision:**
1. **Enemy Area2D** (mask=2) detects **Player CharacterBody2D** (layer=2)
2. **Player HitBox** (mask=4) detects **Enemy CharacterBody2D** (layer=4)
3. **No physics collision** between Player and Enemy CharacterBody2D
4. **Only Area2D detection** triggers hit logic

### **Bullet-Enemy Collision:**
1. **PlayerBullet Area2D** (mask=4) detects **Enemy CharacterBody2D** (layer=4)
2. **Enemy Area2D** (mask=2) does NOT detect bullets (bullets are layer=0)
3. **Clean bullet collision** without interference

## ✅ **Expected Results:**

### **Player Hit by Enemy:**
- ✅ **No physics pushing** (CharacterBody2D collision disabled)
- ✅ **Area2D detection works** (proper hit detection)
- ✅ **Player respawns** at center with invulnerability
- ✅ **Lives decremented** properly

### **Bullet Hits Enemy:**
- ✅ **Bullet detects enemy** (Area2D to CharacterBody2D)
- ✅ **Enemy takes damage** and is destroyed
- ✅ **Bullet is destroyed** on impact

### **No Interference:**
- ✅ **Player movement** works normally
- ✅ **Enemy movement** works normally
- ✅ **No unwanted collisions** between different systems

This should fix both the player collision issue AND restore bullet functionality!
