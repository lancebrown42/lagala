extends SceneTree

func _init():
	print("=== Testing Fixed Audio System ===")
	
	# Test AudioManager class loading
	var audio_manager_class = preload("res://scripts/AudioManager.gd")
	if audio_manager_class:
		print("✅ AudioManager class loads successfully")
		
		# Create instance for testing
		var audio_manager = audio_manager_class.new()
		if audio_manager:
			print("✅ AudioManager instance created")
			
			# Test sound generation with 8-bit format
			var laser_sound = audio_manager.create_laser_wav()
			if laser_sound:
				print("✅ Laser sound generated successfully")
				print("   - Format: ", laser_sound.format, " (should be ", AudioStreamWAV.FORMAT_8_BITS, ")")
				print("   - Sample rate: ", laser_sound.mix_rate, " Hz")
				print("   - Data size: ", laser_sound.data.size(), " bytes")
			else:
				print("❌ Failed to generate laser sound")
			
			var explosion_sound = audio_manager.create_explosion_wav()
			if explosion_sound:
				print("✅ Explosion sound generated successfully")
				print("   - Format: ", explosion_sound.format, " (should be ", AudioStreamWAV.FORMAT_8_BITS, ")")
				print("   - Sample rate: ", explosion_sound.mix_rate, " Hz")
				print("   - Data size: ", explosion_sound.data.size(), " bytes")
			else:
				print("❌ Failed to generate explosion sound")
			
			var enemy_explosion_sound = audio_manager.create_enemy_explosion_wav()
			if enemy_explosion_sound:
				print("✅ Enemy explosion sound generated successfully")
				print("   - Format: ", enemy_explosion_sound.format, " (should be ", AudioStreamWAV.FORMAT_8_BITS, ")")
				print("   - Sample rate: ", enemy_explosion_sound.mix_rate, " Hz")
				print("   - Data size: ", enemy_explosion_sound.data.size(), " bytes")
			else:
				print("❌ Failed to generate enemy explosion sound")
		else:
			print("❌ Failed to create AudioManager instance")
	else:
		print("❌ AudioManager class failed to load")
	
	print("=== Audio Test Complete ===")
	quit()
