#!/usr/bin/env python3
"""
Test if Enemy.tscn can be loaded properly
"""

import os

def test_enemy_scene():
    print("=== ENEMY SCENE LOADING TEST ===")
    
    enemy_path = "scenes/Enemy.tscn"
    
    if not os.path.exists(enemy_path):
        print("❌ Enemy.tscn not found")
        return False
    
    print("✅ Enemy.tscn file exists")
    
    # Read and check basic structure
    with open(enemy_path, 'r') as f:
        content = f.read()
    
    # Check for required elements
    checks = [
        ("[gd_scene", "Scene header"),
        ("CharacterBody2D", "Enemy body"),
        ("Area2D", "Collision area"),
        ("Sprite2D", "Enemy sprite"),
        ("Enemy.gd", "Enemy script"),
        ("RectangleShape2D", "Collision shape"),
    ]
    
    all_passed = True
    for check, description in checks:
        if check in content:
            print(f"✅ {description} found")
        else:
            print(f"❌ {description} missing")
            all_passed = False
    
    # Check for common syntax issues
    if content.count('[') == content.count(']'):
        print("✅ Balanced brackets")
    else:
        print("❌ Unbalanced brackets")
        all_passed = False
    
    if content.count('"') % 2 == 0:
        print("✅ Balanced quotes")
    else:
        print("❌ Unbalanced quotes")
        all_passed = False
    
    # Check line 13 specifically (where the error was)
    lines = content.split('\n')
    if len(lines) >= 13:
        line_13 = lines[12]  # 0-indexed
        print(f"Line 13 content: '{line_13}'")
        if line_13.strip():
            print("✅ Line 13 has content")
        else:
            print("⚠️  Line 13 is empty")
    
    return all_passed

if __name__ == "__main__":
    if test_enemy_scene():
        print("\n🎉 Enemy.tscn should load properly now!")
    else:
        print("\n⚠️  Enemy.tscn may still have issues")
