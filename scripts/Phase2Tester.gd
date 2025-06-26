extends Node

# Phase 2 Tester - Tests player ship functionality

@onready var player: Player
@onready var game_manager: GameManager

func _ready():
	print("=== PHASE 2 TESTER STARTED ===")
	
	# Find components
	player = get_node("../GameWorld/Player") if get_node("../GameWorld/Player") else null
	game_manager = get_node("../GameManager") if get_node("../GameManager") else null
	
	# Run tests after a short delay to ensure everything is loaded
	await get_tree().create_timer(1.0).timeout
	run_tests()

func run_tests():
	print("Running Phase 2 tests...")
	
	# Test 1: Player existence and setup
	test_player_setup()
	
	# Test 2: Movement system
	test_movement_system()
	
	# Test 3: Shooting system
	test_shooting_system()
	
	# Test 4: Boundary detection
	test_boundary_system()
	
	print("=== PHASE 2 TESTS COMPLETE ===")

func test_player_setup():
	print("\nTest 1: Player Setup")
	
	if player:
		print("✓ Player node found")
		
		# Check player components
		if player.has_node("Sprite2D"):
			print("✓ Player has Sprite2D")
		else:
			print("✗ Player missing Sprite2D")
		
		if player.has_node("CollisionShape2D"):
			print("✓ Player has CollisionShape2D")
		else:
			print("✗ Player missing CollisionShape2D")
		
		# Check player properties
		print("Player speed: ", player.speed)
		print("Player position: ", player.position)
		
	else:
		print("✗ Player node not found")

func test_movement_system():
	print("\nTest 2: Movement System")
	
	if not player:
		print("✗ Cannot test movement - player not found")
		return
	
	# Test input actions
	var movement_actions = ["move_left", "move_right"]
	for action in movement_actions:
		if InputMap.has_action(action):
			print("✓ Input action '", action, "' exists")
		else:
			print("✗ Input action '", action, "' missing")
	
	# Test movement properties
	if player.speed > 0:
		print("✓ Player speed configured: ", player.speed)
	else:
		print("✗ Player speed not configured")
	
	if player.acceleration > 0:
		print("✓ Player acceleration configured: ", player.acceleration)
	else:
		print("✗ Player acceleration not configured")

func test_shooting_system():
	print("\nTest 3: Shooting System")
	
	if not player:
		print("✗ Cannot test shooting - player not found")
		return
	
	# Test shoot input
	if InputMap.has_action("shoot"):
		print("✓ Shoot input action exists")
	else:
		print("✗ Shoot input action missing")
	
	# Test bullet scene
	if player.bullet_scene:
		print("✓ Bullet scene loaded")
	else:
		print("✗ Bullet scene not loaded")
	
	# Test shooting properties
	print("Fire rate: ", player.fire_rate)
	print("Max bullets: ", player.max_bullets)
	print("Bullet speed: ", player.bullet_speed)

func test_boundary_system():
	print("\nTest 4: Boundary System")
	
	if not player:
		print("✗ Cannot test boundaries - player not found")
		return
	
	# Test screen size detection
	if player.screen_size.x > 0 and player.screen_size.y > 0:
		print("✓ Screen size detected: ", player.screen_size)
	else:
		print("✗ Screen size not detected properly")
	
	# Test ship width
	if player.ship_width > 0:
		print("✓ Ship width configured: ", player.ship_width)
	else:
		print("✗ Ship width not configured")

func _input(event):
	"""Test input detection"""
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("move_left"):
			print("DEBUG: Move left detected")
		elif Input.is_action_just_pressed("move_right"):
			print("DEBUG: Move right detected")
		elif Input.is_action_just_pressed("shoot"):
			print("DEBUG: Shoot detected")
