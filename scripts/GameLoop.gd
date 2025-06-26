extends Node

# Game Loop - Handles the core game timing and updates
class_name GameLoop

# Target frame rate
const TARGET_FPS = 60
var delta_time: float = 0.0
var frame_count: int = 0
var fps_counter: float = 0.0
var current_fps: int = 0

# Game timing
var game_time: float = 0.0
var is_running: bool = false

func _ready():
	print("Game Loop initialized - Target FPS: ", TARGET_FPS)
	# Set the target FPS
	Engine.max_fps = TARGET_FPS

func _process(delta):
	if not is_running:
		return
		
	# Update timing
	delta_time = delta
	game_time += delta
	frame_count += 1
	
	# Calculate FPS
	fps_counter += delta
	if fps_counter >= 1.0:
		current_fps = frame_count
		frame_count = 0
		fps_counter = 0.0
		
		# Debug FPS (remove in production)
		if current_fps < TARGET_FPS * 0.9:  # If FPS drops below 90% of target
			print("FPS Warning: ", current_fps, " (Target: ", TARGET_FPS, ")")

func start_loop():
	"""Start the game loop"""
	is_running = true
	game_time = 0.0
	print("Game loop started")

func stop_loop():
	"""Stop the game loop"""
	is_running = false
	print("Game loop stopped")

func get_delta_time() -> float:
	return delta_time

func get_game_time() -> float:
	return game_time

func get_current_fps() -> int:
	return current_fps
