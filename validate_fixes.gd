extends SceneTree

func _init():
	print("=== Validating Parse Error Fixes ===")
	
	# Test SpriteGenerator
	print("Testing SpriteGenerator...")
	var sprite_gen = preload("res://scripts/SpriteGenerator.gd")
	if sprite_gen:
		print("✅ SpriteGenerator loads successfully")
		
		# Test bullet sprite creation
		var bullet_texture = sprite_gen.create_bullet_sprite()
		if bullet_texture:
			print("✅ create_bullet_sprite() works")
		else:
			print("❌ create_bullet_sprite() failed")
	else:
		print("❌ SpriteGenerator failed to load")
	
	# Test EnemyManager
	print("Testing EnemyManager...")
	var enemy_manager = preload("res://scripts/EnemyManager.gd")
	if enemy_manager:
		print("✅ EnemyManager loads successfully")
	else:
		print("❌ EnemyManager failed to load")
	
	# Test other dependent scripts
	var scripts_to_test = [
		"res://scripts/Main.gd",
		"res://scripts/Player.gd", 
		"res://scripts/PlayerBullet.gd",
		"res://scripts/Enemy.gd"
	]
	
	for script_path in scripts_to_test:
		var script = load(script_path)
		if script:
			print("✅ " + script_path + " loads successfully")
		else:
			print("❌ " + script_path + " failed to load")
	
	print("=== Validation Complete ===")
	quit()
