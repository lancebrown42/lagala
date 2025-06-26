extends Node

# Absolute minimal test - no UI, just input detection

var frame_count = 0

func _ready():
	print("=== MINIMAL TEST STARTED ===")
	print("Godot version: ", Engine.get_version_info())
	print("Platform: ", OS.get_name())
	print("If you see this, the scene is loading correctly.")
	print("Now testing input detection...")
	print("Try pressing ANY key or clicking anywhere...")

func _process(_delta):
	frame_count += 1
	if frame_count % 60 == 0:  # Every second
		print("Frame: ", frame_count, " - Still running, waiting for input...")

func _input(event):
	print("INPUT DETECTED! Type: ", type_string(typeof(event)))
	
	if event is InputEventKey:
		print("  KEY EVENT - Code: ", event.keycode, " Pressed: ", event.pressed)
		if event.pressed:
			print("  Key pressed successfully!")
	
	elif event is InputEventMouseButton:
		print("  MOUSE BUTTON - Button: ", event.button_index, " Pressed: ", event.pressed)
		if event.pressed:
			print("  Mouse click detected!")
	
	elif event is InputEventMouseMotion:
		print("  MOUSE MOTION - Position: ", event.position)
	
	else:
		print("  OTHER INPUT TYPE: ", event.get_class())

func _unhandled_input(event):
	print("UNHANDLED INPUT: ", event.get_class())

func _notification(what):
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			print("Window gained focus")
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			print("Window lost focus")
		NOTIFICATION_APPLICATION_FOCUS_IN:
			print("Application gained focus")
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			print("Application lost focus")
