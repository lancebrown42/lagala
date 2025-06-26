extends Node2D

# Main scene controller - manages UI and game flow

# References to UI elements
@onready var game_manager: GameManager = $GameManager
@onready var player: Player = $GameWorld/Player
@onready var hud = $UI/HUD
@onready var start_screen = $UI/StartScreen
@onready var game_over_screen = $UI/GameOverScreen
@onready var score_label = $UI/HUD/ScoreLabel
@onready var lives_label = $UI/HUD/LivesLabel
@onready var final_score_label = $UI/GameOverScreen/VBoxContainer/FinalScoreLabel
@onready var start_button = $UI/StartScreen/VBoxContainer/StartButton
@onready var restart_button = $UI/GameOverScreen/VBoxContainer/RestartButton

func _ready():
	print("Main scene loaded")
	
	# Connect UI signals first
	if start_button:
		start_button.pressed.connect(_on_start_button_pressed)
		print("Start button connected")
	else:
		print("ERROR: Start button not found!")
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_button_pressed)
		print("Restart button connected")
	else:
		print("ERROR: Restart button not found!")
	
	# Connect game manager signals
	if game_manager:
		game_manager.game_started.connect(_on_game_started)
		game_manager.game_over.connect(_on_game_over)
		game_manager.score_changed.connect(_on_score_changed)
		game_manager.lives_changed.connect(_on_lives_changed)
		print("Game manager connected")
	else:
		print("ERROR: Game manager not found!")
	
	# Connect player signals
	if player:
		player.player_shot.connect(_on_player_shot)
		player.player_hit.connect(_on_player_hit)
		player.bullet_fired.connect(_on_bullet_fired)
		print("Player connected")
		
		# Set up player sprite after connections
		setup_player_sprite()
	else:
		print("WARNING: Player not found!")
	
	# Show start screen initially
	show_start_screen()

func _process(_delta):
	# Handle frame-rate independent updates
	pass

func show_start_screen():
	"""Show the start screen"""
	start_screen.visible = true
	hud.visible = false
	game_over_screen.visible = false
	if player:
		player.visible = false

func show_game_screen():
	"""Show the game HUD"""
	start_screen.visible = false
	hud.visible = true
	game_over_screen.visible = false
	if player:
		player.visible = true
		player.reset_position()

func show_game_over_screen():
	"""Show the game over screen"""
	start_screen.visible = false
	hud.visible = false
	game_over_screen.visible = true
	if player:
		player.visible = false

# Signal handlers
func _on_start_button_pressed():
	print("Start button pressed - calling game_manager.start_game()")
	if game_manager:
		game_manager.start_game()
	else:
		print("ERROR: Cannot start game - game_manager is null!")

func _on_restart_button_pressed():
	print("Restart button pressed - calling game_manager.start_game()")
	if game_manager:
		game_manager.start_game()
	else:
		print("ERROR: Cannot restart game - game_manager is null!")

func _on_game_started():
	print("Game started signal received")
	show_game_screen()

func _on_game_over():
	print("Game over signal received")
	final_score_label.text = "Final Score: " + str(game_manager.score)
	show_game_over_screen()

func _on_score_changed(new_score: int):
	score_label.text = "SCORE: " + str(new_score)

func _on_lives_changed(new_lives: int):
	lives_label.text = "LIVES: " + str(new_lives)

# Player signal handlers
func _on_player_shot():
	print("Player shot fired")

func _on_player_hit():
	print("Player was hit!")
	game_manager.lose_life()

func _on_bullet_fired(bullet_position: Vector2):
	print("Bullet fired at position: ", bullet_position)

func setup_player_sprite():
	"""Set up the player sprite with a simple texture"""
	if not player:
		print("Cannot setup player sprite - player is null")
		return
		
	if not player.has_node("Sprite2D"):
		print("Cannot setup player sprite - Sprite2D node not found")
		return
	
	var sprite = player.get_node("Sprite2D")
	
	# Try to use SpriteGenerator, fallback to simple colored rectangle
	if SpriteGenerator:
		var texture = SpriteGenerator.create_player_sprite()
		sprite.texture = texture
		print("Player sprite set up with SpriteGenerator")
	else:
		# Fallback: just use the colored modulate we set in the scene
		print("Using fallback player sprite (colored rectangle)")
	
	# Make sure the sprite is visible
	sprite.visible = true
