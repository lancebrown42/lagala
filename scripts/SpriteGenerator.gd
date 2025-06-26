extends Node

# Enhanced Sprite Generator for retro-style game graphics
class_name SpriteGenerator

static func create_player_sprite() -> ImageTexture:
	"""Create a detailed player ship sprite"""
	var image = Image.create(32, 24, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Ship body (blue-white gradient)
	var ship_color = Color(0.8, 0.9, 1.0, 1.0)  # Light blue-white
	var accent_color = Color(0.2, 0.5, 1.0, 1.0)  # Bright blue
	var engine_color = Color(1.0, 0.4, 0.0, 1.0)  # Orange
	
	# Main ship body (triangular)
	for y in range(8, 24):
		var width = int((24 - y) * 0.8)
		var start_x = 16 - width / 2
		var end_x = 16 + width / 2
		for x in range(start_x, end_x):
			if x >= 0 and x < 32:
				image.set_pixel(x, y, ship_color)
	
	# Wing details
	for y in range(12, 20):
		image.set_pixel(4, y, accent_color)
		image.set_pixel(27, y, accent_color)
		image.set_pixel(8, y, accent_color)
		image.set_pixel(23, y, accent_color)
	
	# Cockpit
	for y in range(8, 12):
		for x in range(14, 18):
			image.set_pixel(x, y, accent_color)
	
	# Engine glow
	for x in range(12, 20):
		image.set_pixel(x, 23, engine_color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

static func create_enemy_sprite(enemy_type: int = 0) -> ImageTexture:
	"""Create detailed enemy sprites with different types - 48x48 for better visibility"""
	var image = Image.create(48, 48, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	match enemy_type:
		0: # Bee-type enemy (yellow/orange) - scaled 2x
			var body_color = Color(1.0, 0.8, 0.2, 1.0)  # Yellow
			var accent_color = Color(1.0, 0.4, 0.0, 1.0)  # Orange
			var eye_color = Color(0.8, 0.0, 0.0, 1.0)  # Red
			
			# Body (oval) - scaled from 6-18 to 12-36
			for y in range(12, 36):
				var width = int(24 - abs(y - 24) * 0.5)
				var start_x = 24 - width / 2
				var end_x = 24 + width / 2
				for x in range(start_x, end_x):
					image.set_pixel(x, y, body_color)
			
			# Wings - scaled positions
			for y in range(16, 32):
				image.set_pixel(8, y, accent_color)
				image.set_pixel(38, y, accent_color)
				image.set_pixel(12, y, accent_color)
				image.set_pixel(34, y, accent_color)
			
			# Eyes - scaled positions
			for dy in range(2):
				for dx in range(2):
					image.set_pixel(18 + dx, 20 + dy, eye_color)
					image.set_pixel(28 + dx, 20 + dy, eye_color)
			
		1: # Boss-type enemy (red/purple) - scaled 2x
			var body_color = Color(0.8, 0.2, 0.2, 1.0)  # Red
			var accent_color = Color(0.6, 0.1, 0.6, 1.0)  # Purple
			var detail_color = Color(1.0, 0.8, 0.0, 1.0)  # Gold
			
			# Larger body - scaled from 4-20 to 8-40
			for y in range(8, 40):
				var width = int(32 - abs(y - 24) * 0.3)
				var start_x = 24 - width / 2
				var end_x = 24 + width / 2
				for x in range(start_x, end_x):
					image.set_pixel(x, y, body_color)
			
			# Details - scaled positions
			for y in range(16, 32):
				for dx in range(2):
					image.set_pixel(24 + dx, y, detail_color)
				if y % 4 == 0:
					for dx in range(2):
						image.set_pixel(16 + dx, y, accent_color)
						image.set_pixel(30 + dx, y, accent_color)
		
		_: # Default small enemy (green) - scaled 2x
			var body_color = Color(0.2, 0.8, 0.3, 1.0)  # Green
			var accent_color = Color(0.0, 0.6, 0.2, 1.0)  # Dark green
			
			# Simple body - scaled from 8-16 to 16-32
			for y in range(16, 32):
				for x in range(16, 32):
					image.set_pixel(x, y, body_color)
			
			# Accent lines - scaled positions
			for x in range(16, 32):
				image.set_pixel(x, 20, accent_color)
				image.set_pixel(x, 26, accent_color)
	
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

static func create_bullet_sprite() -> ImageTexture:
	"""Create a glowing bullet sprite"""
	var image = Image.create(4, 8, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	var core_color = Color(1.0, 1.0, 0.8, 1.0)  # Bright white-yellow
	var glow_color = Color(1.0, 0.8, 0.2, 0.8)  # Yellow glow
	
	# Core
	for y in range(1, 7):
		image.set_pixel(1, y, core_color)
		image.set_pixel(2, y, core_color)
	
	# Glow effect
	image.set_pixel(0, 3, glow_color)
	image.set_pixel(3, 3, glow_color)
	image.set_pixel(1, 0, glow_color)
	image.set_pixel(2, 0, glow_color)
	image.set_pixel(1, 7, glow_color)
	image.set_pixel(2, 7, glow_color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

static func create_star_sprite(size: int = 1) -> ImageTexture:
	"""Create star sprites for background"""
	var image_size = size * 2 + 1
	var image = Image.create(image_size, image_size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	var star_color = Color(1.0, 1.0, 1.0, 0.8)
	var center = size
	
	# Simple star pattern
	image.set_pixel(center, center, star_color)
	if size > 1:
		image.set_pixel(center - 1, center, star_color)
		image.set_pixel(center + 1, center, star_color)
		image.set_pixel(center, center - 1, star_color)
		image.set_pixel(center, center + 1, star_color)
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture
