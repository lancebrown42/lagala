extends Node

# Debug Tester - Run this script in Godot to test Phase 1 functionality
# Attach this to a Node in the scene and run to see debug output

@onready var game_manager: GameManager

func _ready():
	print("=== DEBUG TESTER STARTED ===")
	
	# Find the GameManager in the scene
	game_manager = get_node("../GameManager") if get_node("../GameManager") else null
	
	if game_manager:
		print("✓ GameManager found")
		test_game_manager()
	else:
		print("✗ GameManager not found")
	
	# Test input system
	test_input_system()
	
	# Test UI references
	test_ui_system()

func test_game_manager():
	print("\n--- Testing GameManager ---")
	
	# Test initial state
	print("Initial state: ", game_manager.get_current_state())
	print("Initial score: ", game_manager.score)
	print("Initial lives: ", game_manager.lives)
	
	# Connect to signals for testing
	game_manager.score_changed.connect(_on_score_changed)
	game_manager.lives_changed.connect(_on_lives_changed)
	game_manager.game_started.connect(_on_game_started)
	game_manager.game_over.connect(_on_game_over)
	
	# Test score system
	print("Adding 100 points...")
	game_manager.add_score(100)
	
	# Test life system
	print("Losing a life...")
	game_manager.lose_life()

func test_input_system():
	print("\n--- Testing Input System ---")
	
	var input_actions = ["move_left", "move_right", "shoot"]
	
	for action in input_actions:
		if InputMap.has_action(action):
			var events = InputMap.action_get_events(action)
			print("✓ Action '", action, "' has ", events.size(), " input events")
		else:
			print("✗ Action '", action, "' not found")

func test_ui_system():
	print("\n--- Testing UI System ---")
	
	# Try to find UI elements
	var main_node = get_node("../")
	if main_node:
		var ui_elements = [
			"UI/HUD/ScoreLabel",
			"UI/HUD/LivesLabel", 
			"UI/StartScreen",
			"UI/GameOverScreen"
		]
		
		for element_path in ui_elements:
			var element = main_node.get_node(element_path) if main_node.has_node(element_path) else null
			if element:
				print("✓ Found UI element: ", element_path)
			else:
				print("✗ Missing UI element: ", element_path)

# Signal handlers for testing
func _on_score_changed(new_score: int):
	print("Score changed to: ", new_score)

func _on_lives_changed(new_lives: int):
	print("Lives changed to: ", new_lives)

func _on_game_started():
	print("Game started signal received")

func _on_game_over():
	print("Game over signal received")

func _input(event):
	# Test input detection
	if event is InputEventKey and event.pressed:
		print("Key pressed: ", event.keycode, " (", char(event.unicode), ")")
		
		# Test our custom actions
		if Input.is_action_just_pressed("move_left"):
			print("Move left action detected")
		elif Input.is_action_just_pressed("move_right"):
			print("Move right action detected")
		elif Input.is_action_just_pressed("shoot"):
			print("Shoot action detected")
