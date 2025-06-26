extends Node

# GameManager Test - Direct test of game manager functionality

func _ready():
	print("=== GAME MANAGER TEST ===")
	
	# Wait for everything to load
	await get_tree().create_timer(1.0).timeout
	
	test_game_manager()

func test_game_manager():
	var game_manager = get_node("../GameManager") if has_node("../GameManager") else null
	
	if game_manager:
		print("✓ GameManager found")
		print("Current state: ", game_manager.get_current_state())
		print("Score: ", game_manager.score)
		print("Lives: ", game_manager.lives)
		
		# Test the start_game function directly
		print("Testing start_game() function...")
		game_manager.start_game()
		
		print("After start_game():")
		print("Current state: ", game_manager.get_current_state())
		print("Score: ", game_manager.score)
		print("Lives: ", game_manager.lives)
		
	else:
		print("✗ GameManager not found!")

func _input(event):
	# Add a manual test - press 'T' to trigger start game
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		print("Manual test: T key pressed - starting game...")
		var game_manager = get_node("../GameManager") if has_node("../GameManager") else null
		if game_manager:
			game_manager.start_game()
		else:
			print("GameManager not found for manual test")
