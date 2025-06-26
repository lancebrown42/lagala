extends Node2D

# Simple Main - Minimal test version to debug button issues

@onready var game_manager = $GameManager
@onready var start_screen = $UI/StartScreen
@onready var game_screen = $UI/GameScreen
@onready var start_button = $UI/StartScreen/CenterContainer/VBoxContainer/StartButton

func _ready():
	print("=== SIMPLE MAIN LOADED ===")
	
	# Test node references
	print("GameManager: ", game_manager)
	print("StartScreen: ", start_screen)
	print("GameScreen: ", game_screen)
	print("StartButton: ", start_button)
	
	# Connect button
	if start_button:
		print("Connecting start button...")
		start_button.pressed.connect(_on_start_pressed)
		print("Start button connected successfully!")
	else:
		print("ERROR: Start button is null!")
	
	# Connect game manager
	if game_manager:
		game_manager.game_started.connect(_on_game_started)
		print("Game manager connected!")
	else:
		print("ERROR: Game manager is null!")

func _on_start_pressed():
	print("🎉 START BUTTON PRESSED!")
	if game_manager:
		print("Calling game_manager.start_game()...")
		game_manager.start_game()
	else:
		print("ERROR: game_manager is null in button handler!")

func _on_game_started():
	print("🎮 GAME STARTED SIGNAL RECEIVED!")
	start_screen.visible = false
	game_screen.visible = true

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			print("ESC pressed - going back to start screen")
			start_screen.visible = true
			game_screen.visible = false
