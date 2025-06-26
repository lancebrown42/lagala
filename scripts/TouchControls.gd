extends Control

# Touch Controls for Mobile Galaga Clone
class_name TouchControls

# Touch control nodes
@onready var left_button: TouchScreenButton
@onready var right_button: TouchScreenButton  
@onready var shoot_button: TouchScreenButton
@onready var pause_button: TouchScreenButton

# Touch areas
var movement_area: Control
var shoot_area: Control

# Touch state tracking
var is_touching_left: bool = false
var is_touching_right: bool = false
var is_touching_shoot: bool = false
var touch_move_sensitivity: float = 2.0

# Virtual joystick for movement
var virtual_joystick: Control
var joystick_base: TextureRect
var joystick_knob: TextureRect
var joystick_center: Vector2
var joystick_radius: float = 60.0
var is_joystick_active: bool = false
var joystick_touch_index: int = -1

signal move_left_pressed
signal move_left_released
signal move_right_pressed
signal move_right_released
signal shoot_pressed
signal shoot_released
signal pause_pressed

func _ready():
	# Only show touch controls on mobile platforms
	if not is_mobile_platform():
		visible = false
		return
	
	setup_touch_controls()
	setup_virtual_joystick()
	
	# Connect to player if available
	connect_to_player()

func is_mobile_platform() -> bool:
	"""Check if running on mobile platform"""
	var platform = OS.get_name()
	return platform in ["Android", "iOS"]

func setup_touch_controls():
	"""Setup touch control buttons"""
	# Create main container
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Create movement area (left side)
	movement_area = Control.new()
	movement_area.name = "MovementArea"
	movement_area.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
	movement_area.size.x = get_viewport().get_visible_rect().size.x * 0.5
	add_child(movement_area)
	
	# Create shoot area (right side)
	shoot_area = Control.new()
	shoot_area.name = "ShootArea"
	shoot_area.set_anchors_and_offsets_preset(Control.PRESET_RIGHT_WIDE)
	shoot_area.size.x = get_viewport().get_visible_rect().size.x * 0.5
	add_child(shoot_area)
	
	# Create shoot button
	create_shoot_button()
	
	# Create pause button
	create_pause_button()

func setup_virtual_joystick():
	"""Setup virtual joystick for movement"""
	virtual_joystick = Control.new()
	virtual_joystick.name = "VirtualJoystick"
	virtual_joystick.size = Vector2(120, 120)
	virtual_joystick.position = Vector2(40, get_viewport().get_visible_rect().size.y - 160)
	movement_area.add_child(virtual_joystick)
	
	# Create joystick base
	joystick_base = TextureRect.new()
	joystick_base.name = "JoystickBase"
	joystick_base.size = Vector2(120, 120)
	joystick_base.texture = create_joystick_base_texture()
	joystick_base.modulate = Color(1, 1, 1, 0.6)
	virtual_joystick.add_child(joystick_base)
	
	# Create joystick knob
	joystick_knob = TextureRect.new()
	joystick_knob.name = "JoystickKnob"
	joystick_knob.size = Vector2(60, 60)
	joystick_knob.position = Vector2(30, 30)
	joystick_knob.texture = create_joystick_knob_texture()
	joystick_knob.modulate = Color(1, 1, 1, 0.8)
	virtual_joystick.add_child(joystick_knob)
	
	joystick_center = virtual_joystick.position + Vector2(60, 60)

func create_shoot_button():
	"""Create the shoot button"""
	shoot_button = TouchScreenButton.new()
	shoot_button.name = "ShootButton"
	shoot_button.texture_normal = create_shoot_button_texture()
	shoot_button.size = Vector2(100, 100)
	shoot_button.position = Vector2(
		get_viewport().get_visible_rect().size.x - 140,
		get_viewport().get_visible_rect().size.y - 140
	)
	shoot_button.modulate = Color(1, 1, 1, 0.7)
	
	# Connect signals
	shoot_button.pressed.connect(_on_shoot_pressed)
	shoot_button.released.connect(_on_shoot_released)
	
	add_child(shoot_button)

func create_pause_button():
	"""Create the pause button"""
	pause_button = TouchScreenButton.new()
	pause_button.name = "PauseButton"
	pause_button.texture_normal = create_pause_button_texture()
	pause_button.size = Vector2(60, 60)
	pause_button.position = Vector2(
		get_viewport().get_visible_rect().size.x - 80,
		20
	)
	pause_button.modulate = Color(1, 1, 1, 0.6)
	
	# Connect signal
	pause_button.pressed.connect(_on_pause_pressed)
	
	add_child(pause_button)

func create_joystick_base_texture() -> ImageTexture:
	"""Create joystick base texture"""
	var image = Image.create(120, 120, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Draw circle
	var center = Vector2(60, 60)
	for y in range(120):
		for x in range(120):
			var dist = Vector2(x, y).distance_to(center)
			if dist <= 58:
				var alpha = 1.0 - (dist / 58.0) * 0.5
				image.set_pixel(x, y, Color(0.3, 0.3, 0.3, alpha * 0.5))
			elif dist <= 60:
				image.set_pixel(x, y, Color(0.6, 0.6, 0.6, 0.8))
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func create_joystick_knob_texture() -> ImageTexture:
	"""Create joystick knob texture"""
	var image = Image.create(60, 60, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Draw circle
	var center = Vector2(30, 30)
	for y in range(60):
		for x in range(60):
			var dist = Vector2(x, y).distance_to(center)
			if dist <= 28:
				var alpha = 1.0 - (dist / 28.0) * 0.3
				image.set_pixel(x, y, Color(0.8, 0.8, 0.8, alpha * 0.8))
			elif dist <= 30:
				image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 0.9))
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func create_shoot_button_texture() -> ImageTexture:
	"""Create shoot button texture"""
	var image = Image.create(100, 100, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Draw circle background
	var center = Vector2(50, 50)
	for y in range(100):
		for x in range(100):
			var dist = Vector2(x, y).distance_to(center)
			if dist <= 48:
				var alpha = 1.0 - (dist / 48.0) * 0.3
				image.set_pixel(x, y, Color(1.0, 0.3, 0.3, alpha * 0.6))
			elif dist <= 50:
				image.set_pixel(x, y, Color(1.0, 0.5, 0.5, 0.8))
	
	# Draw "FIRE" text pattern (simple)
	for y in range(40, 60):
		for x in range(30, 70):
			if (x - 30) % 8 < 4 and (y - 40) % 8 < 4:
				image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 0.9))
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func create_pause_button_texture() -> ImageTexture:
	"""Create pause button texture"""
	var image = Image.create(60, 60, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)
	
	# Draw circle background
	var center = Vector2(30, 30)
	for y in range(60):
		for x in range(60):
			var dist = Vector2(x, y).distance_to(center)
			if dist <= 28:
				image.set_pixel(x, y, Color(0.5, 0.5, 0.5, 0.6))
			elif dist <= 30:
				image.set_pixel(x, y, Color(0.7, 0.7, 0.7, 0.8))
	
	# Draw pause bars
	for y in range(15, 45):
		for x in range(18, 24):
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 0.9))
		for x in range(36, 42):
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 0.9))
	
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func _input(event):
	"""Handle touch input events"""
	if not visible:
		return
		
	if event is InputEventScreenTouch:
		handle_touch_event(event)
	elif event is InputEventScreenDrag:
		handle_drag_event(event)

func handle_touch_event(event: InputEventScreenTouch):
	"""Handle touch press/release events"""
	var touch_pos = event.position
	
	if event.pressed:
		# Check if touch is in joystick area
		if is_point_in_joystick_area(touch_pos):
			start_joystick_input(event.index, touch_pos)
	else:
		# Release joystick if this was the joystick touch
		if event.index == joystick_touch_index:
			stop_joystick_input()

func handle_drag_event(event: InputEventScreenDrag):
	"""Handle touch drag events"""
	if event.index == joystick_touch_index and is_joystick_active:
		update_joystick_position(event.position)

func is_point_in_joystick_area(point: Vector2) -> bool:
	"""Check if point is within joystick area"""
	var joystick_global_pos = virtual_joystick.global_position + Vector2(60, 60)
	return point.distance_to(joystick_global_pos) <= joystick_radius * 1.5

func start_joystick_input(touch_index: int, touch_pos: Vector2):
	"""Start joystick input"""
	joystick_touch_index = touch_index
	is_joystick_active = true
	update_joystick_position(touch_pos)

func stop_joystick_input():
	"""Stop joystick input"""
	is_joystick_active = false
	joystick_touch_index = -1
	
	# Reset knob position
	joystick_knob.position = Vector2(30, 30)
	
	# Release movement
	if is_touching_left:
		is_touching_left = false
		emit_signal("move_left_released")
	if is_touching_right:
		is_touching_right = false
		emit_signal("move_right_released")

func update_joystick_position(touch_pos: Vector2):
	"""Update joystick knob position and emit movement signals"""
	var joystick_global_center = virtual_joystick.global_position + Vector2(60, 60)
	var offset = touch_pos - joystick_global_center
	
	# Clamp to joystick radius
	if offset.length() > joystick_radius:
		offset = offset.normalized() * joystick_radius
	
	# Update knob position
	joystick_knob.position = Vector2(30, 30) + offset
	
	# Determine movement direction
	var horizontal_input = offset.x / joystick_radius
	
	# Handle left movement
	if horizontal_input < -0.3:
		if not is_touching_left:
			is_touching_left = true
			emit_signal("move_left_pressed")
	else:
		if is_touching_left:
			is_touching_left = false
			emit_signal("move_left_released")
	
	# Handle right movement
	if horizontal_input > 0.3:
		if not is_touching_right:
			is_touching_right = true
			emit_signal("move_right_pressed")
	else:
		if is_touching_right:
			is_touching_right = false
			emit_signal("move_right_released")

func connect_to_player():
	"""Connect touch controls to player"""
	var player = get_node_or_null("../GameWorld/Player")
	if player:
		# Connect movement signals
		move_left_pressed.connect(player._on_move_left_pressed)
		move_left_released.connect(player._on_move_left_released)
		move_right_pressed.connect(player._on_move_right_pressed)
		move_right_released.connect(player._on_move_right_released)
		
		# Connect shoot signals
		shoot_pressed.connect(player._on_shoot_pressed)
		shoot_released.connect(player._on_shoot_released)
		
		print("Touch controls connected to player")
	else:
		print("Warning: Could not find player to connect touch controls")

# Signal handlers
func _on_shoot_pressed():
	"""Handle shoot button press"""
	is_touching_shoot = true
	emit_signal("shoot_pressed")

func _on_shoot_released():
	"""Handle shoot button release"""
	is_touching_shoot = false
	emit_signal("shoot_released")

func _on_pause_pressed():
	"""Handle pause button press"""
	emit_signal("pause_pressed")
	
	# Also trigger the main pause function
	var main_scene = get_node_or_null("../")
	if main_scene and main_scene.has_method("toggle_pause"):
		main_scene.toggle_pause()

# Utility functions
func set_touch_controls_visible(visible: bool):
	"""Show/hide touch controls"""
	self.visible = visible and is_mobile_platform()

func set_touch_sensitivity(sensitivity: float):
	"""Adjust touch sensitivity"""
	touch_move_sensitivity = clamp(sensitivity, 0.5, 5.0)
