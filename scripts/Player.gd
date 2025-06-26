extends CharacterBody2D

# Player Ship - Handles movement, shooting, and player interactions
class_name Player

# Movement properties
@export var speed: float = 200.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

# Shooting properties
@export var bullet_speed: float = 400.0
@export var fire_rate: float = 0.3  # Time between shots
@export var max_bullets: int = 3     # Max bullets on screen

# Screen boundaries
var screen_size: Vector2
var ship_width: float = 32.0  # Will be updated based on sprite

# Shooting system
var can_shoot: bool = true
var shoot_timer: float = 0.0
var active_bullets: Array[Node] = []

# Bullet scene reference
var bullet_scene = preload("res://scenes/PlayerBullet.tscn")

# Signals
signal player_shot
signal player_hit
signal bullet_fired(bullet_position: Vector2)

func _ready():
	print("Player ship initialized")
	
	# Add player to group for collision detection
	add_to_group("player")
	
	# Get screen size
	screen_size = get_viewport().get_visible_rect().size
	print("Screen size: ", screen_size)
	
	# Set initial position (bottom center of screen)
	position = Vector2(screen_size.x / 2, screen_size.y - 50)
	
	# Update ship width based on sprite (if available)
	var sprite = get_node("Sprite2D") if has_node("Sprite2D") else null
	if sprite and sprite.texture:
		ship_width = sprite.texture.get_width()

func _physics_process(delta):
	handle_movement(delta)
	handle_shooting(delta)
	enforce_boundaries()
	
	# Move the character
	move_and_slide()

func handle_movement(delta):
	"""Handle player ship movement"""
	var input_direction = 0.0
	
	# Get input
	if Input.is_action_pressed("move_left"):
		input_direction -= 1.0
	if Input.is_action_pressed("move_right"):
		input_direction += 1.0
	
	# Apply movement with acceleration/friction
	if input_direction != 0.0:
		velocity.x = move_toward(velocity.x, input_direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

func handle_shooting(delta):
	"""Handle player shooting mechanics"""
	# Update shoot timer
	if shoot_timer > 0:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true
	
	# Check for shoot input
	if Input.is_action_just_pressed("shoot") and can_shoot and active_bullets.size() < max_bullets:
		shoot()

func shoot():
	"""Fire a bullet"""
	if not bullet_scene:
		print("Warning: Bullet scene not loaded")
		return
	
	# Create bullet
	var bullet = bullet_scene.instantiate()
	
	# Position bullet at ship's position (slightly above)
	bullet.position = position + Vector2(0, -20)
	
	# Add bullet to scene
	get_parent().add_child(bullet)
	
	# Track the bullet
	active_bullets.append(bullet)
	
	# Connect bullet signals
	if bullet.has_signal("bullet_destroyed"):
		bullet.bullet_destroyed.connect(_on_bullet_destroyed)
	
	# Set shoot cooldown
	can_shoot = false
	shoot_timer = fire_rate
	
	# Emit signals
	emit_signal("player_shot")
	emit_signal("bullet_fired", bullet.position)
	
	print("Player fired bullet at: ", bullet.position)

func enforce_boundaries():
	"""Keep player within screen boundaries"""
	var half_width = ship_width / 2
	position.x = clamp(position.x, half_width, screen_size.x - half_width)

func take_damage():
	"""Handle player taking damage"""
	emit_signal("player_hit")
	print("Player hit!")

func _on_bullet_destroyed(bullet):
	"""Remove bullet from active bullets list"""
	if bullet in active_bullets:
		active_bullets.erase(bullet)

func get_active_bullet_count() -> int:
	"""Get number of active bullets"""
	return active_bullets.size()

func reset_position():
	"""Reset player to starting position"""
	position = Vector2(screen_size.x / 2, screen_size.y - 50)
	velocity = Vector2.ZERO
