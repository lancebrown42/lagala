extends Node2D

# Enemy Manager - Handles enemy spawning, formations, and wave management
class_name EnemyManager

# Enemy spawning
@export var enemy_scene: PackedScene
@export var enemies_per_wave: int = 12
@export var formation_rows: int = 3
@export var formation_cols: int = 4

# Formation positioning
@export var formation_start_x: float = 100.0   # Left edge of formation (moved more to center)
@export var formation_start_y: float = 80.0    # Top of formation (moved down a bit)
@export var enemy_spacing: Vector2 = Vector2(80, 60)  # Increased spacing

# Formation movement
var formation_descent_timer: float = 0.0
var formation_descent_speed: float = 10.0  # How fast formation moves down
var formation_descent_interval: float = 15.0  # Every 15 seconds, move formation down

# Enemy entrance patterns
var entrance_patterns: Array[Array] = []
var current_entrance_index: int = 0

# Wave management
var current_wave: int = 1
var enemies_alive: Array[Enemy] = []
var wave_complete: bool = false
var spawn_delay: float = 0.5  # Delay between enemy spawns
var spawn_timer: float = 0.0
var enemies_to_spawn: int = 0
var spawn_queue: Array[Dictionary] = []

# Screen size
var screen_size: Vector2

# Signals
signal wave_complete_signal(wave_number: int)
signal enemy_destroyed_signal(points: int)
signal all_enemies_destroyed

func _ready():
	# print("EnemyManager initialized")  # DEBUG DISABLED
	screen_size = get_viewport().get_visible_rect().size
	
	# Initialize wave state properly
	wave_complete = true  # Start with wave complete so no premature completion
	current_wave = 0      # Start at wave 0, will be set to 1 when game starts
	
	# Load enemy scene if not already set
	if not enemy_scene:
		# print("Loading Enemy scene...")  # DEBUG DISABLED
		enemy_scene = load("res://scenes/Enemy.tscn")
		if not enemy_scene:
			print("ERROR: Could not load Enemy scene!")  # Keep error messages
			print("Attempting to create a fallback enemy scene...")
			create_fallback_enemy_scene()
		else:
			print("Enemy scene loaded successfully")
			print("Enemy scene resource path: ", enemy_scene.resource_path)

func _process(delta):
	handle_spawning(delta)
	check_wave_completion()
	handle_formation_descent(delta)

func start_wave(wave_number: int = 1):
	"""Start a new wave of enemies"""
	# DEBUG DISABLED - Minimal output only
	# print("=== EnemyManager.start_wave() called with wave ", wave_number, " ===")
	
	current_wave = wave_number
	wave_complete = false
	
	print("Starting wave ", current_wave)  # Keep essential message
	# print("Resetting wave_complete flag to: ", wave_complete)  # DEBUG DISABLED
	
	# Clear any existing enemies
	clear_all_enemies()
	
	# Generate formation positions
	generate_formation_positions()
	
	# Start spawning enemies
	enemies_to_spawn = spawn_queue.size()
	spawn_timer = 0.0
	
	# DEBUG DISABLED
	# print("Wave ", current_wave, " will spawn ", enemies_to_spawn, " enemies")
	# print("Spawn queue has ", spawn_queue.size(), " positions")
	# print("Enemy scene loaded: ", enemy_scene != null)
	# print("=== END start_wave setup ===")

func generate_formation_positions():
	"""Generate the classic Galaga formation positions"""
	spawn_queue.clear()
	entrance_patterns.clear()
	
	# DEBUG DISABLED - Minimal output only
	# print("Generating formation positions...")
	
	# Create formation grid with enemy types
	var formation_data: Array[Dictionary] = []
	
	for row in range(formation_rows):
		for col in range(formation_cols):
			var x_pos = formation_start_x + (col * enemy_spacing.x)
			var y_pos = formation_start_y + (row * enemy_spacing.y)
			
			# Make sure enemies stay on screen
			x_pos = clamp(x_pos, 50, screen_size.x - 50)
			y_pos = clamp(y_pos, 50, screen_size.y / 2)  # Keep in upper half
			
			# Add some variation to make it look more organic
			x_pos += randf_range(-5, 5)
			y_pos += randf_range(-5, 5)
			
			# Determine enemy type based on row
			var enemy_type = 0  # Default bee type
			var enemy_points = 100
			if row == 0:  # Top row - boss enemies
				enemy_type = 1
				enemy_points = 400
			elif row >= formation_rows - 1:  # Bottom row - small enemies
				enemy_type = 2
				enemy_points = 50
			
			var enemy_data = {
				"position": Vector2(x_pos, y_pos),
				"type": enemy_type,
				"points": enemy_points,
				"row": row,
				"col": col
			}
			
			formation_data.append(enemy_data)
	
	# Generate classic Galaga entrance patterns
	generate_entrance_patterns(formation_data)
	
	# print("Generated ", formation_data.size(), " formation positions")  # DEBUG DISABLED

func generate_entrance_patterns(formation_data: Array[Dictionary]):
	"""Generate classic Galaga-style entrance patterns"""
	# Pattern 1: Side sweeps (left and right alternating)
	var left_sweep: Array[Dictionary] = []
	var right_sweep: Array[Dictionary] = []
	
	for enemy in formation_data:
		if enemy.col % 2 == 0:
			left_sweep.append(enemy)
		else:
			right_sweep.append(enemy)
	
	# Pattern 2: Center out
	var center_out: Array[Dictionary] = []
	formation_data.sort_custom(func(a, b): return abs(a.col - formation_cols/2) < abs(b.col - formation_cols/2))
	center_out = formation_data.duplicate()
	
	# Pattern 3: Top to bottom waves
	var wave_pattern: Array[Dictionary] = []
	formation_data.sort_custom(func(a, b): return a.row < b.row)
	wave_pattern = formation_data.duplicate()
	
	# Store patterns
	entrance_patterns = [left_sweep, right_sweep, center_out, wave_pattern]
	
	# Use the first pattern for this wave
	current_entrance_index = 0
	spawn_queue = entrance_patterns[current_entrance_index].duplicate()

func handle_spawning(delta):
	"""Handle the spawning of enemies with delays"""
	if enemies_to_spawn <= 0:
		return
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_delay:
		print("Spawning enemy... (", enemies_to_spawn, " remaining)")
		spawn_next_enemy()
		spawn_timer = 0.0

func spawn_next_enemy():
	"""Spawn the next enemy in the queue with entrance animation"""
	# DEBUG DISABLED - Minimal output only
	# print("spawn_next_enemy() called")
	
	if spawn_queue.is_empty():
		print("ERROR: Spawn queue is empty!")
		return
		
	if not enemy_scene:
		print("ERROR: Enemy scene is null!")
		enemy_scene = load("res://scenes/Enemy.tscn")
		if not enemy_scene:
			print("ERROR: Still could not load enemy scene!")
			return
	
	# Get the enemy data
	var enemy_data = spawn_queue.pop_front()
	# print("Spawning enemy at formation position: ", enemy_data.position)  # DEBUG DISABLED
	
	# Create enemy
	var enemy = enemy_scene.instantiate()
	
	if not enemy:
		print("ERROR: Failed to instantiate enemy!")
		return
	
	# Set enemy properties based on data
	enemy.enemy_type = enemy_data.type
	enemy.points = enemy_data.points
	enemy.formation_position = enemy_data.position
	
	# Set entrance position (off-screen)
	var entrance_pos = get_entrance_position(enemy_data)
	enemy.position = entrance_pos
	
	# Add to scene
	add_child(enemy)
	enemies_alive.append(enemy)
	
	# Connect signals
	if enemy.has_signal("enemy_destroyed"):
		if not enemy.enemy_destroyed.is_connected(_on_enemy_destroyed):
			enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	
	if enemy.has_signal("enemy_hit_player"):
		if not enemy.enemy_hit_player.is_connected(_on_enemy_hit_player):
			enemy.enemy_hit_player.connect(_on_enemy_hit_player)
	
	enemies_to_spawn -= 1

func get_entrance_position(enemy_data: Dictionary) -> Vector2:
	"""Get entrance position for classic Galaga-style entry"""
	var entrance_pos: Vector2
	
	match current_entrance_index:
		0: # Left sweep
			entrance_pos = Vector2(-50, enemy_data.position.y - 100)
		1: # Right sweep  
			entrance_pos = Vector2(screen_size.x + 50, enemy_data.position.y - 100)
		2: # Center out
			entrance_pos = Vector2(screen_size.x / 2, -50)
		_: # Top to bottom waves
			entrance_pos = Vector2(enemy_data.position.x, -50)
	
	return entrance_pos

func check_wave_completion():
	"""Check if the current wave is complete"""
	if wave_complete:
		return
	
	# Remove any destroyed enemies from our tracking
	enemies_alive = enemies_alive.filter(func(enemy): return is_instance_valid(enemy))
	
	# Check if all enemies are destroyed
	if enemies_alive.is_empty() and enemies_to_spawn <= 0:
		complete_wave()

func complete_wave():
	"""Handle wave completion"""
	# DEBUG DISABLED - Minimal output only
	wave_complete = true
	print("Wave ", current_wave, " complete!")  # Keep essential message
	
	emit_signal("wave_complete_signal", current_wave)
	emit_signal("all_enemies_destroyed")
	
	# Start next wave after a delay
	print("Starting next wave in 3 seconds...")  # Keep essential message
	await get_tree().create_timer(3.0).timeout
	print("Starting wave ", current_wave + 1, "...")  # Keep essential message
	start_wave(current_wave + 1)

func clear_all_enemies():
	"""Remove all enemies from the scene"""
	# DEBUG DISABLED - Remove stack trace spam
	# print("=== CLEARING ALL ENEMIES ===")
	# print("WARNING: clear_all_enemies() called!")
	# print("Call stack trace:")
	# print(get_stack())
	# print("Enemies to clear: ", enemies_alive.size())
	
	for enemy in enemies_alive:
		if is_instance_valid(enemy):
			# print("Clearing enemy: ", enemy.name)  # DEBUG DISABLED
			enemy.queue_free()
		# else:
			# print("Invalid enemy found during clear")  # DEBUG DISABLED
	
	enemies_alive.clear()
	# print("Enemies cleared. Array size now: ", enemies_alive.size())  # DEBUG DISABLED
	# print("=== END CLEAR ENEMIES ===")  # DEBUG DISABLED

func get_enemy_count() -> int:
	"""Get the number of enemies currently alive"""
	enemies_alive = enemies_alive.filter(func(enemy): return is_instance_valid(enemy))
	return enemies_alive.size()

func handle_formation_descent(delta):
	"""Gradually move formation down to increase pressure"""
	formation_descent_timer += delta
	if formation_descent_timer >= formation_descent_interval and enemies_alive.size() > 0:
		move_formation_down()
		formation_descent_timer = 0.0

func move_formation_down():
	"""Move the entire formation down by a small amount"""
	formation_start_y += formation_descent_speed
	
	# Update all enemy formation positions
	for enemy in enemies_alive:
		if is_instance_valid(enemy):
			enemy.formation_position.y += formation_descent_speed
	
	print("Formation moved down to y: ", formation_start_y)

func _on_enemy_destroyed(enemy: Enemy, points: int):
	"""Handle enemy destruction"""
	# DEBUG DISABLED - Minimal output only
	# print("=== ENEMY MANAGER: Enemy destroyed ===")
	# print("Enemy: ", enemy.name if enemy else "null")
	# print("Points: ", points)
	# print("Enemies alive before removal: ", enemies_alive.size())
	
	# Remove from tracking
	if enemy in enemies_alive:
		enemies_alive.erase(enemy)
		# print("Enemy removed from tracking")  # DEBUG DISABLED
	# else:
		# print("WARNING: Enemy not found in enemies_alive array")  # DEBUG DISABLED
	
	# print("Enemies alive after removal: ", enemies_alive.size())  # DEBUG DISABLED
	
	# Check if wave is complete
	if enemies_alive.size() == 0 and not wave_complete:
		print("Wave ", current_wave, " complete!")  # Keep wave completion message
		complete_wave()
	
	# Emit signal for score system
	emit_signal("enemy_destroyed_signal", points)

func _on_enemy_hit_player(enemy: Enemy):
	"""Handle enemy hitting the player"""
	print("Enemy hit player!")
	
	# Remove from tracking (enemy will destroy itself)
	if enemy in enemies_alive:
		enemies_alive.erase(enemy)

func pause_enemies():
	"""Pause all enemy movement"""
	for enemy in enemies_alive:
		if is_instance_valid(enemy):
			enemy.set_physics_process(false)

func resume_enemies():
	"""Resume all enemy movement"""
	for enemy in enemies_alive:
		if is_instance_valid(enemy):
			enemy.set_physics_process(true)

func create_fallback_enemy_scene():
	"""Create a simple fallback enemy scene if loading fails"""
	print("Creating fallback enemy scene...")
	
	# This is a last resort - create a minimal enemy programmatically
	var packed_scene = PackedScene.new()
	
	# Create the enemy node structure
	var enemy_node = CharacterBody2D.new()
	enemy_node.name = "Enemy"
	enemy_node.set_script(load("res://scripts/Enemy.gd"))
	
	# Add sprite
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	sprite.modulate = Color(1, 0.2, 0.2, 1)
	sprite.texture = load("res://icon.svg")
	sprite.scale = Vector2(0.375, 0.375)
	enemy_node.add_child(sprite)
	
	# Add Area2D for collision
	var area = Area2D.new()
	area.name = "Area2D"
	enemy_node.add_child(area)
	
	# Add collision shape to Area2D
	var collision_shape = CollisionShape2D.new()
	collision_shape.name = "CollisionShape2D"
	var shape = RectangleShape2D.new()
	shape.size = Vector2(24, 24)
	collision_shape.shape = shape
	area.add_child(collision_shape)
	
	# Add collision shape to CharacterBody2D
	var collision_shape2 = CollisionShape2D.new()
	collision_shape2.name = "CollisionShape2D2"
	collision_shape2.shape = shape
	enemy_node.add_child(collision_shape2)
	
	# Pack the scene
	packed_scene.pack(enemy_node)
	enemy_scene = packed_scene
	
	print("Fallback enemy scene created successfully")
