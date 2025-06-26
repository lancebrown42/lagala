extends Node

# Simple test to validate SpriteGenerator
func _ready():
	print("Testing SpriteGenerator...")
	
	# Test if we can access the class
	if SpriteGenerator:
		print("SpriteGenerator class found")
		
		# Test creating sprites
		var player_sprite = SpriteGenerator.create_player_sprite()
		print("Player sprite created: ", player_sprite != null)
		
		var enemy_sprite = SpriteGenerator.create_enemy_sprite(0)
		print("Enemy sprite created: ", enemy_sprite != null)
		
		var bullet_sprite = SpriteGenerator.create_bullet_sprite()
		print("Bullet sprite created: ", bullet_sprite != null)
		
		var star_sprite = SpriteGenerator.create_star_sprite(1)
		print("Star sprite created: ", star_sprite != null)
		
	else:
		print("ERROR: SpriteGenerator class not found!")
