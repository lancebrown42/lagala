#!/usr/bin/env python3

"""
Lagala Phase 2 Project Validator
Validates player ship implementation
"""

import os
import re
from pathlib import Path

def main():
    print("=== LAGALA PHASE 2 PROJECT VALIDATOR ===")
    
    project_root = Path.cwd()
    print(f"Project root: {project_root}")
    
    # Test 1: New files for Phase 2
    test_phase2_files(project_root)
    
    # Test 2: Player script validation
    test_player_script(project_root)
    
    # Test 3: Bullet script validation
    test_bullet_script(project_root)
    
    # Test 4: Scene file validation
    test_scene_files(project_root)
    
    print("=== PHASE 2 VALIDATION COMPLETE ===")

def test_phase2_files(root):
    print("\nTest 1: Phase 2 Files")
    
    required_files = [
        "scripts/Player.gd",
        "scripts/PlayerBullet.gd",
        "scripts/SpriteGenerator.gd",
        "scripts/Phase2Tester.gd",
        "scenes/Player.tscn",
        "scenes/PlayerBullet.tscn"
    ]
    
    for file_path in required_files:
        full_path = root / file_path
        if full_path.exists():
            print(f"✓ {file_path}")
        else:
            print(f"✗ {file_path} - Missing")

def test_player_script(root):
    print("\nTest 2: Player Script Validation")
    
    player_script = root / "scripts/Player.gd"
    if not player_script.exists():
        print("✗ Player.gd not found")
        return
    
    try:
        with open(player_script, 'r') as f:
            content = f.read()
        
        # Check for key components
        checks = [
            ("extends CharacterBody2D", r'extends CharacterBody2D'),
            ("class_name Player", r'class_name Player'),
            ("Movement properties", r'@export var speed'),
            ("Shooting properties", r'@export var bullet_speed'),
            ("handle_movement function", r'func handle_movement'),
            ("handle_shooting function", r'func handle_shooting'),
            ("shoot function", r'func shoot\(\)'),
            ("enforce_boundaries function", r'func enforce_boundaries'),
            ("Player signals", r'signal player_shot')
        ]
        
        for check_name, pattern in checks:
            if re.search(pattern, content):
                print(f"✓ {check_name}")
            else:
                print(f"✗ {check_name} not found")
                
    except Exception as e:
        print(f"✗ Error reading Player.gd: {e}")

def test_bullet_script(root):
    print("\nTest 3: Bullet Script Validation")
    
    bullet_script = root / "scripts/PlayerBullet.gd"
    if not bullet_script.exists():
        print("✗ PlayerBullet.gd not found")
        return
    
    try:
        with open(bullet_script, 'r') as f:
            content = f.read()
        
        # Check for key components
        checks = [
            ("extends Area2D", r'extends Area2D'),
            ("class_name PlayerBullet", r'class_name PlayerBullet'),
            ("Speed property", r'@export var speed'),
            ("Damage property", r'@export var damage'),
            ("Movement physics", r'position \+= velocity'),
            ("Collision handling", r'func _on_body_entered'),
            ("Bullet destruction", r'func destroy_bullet'),
            ("Bullet signals", r'signal bullet_destroyed')
        ]
        
        for check_name, pattern in checks:
            if re.search(pattern, content):
                print(f"✓ {check_name}")
            else:
                print(f"✗ {check_name} not found")
                
    except Exception as e:
        print(f"✗ Error reading PlayerBullet.gd: {e}")

def test_scene_files(root):
    print("\nTest 4: Scene Files Validation")
    
    # Test Player.tscn
    player_scene = root / "scenes/Player.tscn"
    if player_scene.exists():
        try:
            with open(player_scene, 'r') as f:
                content = f.read()
            
            if 'type="CharacterBody2D"' in content:
                print("✓ Player.tscn - CharacterBody2D root")
            else:
                print("✗ Player.tscn - Wrong root type")
            
            if 'type="Sprite2D"' in content:
                print("✓ Player.tscn - Has Sprite2D")
            else:
                print("✗ Player.tscn - Missing Sprite2D")
            
            if 'type="CollisionShape2D"' in content:
                print("✓ Player.tscn - Has CollisionShape2D")
            else:
                print("✗ Player.tscn - Missing CollisionShape2D")
                
        except Exception as e:
            print(f"✗ Error reading Player.tscn: {e}")
    else:
        print("✗ Player.tscn not found")
    
    # Test PlayerBullet.tscn
    bullet_scene = root / "scenes/PlayerBullet.tscn"
    if bullet_scene.exists():
        try:
            with open(bullet_scene, 'r') as f:
                content = f.read()
            
            if 'type="Area2D"' in content:
                print("✓ PlayerBullet.tscn - Area2D root")
            else:
                print("✗ PlayerBullet.tscn - Wrong root type")
                
        except Exception as e:
            print(f"✗ Error reading PlayerBullet.tscn: {e}")
    else:
        print("✗ PlayerBullet.tscn not found")

if __name__ == "__main__":
    main()
