extends Node

# Sprite Generator - Creates simple placeholder sprites at runtime
class_name SpriteGenerator

static func create_player_sprite() -> ImageTexture:
	"""Create a simple player ship sprite"""
	var image = Image.create(32, 24, false, Image.FORMAT_RGBA8)
	
	# Create a simple ship shape
	image.fill(Color.TRANSPARENT)
	
	# Draw ship body (triangle-ish shape)
	for y in range(24):
		for x in range(32):
			var center_x = 16
			var ship_width = max(2, (24 - y) * 0.8)
			
			if x >= center_x - ship_width/2 and x <= center_x + ship_width/2:
				if y < 8:
					image.set_pixel(x, y, Color(0.8, 0.9, 1.0, 1.0))  # Light blue tip
				else:
					image.set_pixel(x, y, Color(0.2, 0.5, 1.0, 1.0))  # Blue body
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

static func create_bullet_sprite() -> ImageTexture:
	"""Create a simple bullet sprite"""
	var image = Image.create(4, 8, false, Image.FORMAT_RGBA8)
	
	# Create bright yellow bullet
	image.fill(Color(1.0, 1.0, 0.3, 1.0))
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

static func create_simple_rect_sprite(width: int, height: int, color: Color) -> ImageTexture:
	"""Create a simple rectangular sprite"""
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	image.fill(color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture
