extends Node

# Test Runner - Simple tests to verify Phase 1 implementation

func _ready():
	print("=== LAGALA PHASE 1 TEST RUNNER ===")
	run_tests()

func run_tests():
	print("Running Phase 1 tests...")
	
	# Test 1: Project structure
	test_project_structure()
	
	# Test 2: Game manager functionality
	test_game_manager()
	
	# Test 3: Input system
	test_input_system()
	
	print("=== PHASE 1 TESTS COMPLETE ===")

func test_project_structure():
	print("Test 1: Project Structure")
	
	# Check if main scene exists
	var main_scene = load("res://scenes/Main.tscn")
	if main_scene:
		print("✓ Main scene loaded successfully")
	else:
		print("✗ Main scene failed to load")
	
	# Check if scripts exist
	var game_manager_script = load("res://scripts/GameManager.gd")
	if game_manager_script:
		print("✓ GameManager script loaded successfully")
	else:
		print("✗ GameManager script failed to load")

func test_game_manager():
	print("Test 2: Game Manager")
	
	# Create a test game manager
	var gm = GameManager.new()
	
	# Test initial state
	if gm.get_current_state() == GameManager.GameState.MENU:
		print("✓ Initial game state is MENU")
	else:
		print("✗ Initial game state is incorrect")
	
	# Test game start
	gm.start_game()
	if gm.get_current_state() == GameManager.GameState.PLAYING:
		print("✓ Game state changes to PLAYING when started")
	else:
		print("✗ Game state doesn't change to PLAYING")
	
	# Test score system
	gm.add_score(100)
	if gm.score == 100:
		print("✓ Score system working")
	else:
		print("✗ Score system not working")
	
	gm.queue_free()

func test_input_system():
	print("Test 3: Input System")
	
	# Check if input actions are defined
	if InputMap.has_action("move_left"):
		print("✓ move_left action defined")
	else:
		print("✗ move_left action not defined")
	
	if InputMap.has_action("move_right"):
		print("✓ move_right action defined")
	else:
		print("✗ move_right action not defined")
	
	if InputMap.has_action("shoot"):
		print("✓ shoot action defined")
	else:
		print("✗ shoot action not defined")
