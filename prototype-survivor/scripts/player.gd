extends CharacterBody3D

@export var mouse_sensitivity := 5.0
@export var joystick_sensitivity := 6.0
@export var speed := 5.0
@export var jump_impulse := 8
@export var gravity := 20
@export var bottom_map_limit := -30.0
@export var sprint_speed := 12.0
@export var joystick_deadzone := 0.2

@onready var camera = $Camera

func _ready():
  # Hide the curson os game start
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  print_debug("SPEED => ", speed)
  return

func _physics_process(_delta: float) -> void:
  var input_direction = Input.get_vector("move_left","move_right","move_forward","move_backward");
  var direction = transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)
  velocity.x = direction.x * speed
  velocity.z = direction.z * speed
  velocity.y -= gravity * _delta
	if(Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y += jump_impulse
  move_and_slide()
  fall_death()
  sprint_handle()
  joystick_camera_handle(_delta)
  return

func _unhandled_key_input(event: InputEvent) -> void:
  if(event.is_action_pressed("ui_cancel")):
	show_mouse(event)
  if(Input.is_key_pressed(KEY_R) and OS.is_debug_build()):
	get_tree().reload_current_scene()
  return

func _unhandled_input(event: InputEvent) -> void:
  var sensi = mouse_sensitivity/10.0
  if event is InputEventMouseMotion:
	rotation_degrees.y -= event.screen_relative.x*sensi
	camera.rotation_degrees.x -= event.screen_relative.y*sensi
	# Limits the camera rotation on X axis to 90 degrees
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
  return

func sprint_handle() -> void:
  if(Input.is_action_just_pressed("sprint")):
	speed = sprint_speed
  if(Input.is_action_just_released("sprint")):
	speed = 5.0
  return

func joystick_camera_handle(delta: float) -> void:
  var joy_look_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
  var joy_look_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
  var deadzone = joystick_deadzone #Evitar drifting
  if abs(joy_look_x) > deadzone or abs(joy_look_y) > deadzone:
	var joy_sensi = joystick_sensitivity
	rotation_degrees.y -= joy_look_x * joy_sensi * delta * 60.0
	camera.rotation_degrees.x -= joy_look_y * joy_sensi * delta * 60.0
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
  return

func fall_death() -> void:
  if(velocity.y <= bottom_map_limit):  
	get_tree().reload_current_scene()
  return

func show_mouse(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel") and Input.mouse_mode == 2:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  elif event.is_action_pressed("ui_cancel") and Input.mouse_mode == 0:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  return
