extends SceneTree

func _init():
	print("=== Testing Background Music System ===")
	
	# Test music file loading
	var music_file = load("res://assets/sounds/Pixel Odyssey.mp3")
	if music_file:
		print("✅ Pixel Odyssey.mp3 loaded successfully")
		print("   - Resource type: ", music_file.get_class())
		if music_file.has_method("get_length"):
			print("   - Duration: ", music_file.get_length(), " seconds")
	else:
		print("❌ Failed to load Pixel Odyssey.mp3")
	
	# Test AudioManager with music
	var audio_manager_class = preload("res://scripts/AudioManager.gd")
	if audio_manager_class:
		print("✅ AudioManager class loads successfully")
		
		var audio_manager = audio_manager_class.new()
		if audio_manager:
			print("✅ AudioManager instance created")
			
			# Test music player setup
			audio_manager.setup_background_music()
			
			if audio_manager.music_player:
				print("✅ Music player created")
				if audio_manager.music_player.stream:
					print("✅ Music stream assigned")
					print("   - Stream type: ", audio_manager.music_player.stream.get_class())
					print("   - Loop enabled: ", audio_manager.music_player.stream.loop if audio_manager.music_player.stream.has_method("set_loop") else "N/A")
				else:
					print("❌ Music stream not assigned")
			else:
				print("❌ Music player not created")
			
			# Test music control functions
			print("Testing music control functions...")
			print("   - is_music_playing(): ", audio_manager.is_music_playing())
			
		else:
			print("❌ Failed to create AudioManager instance")
	else:
		print("❌ AudioManager class failed to load")
	
	print("=== Music Test Complete ===")
	quit()
