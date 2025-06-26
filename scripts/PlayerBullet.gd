extends Area2D

# Player Bullet - Projectile fired by the player
class_name PlayerBullet

# Bullet properties
@export var speed: float = 400.0
@export var damage: int = 1

# Movement
var velocity: Vector2 = Vector2(0, -1)  # Move upward
var screen_size: Vector2

# Signals
signal bullet_destroyed(bullet)
signal enemy_hit(enemy, damage)

func _ready():
	print("Player bullet created at: ", position)
	
	# Set up sprite
	setup_sprite()
	
	# Get screen size
	screen_size = get_viewport().get_visible_rect().size
	
	# Set up collision
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Set velocity
	velocity = Vector2(0, -speed)

func setup_sprite():
	"""Set up the bullet sprite"""
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		var texture = SpriteGenerator.create_bullet_sprite()
		sprite.texture = texture

func _physics_process(delta):
	# Move the bullet
	position += velocity * delta
	
	# Check if bullet is off screen
	if position.y < -10:  # Off the top of screen
		destroy_bullet()

func _on_body_entered(body):
	"""Handle collision with bodies (enemies)"""
	if body.has_method("take_damage"):
		body.take_damage(damage)
		emit_signal("enemy_hit", body, damage)
		destroy_bullet()

func _on_area_entered(area):
	"""Handle collision with areas (enemy bullets, etc.)"""
	# DEBUG DISABLED
	# print("=== BULLET COLLISION ===")
	# print("Bullet hit area: ", area.name if area else "null")
	# print("Area parent: ", area.get_parent().name if area and area.get_parent() else "null")
	# print("Area groups: ", area.get_groups() if area else "none")
	
	if area.is_in_group("enemies"):
		# print("Hit confirmed: Enemy area detected")  # DEBUG DISABLED
		# The enemy's Area2D was hit, get the parent Enemy node
		var enemy = area.get_parent()
		# print("Enemy found: ", enemy.name if enemy else "null")  # DEBUG DISABLED
		
		if enemy.has_method("take_damage"):
			# print("Calling enemy.take_damage() with damage: ", damage)  # DEBUG DISABLED
			enemy.take_damage(damage)
			emit_signal("enemy_hit", enemy, damage)
			# print("Enemy hit signal emitted")  # DEBUG DISABLED
		# else:
			# print("ERROR: Enemy doesn't have take_damage method")  # DEBUG DISABLED
		
		# print("About to destroy bullet")  # DEBUG DISABLED
		destroy_bullet()
		# print("Bullet destroyed")  # DEBUG DISABLED
	# else:
		# print("Not an enemy - ignoring collision")  # DEBUG DISABLED
	
	# print("=== END BULLET COLLISION ===")  # DEBUG DISABLED

func destroy_bullet():
	"""Destroy the bullet"""
	emit_signal("bullet_destroyed", self)
	queue_free()

func set_speed(new_speed: float):
	"""Set bullet speed"""
	speed = new_speed
	velocity = Vector2(0, -speed)
