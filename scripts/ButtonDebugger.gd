extends Node

# Button Debugger - Tests UI button functionality

func _ready():
	print("=== BUTTON DEBUGGER STARTED ===")
	
	# Wait a moment for everything to load
	await get_tree().create_timer(0.5).timeout
	
	test_button_references()

func test_button_references():
	print("Testing button references...")
	
	# Try to find the start button
	var start_button = get_node("../UI/StartScreen/VBoxContainer/StartButton") if has_node("../UI/StartScreen/VBoxContainer/StartButton") else null
	
	if start_button:
		print("✓ Start button found!")
		print("Button text: ", start_button.text)
		print("Button disabled: ", start_button.disabled)
		print("Button visible: ", start_button.visible)
		
		# Connect directly to test
		if not start_button.pressed.is_connected(_on_debug_start_pressed):
			start_button.pressed.connect(_on_debug_start_pressed)
			print("✓ Debug connection added to start button")
	else:
		print("✗ Start button NOT found!")
		
		# Try to find the UI structure
		print("Checking UI structure...")
		var ui = get_node("../UI") if has_node("../UI") else null
		if ui:
			print("✓ UI found")
			var start_screen = ui.get_node("StartScreen") if ui.has_node("StartScreen") else null
			if start_screen:
				print("✓ StartScreen found")
				var vbox = start_screen.get_node("VBoxContainer") if start_screen.has_node("VBoxContainer") else null
				if vbox:
					print("✓ VBoxContainer found")
					print("VBoxContainer children: ", vbox.get_children())
				else:
					print("✗ VBoxContainer not found")
			else:
				print("✗ StartScreen not found")
		else:
			print("✗ UI not found")

func _on_debug_start_pressed():
	print("🎉 DEBUG: Start button was pressed successfully!")
	
	# Try to find and call the game manager directly
	var game_manager = get_node("../GameManager") if has_node("../GameManager") else null
	if game_manager:
		print("Calling game_manager.start_game() directly...")
		game_manager.start_game()
	else:
		print("Game manager not found!")
