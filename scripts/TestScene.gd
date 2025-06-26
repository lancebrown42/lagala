extends Control

# Ultra-simple test scene for Mac debugging

@onready var button = $VBoxContainer/Button
@onready var label = $VBoxContainer/Label

func _ready():
	print("=== TEST SCENE LOADED ON MAC ===")
	print("Godot version: ", Engine.get_version_info())
	print("Platform: ", OS.get_name())
	print("Renderer: ", RenderingServer.get_rendering_device())
	
	if button:
		print("✓ Button found")
		button.pressed.connect(_on_button_pressed)
		print("✓ Button connected")
	else:
		print("✗ Button not found!")
	
	if label:
		print("✓ Label found")
	else:
		print("✗ Label not found!")

func _on_button_pressed():
	print("🎉 BUTTON CLICKED SUCCESSFULLY!")
	label.text = "BUTTON WORKS!"
	
	# Change button text to confirm it's working
	button.text = "CLICKED!"

func _input(event):
	if event is InputEventKey and event.pressed:
		print("Key pressed: ", event.keycode)
		if event.keycode == KEY_T:
			print("T key detected!")
			_on_button_pressed()  # Trigger button action with T key
