@tool
extends EditorScript

# Script to create simple placeholder sprites for testing
# Run this in the Godot editor: Tools > Execute Script

func _run():
	print("Creating placeholder sprites...")
	
	create_player_sprite()
	create_bullet_sprite()
	
	print("Placeholder sprites created!")

func create_player_sprite():
	"""Create a simple player ship sprite"""
	var image = Image.create(32, 24, false, Image.FORMAT_RGBA8)
	
	# Fill with blue color for player ship
	image.fill(Color(0.2, 0.5, 1.0, 1.0))  # Light blue
	
	# Add some detail (simple triangle shape)
	for y in range(8, 24):
		for x in range(8, 24):
			if x >= 16 - (y - 8) / 2 and x <= 16 + (y - 8) / 2:
				image.set_pixel(x, y, Color(0.1, 0.3, 0.8, 1.0))  # Darker blue
	
	# Create texture
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	# Save as resource
	ResourceSaver.save(texture, "res://assets/sprites/player/player_ship.tres")
	print("Created player ship sprite")

func create_bullet_sprite():
	"""Create a simple bullet sprite"""
	var image = Image.create(4, 8, false, Image.FORMAT_RGBA8)
	
	# Fill with yellow color for bullet
	image.fill(Color(1.0, 1.0, 0.2, 1.0))  # Bright yellow
	
	# Create texture
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	# Save as resource
	ResourceSaver.save(texture, "res://assets/sprites/bullets/player_bullet.tres")
	print("Created player bullet sprite")
