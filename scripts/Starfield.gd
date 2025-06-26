extends Node2D

# Scrolling Starfield Background
class_name Starfield

@export var star_count: int = 50  # Reduced from 100 to 50 for less visual noise
@export var scroll_speed: float = 30.0
@export var max_star_size: int = 1  # Reduced from 2 to 1 for smaller stars

var stars: Array[Dictionary] = []
var screen_size: Vector2

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	generate_stars()

func generate_stars():
	"""Generate initial star field"""
	stars.clear()
	
	for i in range(star_count):
		var star = {
			"position": Vector2(
				randf() * screen_size.x,
				randf() * screen_size.y
			),
			"size": 1,  # All stars are now size 1 (single pixel)
			"brightness": randf_range(0.2, 0.7),  # Reduced brightness range for subtlety
			"speed_multiplier": randf_range(0.5, 2.0)
		}
		stars.append(star)

func _process(delta):
	"""Update star positions"""
	for star in stars:
		# Move star down
		star.position.y += scroll_speed * star.speed_multiplier * delta
		
		# Wrap around when star goes off bottom
		if star.position.y > screen_size.y + 10:
			star.position.y = -10
			star.position.x = randf() * screen_size.x
			# Randomize properties for variety
			star.brightness = randf_range(0.3, 1.0)
			star.speed_multiplier = randf_range(0.5, 2.0)
	
	queue_redraw()

func _draw():
	"""Draw the starfield"""
	for star in stars:
		var color = Color(1.0, 1.0, 1.0, star.brightness)
		var pos = star.position
		var size = star.size
		
		# Draw star based on size
		if size == 1:
			draw_circle(pos, 1, color)
		else:
			# Larger stars get a cross pattern
			draw_circle(pos, size, color)
			draw_line(
				Vector2(pos.x - size - 1, pos.y), 
				Vector2(pos.x + size + 1, pos.y), 
				color, 1
			)
			draw_line(
				Vector2(pos.x, pos.y - size - 1), 
				Vector2(pos.x, pos.y + size + 1), 
				color, 1
			)
