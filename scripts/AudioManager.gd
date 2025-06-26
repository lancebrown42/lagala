extends Node

# Audio Manager for procedural sound generation and background music
class_name AudioManager

# Audio players for different sound types
var laser_player: AudioStreamPlayer
var explosion_player: AudioStreamPlayer
var enemy_explosion_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

func _ready():
	# Create audio players
	laser_player = AudioStreamPlayer.new()
	explosion_player = AudioStreamPlayer.new()
	enemy_explosion_player = AudioStreamPlayer.new()
	music_player = AudioStreamPlayer.new()
	
	add_child(laser_player)
	add_child(explosion_player)
	add_child(enemy_explosion_player)
	add_child(music_player)
	
	# Setup background music
	setup_background_music()

func setup_background_music():
	"""Setup and start background music"""
	var music_stream = load("res://assets/sounds/Pixel Odyssey.mp3")
	if music_stream:
		music_player.stream = music_stream
		music_player.autoplay = true
		music_player.stream.loop = true
		music_player.volume_db = -10  # Reduce volume so it doesn't overpower sound effects
		music_player.play()
		print("Background music started: Pixel Odyssey")
	else:
		print("Warning: Could not load background music file")

func create_laser_wav() -> AudioStreamWAV:
	"""Create a chippy laser sound using WAV format"""
	var sample_rate = 22050
	var duration = 0.1
	var samples = int(sample_rate * duration)
	
	# Use 8-bit format for simplicity and retro feel
	var data = PackedByteArray()
	data.resize(samples)
	
	# Generate a quick frequency sweep with some noise
	for i in range(samples):
		var t = float(i) / sample_rate
		var progress = t / duration
		
		# Frequency sweep from 800Hz to 400Hz
		var freq = 800.0 - (400.0 * progress)
		var wave = sin(2.0 * PI * freq * t)
		
		# Add some square wave harmonics for chippiness
		var square = 1.0 if sin(2.0 * PI * freq * t) > 0 else -1.0
		wave = (wave * 0.7) + (square * 0.3)
		
		# Apply envelope (quick attack, exponential decay)
		var envelope = exp(-t * 8.0)
		
		# Convert to 8-bit unsigned (0-255)
		var sample_8bit = int((wave * envelope * 0.3 + 1.0) * 127.5)
		data[i] = clamp(sample_8bit, 0, 255)
	
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.data = data
	stream.mix_rate = sample_rate
	
	return stream

func create_explosion_wav() -> AudioStreamWAV:
	"""Create an explosion sound using WAV format"""
	var sample_rate = 22050
	var duration = 0.3
	var samples = int(sample_rate * duration)
	
	var data = PackedByteArray()
	data.resize(samples)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Generate noise-based explosion
	for i in range(samples):
		var t = float(i) / sample_rate
		var progress = t / duration
		
		# Start with white noise
		var noise = rng.randf_range(-1.0, 1.0)
		
		# Add some low frequency rumble
		var rumble = sin(2.0 * PI * 60.0 * t) * 0.5
		
		# Mix noise and rumble
		var sample = (noise * 0.7) + (rumble * 0.3)
		
		# Apply envelope (quick attack, slower decay)
		var envelope = exp(-t * 3.0) * (1.0 - progress * 0.5)
		
		# Convert to 8-bit unsigned (0-255)
		var sample_8bit = int((sample * envelope * 0.4 + 1.0) * 127.5)
		data[i] = clamp(sample_8bit, 0, 255)
	
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.data = data
	stream.mix_rate = sample_rate
	
	return stream

func create_enemy_explosion_wav() -> AudioStreamWAV:
	"""Create a higher-pitched enemy explosion sound"""
	var sample_rate = 22050
	var duration = 0.25
	var samples = int(sample_rate * duration)
	
	var data = PackedByteArray()
	data.resize(samples)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Generate higher-pitched explosion
	for i in range(samples):
		var t = float(i) / sample_rate
		var progress = t / duration
		
		# White noise with higher frequency emphasis
		var noise = rng.randf_range(-1.0, 1.0)
		
		# Add some higher frequency content
		var high_freq = sin(2.0 * PI * 200.0 * t) * 0.3
		
		# Mix with emphasis on higher frequencies
		var sample = (noise * 0.8) + (high_freq * 0.2)
		
		# Apply envelope (sharper attack and decay)
		var envelope = exp(-t * 5.0)
		
		# Convert to 8-bit unsigned (0-255)
		var sample_8bit = int((sample * envelope * 0.35 + 1.0) * 127.5)
		data[i] = clamp(sample_8bit, 0, 255)
	
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.data = data
	stream.mix_rate = sample_rate
	
	return stream

func play_laser_sound():
	"""Play the laser sound effect"""
	if laser_player and not laser_player.playing:
		laser_player.stream = create_laser_wav()
		laser_player.play()

func play_explosion_sound():
	"""Play the explosion sound effect"""
	if explosion_player and not explosion_player.playing:
		explosion_player.stream = create_explosion_wav()
		explosion_player.play()

func play_enemy_explosion_sound():
	"""Play the enemy explosion sound effect"""
	if enemy_explosion_player and not enemy_explosion_player.playing:
		enemy_explosion_player.stream = create_enemy_explosion_wav()
		enemy_explosion_player.play()

# Background music control functions
func play_music():
	"""Start or resume background music"""
	if music_player and music_player.stream:
		music_player.play()

func stop_music():
	"""Stop background music"""
	if music_player:
		music_player.stop()

func pause_music():
	"""Pause background music"""
	if music_player:
		music_player.stream_paused = true

func resume_music():
	"""Resume background music"""
	if music_player:
		music_player.stream_paused = false

func set_music_volume(volume_db: float):
	"""Set background music volume (-80 to 24 dB)"""
	if music_player:
		music_player.volume_db = clamp(volume_db, -80, 24)

func is_music_playing() -> bool:
	"""Check if background music is currently playing"""
	return music_player and music_player.playing and not music_player.stream_paused

# Static methods for easy access from other scripts
static func get_audio_manager() -> AudioManager:
	"""Get the AudioManager instance from the scene tree"""
	var main_scene = Engine.get_main_loop().current_scene
	if main_scene:
		return main_scene.get_node_or_null("AudioManager")
	return null
