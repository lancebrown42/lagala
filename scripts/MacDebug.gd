extends Node

# Mac-specific debugging for Lagala

func _ready():
	print("=== MAC DEBUG INFO ===")
	print("OS: ", OS.get_name())
	print("Godot version: ", Engine.get_version_info())
	print("Renderer: ", ProjectSettings.get_setting("rendering/renderer/rendering_method"))
	print("Display driver: ", DisplayServer.get_name())
	print("Screen size: ", DisplayServer.screen_get_size())
	print("Window size: ", get_window().size)
	
	# Test if we're in debug mode
	print("Debug build: ", OS.is_debug_build())
	print("Editor hint: ", Engine.is_editor_hint())
	
	# Check input capabilities
	print("Input devices: ", Input.get_connected_joypads())
	
	# Test basic input
	print("Testing input system...")

func _input(event):
	if event is InputEventKey:
		print("Key event: ", event.keycode, " pressed: ", event.pressed)
		
		if event.pressed:
			match event.keycode:
				KEY_T:
					print("T key works!")
				KEY_SPACE:
					print("Space key works!")
				KEY_A:
					print("A key works!")
				KEY_D:
					print("D key works!")
	
	elif event is InputEventMouseButton:
		print("Mouse button: ", event.button_index, " pressed: ", event.pressed)
		if event.pressed:
			print("Mouse click detected at: ", event.position)
