#!/usr/bin/env python3
"""
Validate main game scripts for syntax issues
"""

import os
import re

def check_script_syntax(filepath):
    """Check a GDScript file for common syntax issues"""
    if not os.path.exists(filepath):
        return False, f"File not found: {filepath}"
    
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Check for duplicate variable declarations
        lines = content.split('\n')
        variables = {}
        duplicates = []
        
        for i, line in enumerate(lines):
            if line.strip().startswith('@export var ') or line.strip().startswith('var '):
                var_match = re.search(r'(var|@export var)\s+(\w+)', line)
                if var_match:
                    var_name = var_match.group(2)
                    if var_name in variables:
                        duplicates.append(f"Duplicate variable '{var_name}' on lines {variables[var_name]} and {i+1}")
                    else:
                        variables[var_name] = i+1
        
        if duplicates:
            return False, "; ".join(duplicates)
        
        # Check for balanced brackets and parentheses
        if content.count('(') != content.count(')'):
            return False, "Unbalanced parentheses"
        
        if content.count('{') != content.count('}'):
            return False, "Unbalanced braces"
        
        if content.count('[') != content.count(']'):
            return False, "Unbalanced brackets"
        
        # Check for extends statement
        if not content.strip().startswith('extends'):
            return False, "Missing extends statement"
        
        return True, f"OK ({len(variables)} variables found)"
        
    except Exception as e:
        return False, f"Error reading file: {e}"

def main():
    print("=== SCRIPT VALIDATION ===\n")
    
    # Core scripts to check
    scripts = [
        "scripts/Main.gd",
        "scripts/GameManager.gd", 
        "scripts/EnemyManager.gd",
        "scripts/Enemy.gd",
        "scripts/Player.gd",
        "scripts/PlayerBullet.gd"
    ]
    
    all_passed = True
    
    for script in scripts:
        print(f"Checking {script}...")
        passed, message = check_script_syntax(script)
        
        if passed:
            print(f"  ✅ {message}")
        else:
            print(f"  ❌ {message}")
            all_passed = False
    
    print(f"\n=== SUMMARY ===")
    if all_passed:
        print("🎉 All scripts passed validation!")
    else:
        print("⚠️  Some scripts have issues that need fixing.")

if __name__ == "__main__":
    main()
