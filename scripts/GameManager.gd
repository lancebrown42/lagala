extends Node

# Game Manager - Handles core game loop and state management
class_name GameManager

# Game states
enum GameState {
	MENU,
	PLAYING,
	GAME_OVER,
	PAUSED
}

# Game variables
var current_state: GameState = GameState.MENU
var score: int = 0
var lives: int = 3
var level: int = 1

# Signals for game events
signal game_started
signal game_over
signal score_changed(new_score: int)
signal lives_changed(new_lives: int)

func _ready():
	print("Lagala Game Manager initialized")
	# Set up the game window
	get_window().title = "Lagala - Galaga Clone"
	
func _process(_delta):
	# Handle global input
	if Input.is_action_just_pressed("ui_cancel"):
		if current_state == GameState.PLAYING:
			toggle_pause()
		elif current_state == GameState.PAUSED:
			toggle_pause()

func start_game():
	"""Start a new game"""
	current_state = GameState.PLAYING
	score = 0
	lives = 3
	level = 1
	
	emit_signal("game_started")
	emit_signal("score_changed", score)
	emit_signal("lives_changed", lives)
	print("Game started!")

func end_game():
	"""End the current game"""
	current_state = GameState.GAME_OVER
	emit_signal("game_over")
	print("Game Over! Final Score: ", score)

func toggle_pause():
	"""Toggle pause state"""
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true
		print("Game Paused")
	elif current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false
		print("Game Resumed")

func add_score(points: int):
	"""Add points to the score"""
	score += points
	emit_signal("score_changed", score)

func lose_life():
	"""Player loses a life"""
	lives -= 1
	emit_signal("lives_changed", lives)
	
	if lives <= 0:
		end_game()

func get_current_state() -> GameState:
	return current_state

func is_playing() -> bool:
	return current_state == GameState.PLAYING
