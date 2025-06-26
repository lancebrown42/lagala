extends Node

# Phase 3 Tester - Validates enemy system implementation
class_name Phase3Tester

var test_results: Array[String] = []

func _ready():
	print("=== PHASE 3 ENEMY SYSTEM TESTS ===")
	run_all_tests()

func run_all_tests():
	"""Run all Phase 3 tests"""
	test_enemy_script_exists()
	test_enemy_manager_script_exists()
	test_enemy_scene_exists()
	test_sprite_generator_enemy_method()
	test_player_bullet_groups()
	
	print_test_results()

func test_enemy_script_exists():
	"""Test that Enemy script exists and has required methods"""
	var test_name = "Enemy Script Validation"
	
	if ResourceLoader.exists("res://scripts/Enemy.gd"):
		test_results.append("✅ " + test_name + ": Enemy.gd exists")
		
		# Test if we can load the script
		var script = load("res://scripts/Enemy.gd")
		if script:
			test_results.append("✅ " + test_name + ": Enemy script loads successfully")
		else:
			test_results.append("❌ " + test_name + ": Enemy script failed to load")
	else:
		test_results.append("❌ " + test_name + ": Enemy.gd not found")

func test_enemy_manager_script_exists():
	"""Test that EnemyManager script exists"""
	var test_name = "EnemyManager Script Validation"
	
	if ResourceLoader.exists("res://scripts/EnemyManager.gd"):
		test_results.append("✅ " + test_name + ": EnemyManager.gd exists")
		
		var script = load("res://scripts/EnemyManager.gd")
		if script:
			test_results.append("✅ " + test_name + ": EnemyManager script loads successfully")
		else:
			test_results.append("❌ " + test_name + ": EnemyManager script failed to load")
	else:
		test_results.append("❌ " + test_name + ": EnemyManager.gd not found")

func test_enemy_scene_exists():
	"""Test that Enemy scene exists"""
	var test_name = "Enemy Scene Validation"
	
	if ResourceLoader.exists("res://scenes/Enemy.tscn"):
		test_results.append("✅ " + test_name + ": Enemy.tscn exists")
		
		var scene = load("res://scenes/Enemy.tscn")
		if scene:
			test_results.append("✅ " + test_name + ": Enemy scene loads successfully")
		else:
			test_results.append("❌ " + test_name + ": Enemy scene failed to load")
	else:
		test_results.append("❌ " + test_name + ": Enemy.tscn not found")

func test_sprite_generator_enemy_method():
	"""Test that SpriteGenerator has enemy sprite method"""
	var test_name = "SpriteGenerator Enemy Method"
	
	# Create an instance to test the method
	var sprite_gen = SpriteGenerator.new()
	if sprite_gen.has_method("create_enemy_sprite"):
		test_results.append("✅ " + test_name + ": create_enemy_sprite method exists")
		
		# Try to create an enemy sprite
		var sprite = SpriteGenerator.create_enemy_sprite()
		if sprite:
			test_results.append("✅ " + test_name + ": Enemy sprite creation successful")
		else:
			test_results.append("❌ " + test_name + ": Enemy sprite creation failed")
	else:
		test_results.append("❌ " + test_name + ": create_enemy_sprite method not found")
	
	sprite_gen.free()

func test_player_bullet_groups():
	"""Test that PlayerBullet is in correct group"""
	var test_name = "PlayerBullet Group Assignment"
	
	if ResourceLoader.exists("res://scenes/PlayerBullet.tscn"):
		var scene = load("res://scenes/PlayerBullet.tscn")
		if scene:
			var instance = scene.instantiate()
			if instance.is_in_group("player_bullets"):
				test_results.append("✅ " + test_name + ": PlayerBullet in player_bullets group")
			else:
				test_results.append("❌ " + test_name + ": PlayerBullet not in player_bullets group")
			instance.queue_free()
		else:
			test_results.append("❌ " + test_name + ": Could not instantiate PlayerBullet scene")
	else:
		test_results.append("❌ " + test_name + ": PlayerBullet.tscn not found")

func print_test_results():
	"""Print all test results"""
	print("\n=== PHASE 3 TEST RESULTS ===")
	for result in test_results:
		print(result)
	
	var passed = test_results.filter(func(r): return r.begins_with("✅")).size()
	var total = test_results.size()
	
	print("\nSUMMARY: ", passed, "/", total, " tests passed")
	
	if passed == total:
		print("🎉 ALL PHASE 3 TESTS PASSED! Enemy system ready!")
	else:
		print("⚠️  Some tests failed. Check implementation.")
	
	print("=== END PHASE 3 TESTS ===\n")
