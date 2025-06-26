#!/usr/bin/env python3
"""
Validate Phase 3 implementation fixes
"""

import os
import re

def check_file_exists(filepath):
    """Check if a file exists"""
    return os.path.exists(filepath)

def check_scene_syntax(filepath):
    """Basic syntax check for .tscn files"""
    if not os.path.exists(filepath):
        return False, "File not found"
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Check for basic scene structure
        if not content.startswith('[gd_scene'):
            return False, "Invalid scene header"
            
        # Check for balanced brackets
        if content.count('[') != content.count(']'):
            return False, "Unbalanced brackets"
            
        return True, "Scene syntax OK"
    except Exception as e:
        return False, f"Error reading file: {e}"

def check_script_syntax(filepath):
    """Basic syntax check for .gd files"""
    if not os.path.exists(filepath):
        return False, "File not found"
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
            
        # Check for basic script structure
        if not content.strip().startswith('extends'):
            return False, "Missing extends statement"
            
        # Check for balanced parentheses and brackets
        if content.count('(') != content.count(')'):
            return False, "Unbalanced parentheses"
            
        if content.count('{') != content.count('}'):
            return False, "Unbalanced braces"
            
        return True, "Script syntax OK"
    except Exception as e:
        return False, f"Error reading file: {e}"

def main():
    print("=== PHASE 3 FIXES VALIDATION ===\n")
    
    # Files to check
    files_to_check = [
        ("scripts/Enemy.gd", "script"),
        ("scripts/EnemyManager.gd", "script"),
        ("scripts/Phase3Tester.gd", "script"),
        ("scenes/Enemy.tscn", "scene"),
        ("scenes/EnemySimple.tscn", "scene"),
    ]
    
    all_passed = True
    
    for filepath, file_type in files_to_check:
        full_path = filepath
        print(f"Checking {filepath}...")
        
        if not check_file_exists(full_path):
            print(f"  ❌ File not found: {filepath}")
            all_passed = False
            continue
            
        if file_type == "script":
            passed, message = check_script_syntax(full_path)
        elif file_type == "scene":
            passed, message = check_scene_syntax(full_path)
        else:
            passed, message = True, "Unknown file type"
            
        if passed:
            print(f"  ✅ {message}")
        else:
            print(f"  ❌ {message}")
            all_passed = False
    
    print(f"\n=== VALIDATION SUMMARY ===")
    if all_passed:
        print("🎉 All files passed validation!")
        print("The Phase 3 fixes should resolve the parsing errors.")
    else:
        print("⚠️  Some files failed validation.")
        print("Please check the errors above.")
    
    # Additional checks
    print(f"\n=== ADDITIONAL CHECKS ===")
    
    # Check if EnemyManager loads scene properly
    with open("scripts/EnemyManager.gd", 'r') as f:
        content = f.read()
        if 'load("res://scenes/EnemySimple.tscn")' in content:
            print("✅ EnemyManager uses runtime loading")
        else:
            print("❌ EnemyManager scene loading issue")
    
    # Check if Phase3Tester uses instance method
    with open("scripts/Phase3Tester.gd", 'r') as f:
        content = f.read()
        if 'SpriteGenerator.new()' in content:
            print("✅ Phase3Tester uses instance method")
        else:
            print("❌ Phase3Tester static method issue")

if __name__ == "__main__":
    main()
