extends Node

# Simplified Audio Manager using AudioStreamGenerator
class_name AudioManagerSimple

# Audio players for different sound types
var laser_player: AudioStreamPlayer
var explosion_player: AudioStreamPlayer
var enemy_explosion_player: AudioStreamPlayer

# Generator playbacks for real-time audio
var laser_playback: AudioStreamGeneratorPlayback
var explosion_playback: AudioStreamGeneratorPlayback
var enemy_explosion_playback: AudioStreamGeneratorPlayback

func _ready():
	# Create audio players with generators
	setup_laser_player()
	setup_explosion_player()
	setup_enemy_explosion_player()

func setup_laser_player():
	"""Setup laser sound player"""
	laser_player = AudioStreamPlayer.new()
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 22050
	generator.buffer_length = 0.1
	laser_player.stream = generator
	add_child(laser_player)

func setup_explosion_player():
	"""Setup explosion sound player"""
	explosion_player = AudioStreamPlayer.new()
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 22050
	generator.buffer_length = 0.3
	explosion_player.stream = generator
	add_child(explosion_player)

func setup_enemy_explosion_player():
	"""Setup enemy explosion sound player"""
	enemy_explosion_player = AudioStreamPlayer.new()
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 22050
	generator.buffer_length = 0.25
	enemy_explosion_player.stream = generator
	add_child(enemy_explosion_player)

func play_laser_sound():
	"""Play the laser sound effect"""
	if laser_player and not laser_player.playing:
		laser_player.play()
		laser_playback = laser_player.get_stream_playback()
		if laser_playback:
			generate_laser_audio()

func play_explosion_sound():
	"""Play the explosion sound effect"""
	if explosion_player and not explosion_player.playing:
		explosion_player.play()
		explosion_playback = explosion_player.get_stream_playback()
		if explosion_playback:
			generate_explosion_audio()

func play_enemy_explosion_sound():
	"""Play the enemy explosion sound effect"""
	if enemy_explosion_player and not enemy_explosion_player.playing:
		enemy_explosion_player.play()
		enemy_explosion_playback = enemy_explosion_player.get_stream_playback()
		if enemy_explosion_playback:
			generate_enemy_explosion_audio()

func generate_laser_audio():
	"""Generate laser sound in real-time"""
	var sample_rate = 22050.0
	var duration = 0.1
	var samples_to_fill = laser_playback.get_frames_available()
	
	for i in range(samples_to_fill):
		var t = float(i) / sample_rate
		if t > duration:
			break
			
		var progress = t / duration
		
		# Frequency sweep from 800Hz to 400Hz
		var freq = 800.0 - (400.0 * progress)
		var wave = sin(2.0 * PI * freq * t)
		
		# Add square wave for chippiness
		var square = 1.0 if sin(2.0 * PI * freq * t) > 0 else -1.0
		wave = (wave * 0.7) + (square * 0.3)
		
		# Apply envelope
		var envelope = exp(-t * 8.0)
		
		var sample = wave * envelope * 0.3
		laser_playback.push_frame(Vector2(sample, sample))

func generate_explosion_audio():
	"""Generate explosion sound in real-time"""
	var sample_rate = 22050.0
	var duration = 0.3
	var samples_to_fill = explosion_playback.get_frames_available()
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(samples_to_fill):
		var t = float(i) / sample_rate
		if t > duration:
			break
			
		var progress = t / duration
		
		# White noise
		var noise = rng.randf_range(-1.0, 1.0)
		
		# Low frequency rumble
		var rumble = sin(2.0 * PI * 60.0 * t) * 0.5
		
		# Mix
		var sample = (noise * 0.7) + (rumble * 0.3)
		
		# Apply envelope
		var envelope = exp(-t * 3.0) * (1.0 - progress * 0.5)
		
		sample *= envelope * 0.4
		explosion_playback.push_frame(Vector2(sample, sample))

func generate_enemy_explosion_audio():
	"""Generate enemy explosion sound in real-time"""
	var sample_rate = 22050.0
	var duration = 0.25
	var samples_to_fill = enemy_explosion_playback.get_frames_available()
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(samples_to_fill):
		var t = float(i) / sample_rate
		if t > duration:
			break
			
		var progress = t / duration
		
		# White noise with higher frequency emphasis
		var noise = rng.randf_range(-1.0, 1.0)
		
		# Higher frequency content
		var high_freq = sin(2.0 * PI * 200.0 * t) * 0.3
		
		# Mix
		var sample = (noise * 0.8) + (high_freq * 0.2)
		
		# Apply envelope
		var envelope = exp(-t * 5.0)
		
		sample *= envelope * 0.35
		enemy_explosion_playback.push_frame(Vector2(sample, sample))

# Static method for easy access
static func get_audio_manager() -> AudioManagerSimple:
	"""Get the AudioManagerSimple instance from the scene tree"""
	var main_scene = Engine.get_main_loop().current_scene
	if main_scene:
		return main_scene.get_node_or_null("AudioManager")
	return null
