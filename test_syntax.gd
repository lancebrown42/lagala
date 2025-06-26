#!/usr/bin/env -S godot --headless --script

# Syntax validation script for Lagala Phase 1

extends SceneTree

func _init():
	print("=== LAGALA PHASE 1 SYNTAX TEST ===")
	
	# Test script loading
	test_script_syntax()
	
	# Test scene loading
	test_scene_loading()
	
	print("=== SYNTAX TESTS COMPLETE ===")
	quit()

func test_script_syntax():
	print("Testing GDScript syntax...")
	
	var scripts_to_test = [
		"res://scripts/GameManager.gd",
		"res://scripts/Main.gd", 
		"res://scripts/GameLoop.gd",
		"res://scripts/TestRunner.gd"
	]
	
	for script_path in scripts_to_test:
		var script = load(script_path)
		if script:
			print("✓ " + script_path + " - Syntax OK")
		else:
			print("✗ " + script_path + " - Syntax Error or File Missing")

func test_scene_loading():
	print("Testing scene loading...")
	
	var scene = load("res://scenes/Main.tscn")
	if scene:
		print("✓ Main.tscn - Scene loads successfully")
		
		# Try to instantiate the scene
		var instance = scene.instantiate()
		if instance:
			print("✓ Main.tscn - Scene instantiates successfully")
			instance.queue_free()
		else:
			print("✗ Main.tscn - Scene instantiation failed")
	else:
		print("✗ Main.tscn - Scene loading failed")
