extends CharacterBody2D

# Enemy Ship - Basic enemy with movement and health
class_name Enemy

# Enemy properties
@export var health: int = 1
@export var speed: float = 50.0
@export var points: int = 100  # Points awarded when destroyed

# Destruction safety
var is_being_destroyed: bool = false

# Movement properties
@export var formation_position: Vector2 = Vector2.ZERO
@export var movement_pattern: String = "formation"  # "formation", "diving", "circling"

# Enemy state
enum EnemyState {
	FORMING_UP,      # Moving to formation position
	IN_FORMATION,    # Sitting in formation
	DIVING,          # Diving attack
	RETURNING        # Returning to formation
}

var current_state: EnemyState = EnemyState.FORMING_UP
var original_formation_pos: Vector2
var dive_target: Vector2
var state_timer: float = 0.0

# Screen boundaries
var screen_size: Vector2

# Signals
signal enemy_destroyed(enemy: Enemy, points: int)
signal enemy_hit_player(enemy: Enemy)

func _ready():
	# print("Enemy initialized: ", name)  # DEBUG DISABLED
	
	# Set up sprite
	setup_sprite()
	
	# Get screen size
	screen_size = get_viewport().get_visible_rect().size
	
	# Set up collision detection
	call_deferred("setup_collision")
	
	# DEBUG DISABLED - tree_exiting.connect(_on_tree_exiting)

# DEBUG DISABLED
# func _on_tree_exiting():
#	"""Called when enemy is about to be removed from scene"""
#	print("=== ENEMY BEING REMOVED FROM SCENE ===")
#	print("Enemy name: ", name)
#	print("Enemy position: ", position)
#	print("Removal reason: ", "destroy() called" if is_being_destroyed else "unknown")

func setup_sprite():
	"""Set up the enemy sprite"""
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		if SpriteGenerator:
			var enemy_texture = SpriteGenerator.create_enemy_sprite()
			sprite.texture = enemy_texture
			# print("Enemy sprite set up with SpriteGenerator")  # DEBUG DISABLED
		else:
			# Fallback: create a simple colored rectangle
			var image = Image.create(24, 24, false, Image.FORMAT_RGBA8)
			image.fill(Color(1, 0.2, 0.2, 1))  # Red color
			var fallback_texture = ImageTexture.new()
			fallback_texture.set_image(image)
			sprite.texture = fallback_texture
			# print("Enemy sprite set up with fallback texture")  # DEBUG DISABLED

func setup_collision():
	"""Set up collision detection"""
	if has_node("Area2D"):
		var area = get_node("Area2D")
		if not area.body_entered.is_connected(_on_body_entered):
			area.body_entered.connect(_on_body_entered)
		# Removed area_entered connection - PlayerBullet handles bullet collisions
		# print("Enemy collision set up (body collision only)")  # DEBUG DISABLED
	else:
		print("WARNING: Enemy Area2D not found!")  # Keep this warning

func _physics_process(delta):
	handle_movement(delta)
	update_state(delta)
	
	# Move the enemy
	move_and_slide()
	
	# Check if enemy reached bottom of screen (threatens player)
	if position.y > screen_size.y - 10:
		# Enemy reached bottom - this should damage player
		emit_signal("enemy_hit_player", self)
		destroy()  # Enemy is destroyed after hitting bottom
		return
	
	# Check if enemy has moved way off screen (cleanup)
	if position.y > screen_size.y + 100:
		queue_free()

func handle_movement(delta):
	"""Handle enemy movement based on current state"""
	match current_state:
		EnemyState.FORMING_UP:
			move_to_formation(delta)
		EnemyState.IN_FORMATION:
			formation_movement(delta)
		EnemyState.DIVING:
			diving_movement(delta)
		EnemyState.RETURNING:
			return_to_formation(delta)

func move_to_formation(delta):
	"""Move enemy to their formation position"""
	var formation_direction = (formation_position - position).normalized()
	velocity = formation_direction * speed * 2.0  # Move faster when forming up
	
	# Check if we've reached formation
	if position.distance_to(formation_position) < 10.0:
		current_state = EnemyState.IN_FORMATION
		velocity = Vector2.ZERO
		original_formation_pos = formation_position

func formation_movement(delta):
	"""Gentle swaying movement while in formation"""
	state_timer += delta
	
	# More dynamic swaying with both horizontal and vertical movement
	var horizontal_sway = sin(state_timer * 2.0) * 15.0  # Increased from 10.0
	var vertical_sway = cos(state_timer * 1.5) * 8.0     # Added vertical component
	
	position.x = formation_position.x + horizontal_sway
	position.y = formation_position.y + vertical_sway
	velocity = Vector2.ZERO

func diving_movement(delta):
	"""Diving attack movement"""
	var dive_direction = (dive_target - position).normalized()
	velocity = dive_direction * speed * 4.0  # Increased from 3.0 - faster dives
	
	# Check if dive is complete (reached bottom or target)
	if position.y > screen_size.y - 20 or position.distance_to(dive_target) < 20.0:  # Changed from -50 to -20
		current_state = EnemyState.RETURNING
		dive_target = original_formation_pos

func return_to_formation(delta):
	"""Return to formation after diving"""
	var return_direction = (original_formation_pos - position).normalized()
	velocity = return_direction * speed * 1.5
	
	# Check if we've returned to formation
	if position.distance_to(original_formation_pos) < 15.0:
		current_state = EnemyState.IN_FORMATION
		formation_position = original_formation_pos

func update_state(delta):
	"""Update enemy state and timers"""
	state_timer += delta
	
	# Random chance to start diving (only if in formation)
	if current_state == EnemyState.IN_FORMATION and randf() < 0.005:  # Increased from 0.001 - 5x more frequent dives
		start_dive()

func start_dive():
	"""Initiate a diving attack"""
	current_state = EnemyState.DIVING
	
	# Pick a random target near the bottom of the screen - go much deeper!
	dive_target = Vector2(
		randf_range(50, screen_size.x - 50),
		screen_size.y - 30  # Changed from -100 to -30, much closer to bottom
	)
	
	# print("Enemy starting dive attack to: ", dive_target)  # DEBUG DISABLED

func take_damage(damage: int = 1):
	"""Take damage and handle destruction"""
	if is_being_destroyed:
		# print("Enemy already being destroyed, ignoring damage")  # DEBUG DISABLED
		return
		
	# DEBUG DISABLED
	# print("=== ENEMY TAKE DAMAGE ===")
	# print("Enemy: ", name)
	# print("Damage received: ", damage)
	# print("Health before: ", health)
	
	health -= damage
	# print("Health after: ", health)  # DEBUG DISABLED
	
	if health <= 0:
		# print("Enemy health <= 0, calling destroy()")  # DEBUG DISABLED
		destroy()
	# else:
		# print("Enemy still alive with health: ", health)  # DEBUG DISABLED
	
	# print("=== END TAKE DAMAGE ===")  # DEBUG DISABLED

func destroy():
	"""Destroy the enemy and award points"""
	if is_being_destroyed:
		# print("Enemy already being destroyed, ignoring duplicate destroy call")  # DEBUG DISABLED
		return
		
	is_being_destroyed = true
	# DEBUG DISABLED
	# print("=== ENEMY DESTROY CALLED ===")
	# print("Enemy position: ", position)
	# print("Enemy name: ", name)
	
	emit_signal("enemy_destroyed", self, points)
	# print("enemy_destroyed signal emitted with points: ", points)  # DEBUG DISABLED
	
	# TODO: Add explosion effect here
	
	# print("About to queue_free() enemy")  # DEBUG DISABLED
	queue_free()
	# print("Enemy queued for deletion")  # DEBUG DISABLED

func set_formation_position(pos: Vector2):
	"""Set the enemy's formation position"""
	formation_position = pos
	original_formation_pos = pos

func _on_body_entered(body):
	"""Handle collision with player"""
	if body.is_in_group("player"):
		# Call player's take_damage method for proper hit handling
		if body.has_method("take_damage"):
			body.take_damage()
		
		# Emit signal for any additional handling
		emit_signal("enemy_hit_player", self)
		
		# Enemy is destroyed when hitting player
		destroy()

# Removed _on_area_entered - PlayerBullet handles bullet collisions to avoid duplicate processing
