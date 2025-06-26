#!/usr/bin/env python3

"""
Lagala Phase 1 Project Validator
Validates project structure and basic syntax without running Godot
"""

import os
import re
from pathlib import Path

def main():
    print("=== LAGALA PHASE 1 PROJECT VALIDATOR ===")
    
    project_root = Path.cwd()
    print(f"Project root: {project_root}")
    
    # Test 1: Project structure
    test_project_structure(project_root)
    
    # Test 2: Required files
    test_required_files(project_root)
    
    # Test 3: Basic GDScript syntax
    test_gdscript_syntax(project_root)
    
    # Test 4: Project configuration
    test_project_config(project_root)
    
    print("=== VALIDATION COMPLETE ===")

def test_project_structure(root):
    print("\nTest 1: Project Structure")
    
    required_dirs = [
        "assets",
        "assets/sprites", 
        "assets/sprites/player",
        "assets/sprites/enemies",
        "assets/sprites/bullets",
        "assets/sprites/effects",
        "assets/sounds",
        "assets/fonts",
        "scenes",
        "scripts"
    ]
    
    for dir_path in required_dirs:
        full_path = root / dir_path
        if full_path.exists():
            print(f"✓ {dir_path}/")
        else:
            print(f"✗ {dir_path}/ - Missing")

def test_required_files(root):
    print("\nTest 2: Required Files")
    
    required_files = [
        "project.godot",
        "scenes/Main.tscn",
        "scripts/GameManager.gd",
        "scripts/Main.gd",
        "scripts/GameLoop.gd",
        "scripts/TestRunner.gd",
        "README.md"
    ]
    
    for file_path in required_files:
        full_path = root / file_path
        if full_path.exists():
            print(f"✓ {file_path}")
        else:
            print(f"✗ {file_path} - Missing")

def test_gdscript_syntax(root):
    print("\nTest 3: Basic GDScript Syntax Check")
    
    script_files = [
        "scripts/GameManager.gd",
        "scripts/Main.gd", 
        "scripts/GameLoop.gd",
        "scripts/TestRunner.gd"
    ]
    
    for script_path in script_files:
        full_path = root / script_path
        if full_path.exists():
            try:
                with open(full_path, 'r') as f:
                    content = f.read()
                
                # Basic syntax checks
                issues = []
                
                # Check for extends statement
                if not re.search(r'extends\s+\w+', content):
                    issues.append("Missing extends statement")
                
                # Check for balanced braces
                open_braces = content.count('{')
                close_braces = content.count('}')
                if open_braces != close_braces:
                    issues.append(f"Unbalanced braces: {open_braces} open, {close_braces} close")
                
                # Check for balanced parentheses in function definitions
                func_matches = re.findall(r'func\s+\w+\([^)]*\)', content)
                
                if issues:
                    print(f"⚠ {script_path} - Issues: {', '.join(issues)}")
                else:
                    print(f"✓ {script_path} - Basic syntax OK")
                    
            except Exception as e:
                print(f"✗ {script_path} - Error reading file: {e}")
        else:
            print(f"✗ {script_path} - File not found")

def test_project_config(root):
    print("\nTest 4: Project Configuration")
    
    config_path = root / "project.godot"
    if config_path.exists():
        try:
            with open(config_path, 'r') as f:
                content = f.read()
            
            checks = [
                ("Application name", r'config/name="Lagala"'),
                ("Main scene", r'run/main_scene="res://scenes/Main.tscn"'),
                ("Window width", r'window/size/viewport_width=640'),
                ("Window height", r'window/size/viewport_height=480'),
                ("Move left input", r'move_left='),
                ("Move right input", r'move_right='),
                ("Shoot input", r'shoot=')
            ]
            
            for check_name, pattern in checks:
                if re.search(pattern, content):
                    print(f"✓ {check_name} configured")
                else:
                    print(f"✗ {check_name} not found")
                    
        except Exception as e:
            print(f"✗ Error reading project.godot: {e}")
    else:
        print("✗ project.godot not found")

if __name__ == "__main__":
    main()
