extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 2.0
var footstepTimerReset := .3
var footstepTimer = 0
var camera_x_rotation := 0.0
@onready var camera = get_node("Camera3D")

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  pass


func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
    camera.rotation_degrees.x -= event.screen_relative.y*(MOUSE_SENSITIVITY/10.0)
    camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
    self.rotation_degrees.y -= event.screen_relative.x*(MOUSE_SENSITIVITY/10.0)
  return

func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  if Input.is_action_just_pressed("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    

  # Handle jump.
  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir := Input.get_vector("left", "right", "forward", "backward")
  var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
    if footstepTimer <= 0:
      $FmodEventEmitter3D.play()
      footstepTimer = footstepTimerReset
    footstepTimer -= delta
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()
