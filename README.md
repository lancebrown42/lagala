# Lagala - Galaga Clone

A retro-style Galaga clone built with Godot 4.

## Phase 1 Implementation Status ✅
- ✅ Project structure setup with organized folders
- ✅ Game window configuration (640x480, non-resizable)
- ✅ Basic game loop with 60fps target
- ✅ Input system (A/D or Arrow keys for movement, Space for shooting)
- ✅ Game state management (Menu, Playing, Game Over, Paused)
- ✅ UI system with start screen, HUD, and game over screen
- ✅ Score and lives tracking system
- ✅ Basic test framework

## Phase 2 Implementation Status ✅

### Completed Features:
- ✅ Player ship with sprite and collision detection
- ✅ Smooth movement with acceleration and friction
- ✅ Boundary collision (player stays on screen)
- ✅ Shooting system with bullet pooling
- ✅ Fire rate limiting and max bullets on screen
- ✅ Player bullet physics and collision
- ✅ Automatic sprite generation for placeholders
- ✅ Player integration with game state system

### New Components:
- **Player.gd**: Player ship controller with movement and shooting
- **PlayerBullet.gd**: Bullet physics and collision handling
- **SpriteGenerator.gd**: Runtime sprite creation for placeholders
- **Player.tscn**: Player ship scene with collision
- **PlayerBullet.tscn**: Bullet scene with physics
- **Phase2Tester.gd**: Automated testing for player functionality

### Project Structure:
```
lagala/
├── assets/
│   ├── sprites/
│   │   ├── player/
│   │   ├── enemies/
│   │   ├── bullets/
│   │   └── effects/
│   ├── sounds/
│   └── fonts/
├── scenes/
│   └── Main.tscn
├── scripts/
│   ├── GameManager.gd
│   ├── Main.gd
│   ├── GameLoop.gd
│   └── TestRunner.gd
└── project.godot
```

### Controls:
- **A/D or Left/Right Arrow Keys**: Move player ship
- **Space**: Shoot (max 3 bullets on screen)
- **Escape**: Pause/Resume game

### How to Run:
1. Open the project in Godot 4.4+
2. Press F5 or click "Play" to run the game
3. Click "START GAME" to begin playing
4. Use A/D keys to move, Space to shoot

### Gameplay Features:
- Smooth player movement with acceleration/deceleration
- Shooting with fire rate limiting
- Player ship stays within screen boundaries
- Visual feedback with colored sprites
- Bullet collision detection ready for enemies

### Next Phase:
Phase 3 will implement enemy formation, movement patterns, and enemy shooting.

## Development Notes:
- Target resolution: 640x480 (retro style)
- Target framerate: 60 FPS
- Pixel-perfect rendering enabled
- Forward+ renderer for better performance
