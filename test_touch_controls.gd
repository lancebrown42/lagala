extends SceneTree

func _init():
	print("=== Testing Touch Controls System ===")
	
	# Test TouchControls class loading
	var touch_controls_class = preload("res://scripts/TouchControls.gd")
	if touch_controls_class:
		print("✅ TouchControls class loads successfully")
		
		# Create instance for testing
		var touch_controls = touch_controls_class.new()
		if touch_controls:
			print("✅ TouchControls instance created")
			
			# Test platform detection
			print("Platform detection:")
			print("   - Current OS: ", OS.get_name())
			print("   - Is mobile: ", touch_controls.is_mobile_platform())
			
			# Test texture creation
			var joystick_base = touch_controls.create_joystick_base_texture()
			if joystick_base:
				print("✅ Joystick base texture created")
				print("   - Size: ", joystick_base.get_size())
			else:
				print("❌ Failed to create joystick base texture")
			
			var joystick_knob = touch_controls.create_joystick_knob_texture()
			if joystick_knob:
				print("✅ Joystick knob texture created")
				print("   - Size: ", joystick_knob.get_size())
			else:
				print("❌ Failed to create joystick knob texture")
			
			var shoot_button = touch_controls.create_shoot_button_texture()
			if shoot_button:
				print("✅ Shoot button texture created")
				print("   - Size: ", shoot_button.get_size())
			else:
				print("❌ Failed to create shoot button texture")
			
			var pause_button = touch_controls.create_pause_button_texture()
			if pause_button:
				print("✅ Pause button texture created")
				print("   - Size: ", pause_button.get_size())
			else:
				print("❌ Failed to create pause button texture")
			
			# Test signal definitions
			print("Signal definitions:")
			var signals = touch_controls.get_signal_list()
			for signal_info in signals:
				if signal_info.name in ["move_left_pressed", "move_left_released", "move_right_pressed", "move_right_released", "shoot_pressed", "shoot_released", "pause_pressed"]:
					print("   ✅ ", signal_info.name)
			
		else:
			print("❌ Failed to create TouchControls instance")
	else:
		print("❌ TouchControls class failed to load")
	
	# Test input settings
	print("Input settings:")
	print("   - Touch emulation: ", ProjectSettings.get_setting("input_devices/pointing/emulate_touch_from_mouse", false))
	
	# Test Player touch control handlers
	var player_class = preload("res://scripts/Player.gd")
	if player_class:
		print("✅ Player class loads successfully")
		var player = player_class.new()
		if player:
			print("✅ Player instance created")
			
			# Check if touch control methods exist
			var methods = ["_on_move_left_pressed", "_on_move_left_released", "_on_move_right_pressed", "_on_move_right_released", "_on_shoot_pressed", "_on_shoot_released"]
			for method_name in methods:
				if player.has_method(method_name):
					print("   ✅ ", method_name)
				else:
					print("   ❌ ", method_name, " missing")
		else:
			print("❌ Failed to create Player instance")
	else:
		print("❌ Player class failed to load")
	
	print("=== Touch Controls Test Complete ===")
	quit()
