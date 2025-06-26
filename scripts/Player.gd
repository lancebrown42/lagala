extends CharacterBody2D

# Player Ship - Handles movement, shooting, and player interactions
class_name Player

# Movement state for touch controls
var touch_move_left: bool = false
var touch_move_right: bool = false
var touch_shoot: bool = false
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

# Invulnerability system
var is_invulnerable: bool = false
var invulnerability_time: float = 2.0  # 2 seconds of invulnerability
var invulnerability_timer: float = 0.0
var blink_interval: float = 0.1  # How fast to blink during invulnerability
var blink_timer: float = 0.0

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
	
	# Set up collision detection for enemy hits
	setup_hit_detection()
	
	# Set up enhanced sprite
	setup_sprite()
	
	# Update ship width based on sprite (if available)
	var sprite = get_node("Sprite2D") if has_node("Sprite2D") else null
	if sprite and sprite.texture:
		ship_width = sprite.texture.get_width()

func _physics_process(delta):
	handle_movement(delta)
	handle_shooting(delta)
	handle_invulnerability(delta)
	enforce_boundaries()
	
	# Move the character
	move_and_slide()

func handle_movement(delta):
	"""Handle player ship movement"""
	var input_direction = 0.0
	
	# Get input (keyboard + touch)
	if Input.is_action_pressed("move_left") or touch_move_left:
		input_direction -= 1.0
	if Input.is_action_pressed("move_right") or touch_move_right:
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
	
	# Check for shoot input (keyboard + touch)
	if (Input.is_action_just_pressed("shoot") or touch_shoot) and can_shoot and active_bullets.size() < max_bullets:
		shoot()
		touch_shoot = false  # Reset touch shoot to prevent continuous firing

func shoot():
	"""Fire a bullet"""
	if not bullet_scene:
		print("Warning: Bullet scene not loaded")
		return
	
	# Play laser sound
	var audio_manager = AudioManager.get_audio_manager()
	if audio_manager:
		audio_manager.play_laser_sound()
	
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
	
	# print("Player fired bullet at: ", bullet.position)  # DEBUG DISABLED

func enforce_boundaries():
	"""Keep player within screen boundaries"""
	var half_width = ship_width / 2
	position.x = clamp(position.x, half_width, screen_size.x - half_width)

func handle_invulnerability(delta):
	"""Handle invulnerability timer and blinking effect"""
	if is_invulnerable:
		invulnerability_timer -= delta
		blink_timer -= delta
		
		# Blink effect during invulnerability
		if blink_timer <= 0:
			visible = !visible
			blink_timer = blink_interval
		
		# End invulnerability
		if invulnerability_timer <= 0:
			is_invulnerable = false
			visible = true  # Make sure player is visible when invulnerability ends

func take_damage():
	"""Handle player taking damage"""
	print("=== PLAYER TAKE_DAMAGE CALLED ===")
	if is_invulnerable:
		print("Player is invulnerable - ignoring damage")
		return  # Already invulnerable, ignore hit
	
	print("Player hit! Processing damage...")
	
	# Play explosion sound
	var audio_manager = AudioManager.get_audio_manager()
	if audio_manager:
		audio_manager.play_explosion_sound()
	
	# Emit signal for game manager to handle lives
	emit_signal("player_hit")
	print("player_hit signal emitted")
	
	# Start invulnerability
	is_invulnerable = true
	invulnerability_timer = invulnerability_time
	blink_timer = 0.0
	print("Invulnerability started for ", invulnerability_time, " seconds")
	
	# Respawn at center bottom
	respawn_at_center()
	print("=== END PLAYER TAKE_DAMAGE ===")

func respawn_at_center():
	"""Respawn player at center of screen"""
	position = Vector2(screen_size.x / 2, screen_size.y - 60)
	velocity = Vector2.ZERO  # Stop all movement

func _on_bullet_destroyed(bullet):
	"""Remove bullet from active bullets list"""
	if bullet in active_bullets:
		active_bullets.erase(bullet)

func setup_hit_detection():
	"""Set up collision detection for enemy hits"""
	print("Setting up player hit detection...")
	if has_node("HitBox"):
		var hitbox = get_node("HitBox")
		print("HitBox found, connecting signals...")
		if not hitbox.body_entered.is_connected(_on_hit_by_enemy):
			hitbox.body_entered.connect(_on_hit_by_enemy)
			print("body_entered signal connected")
		if not hitbox.area_entered.is_connected(_on_area_hit_by_enemy):
			hitbox.area_entered.connect(_on_area_hit_by_enemy)
			print("area_entered signal connected")
	else:
		print("ERROR: HitBox not found on Player!")

func _on_hit_by_enemy(body):
	"""Handle being hit by enemy body"""
	print("Player hit by enemy body: ", body.name if body else "null")
	if body.is_in_group("enemies"):
		print("Confirmed enemy hit - calling take_damage()")
		take_damage()
	else:
		print("Not an enemy - ignoring hit")

func _on_area_hit_by_enemy(area):
	"""Handle being hit by enemy area"""
	print("Player hit by enemy area: ", area.name if area else "null")
	if area.is_in_group("enemies"):
		print("Confirmed enemy area hit - calling take_damage()")
		take_damage()
	else:
		print("Not an enemy area - ignoring hit")

func get_active_bullet_count() -> int:
	"""Get number of active bullets"""
	return active_bullets.size()

func reset_position():
	"""Reset player to starting position"""
	position = Vector2(screen_size.x / 2, screen_size.y - 50)
	velocity = Vector2.ZERO

func setup_sprite():
	"""Set up the enhanced player sprite"""
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		if SpriteGenerator:
			var player_texture = SpriteGenerator.create_player_sprite()
			sprite.texture = player_texture
			print("Player sprite set up with enhanced SpriteGenerator")
		else:
			print("SpriteGenerator not available - using fallback")
			# Fallback sprite setup
			var image = Image.create(32, 24, false, Image.FORMAT_RGBA8)
			image.fill(Color(0.2, 0.5, 1.0, 1.0))
			var fallback_texture = ImageTexture.new()
			fallback_texture.set_image(image)
			sprite.texture = fallback_texture

# Touch control signal handlers
func _on_move_left_pressed():
	"""Handle touch move left pressed"""
	touch_move_left = true

func _on_move_left_released():
	"""Handle touch move left released"""
	touch_move_left = false

func _on_move_right_pressed():
	"""Handle touch move right pressed"""
	touch_move_right = true

func _on_move_right_released():
	"""Handle touch move right released"""
	touch_move_right = false

func _on_shoot_pressed():
	"""Handle touch shoot pressed"""
	touch_shoot = true

func _on_shoot_released():
	"""Handle touch shoot released"""
	touch_shoot = false
