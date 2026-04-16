class_name InputComponent extends Node

signal walking_changed(is_walking: bool)
var _is_walking: bool = false
var is_crouching := false
var is_sprinting := false
var flashlight_status := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide the cursor on game start
  return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void: return

func interaction_handler(player: Player) -> void: 
  var is_item = player.front_check.is_colliding()

  if Input.is_action_just_pressed("interact"):
    if is_item:
      var collisionResult = player.front_check.get_collision_result()[0]["collider"]
      if collisionResult.is_in_group("computers") and collisionResult.has_method("interact"):
        walking_changed.emit(false)
        collisionResult.interact(player)
      if collisionResult.is_in_group("collectible"):
        print("IS COLLECTIBLE!")

  if Input.is_action_just_pressed("flashlight"):
    var temp_flashlight: SpotLight3D
    if not flashlight_status:
      temp_flashlight = SpotLight3D.new()
      # temp_flashlight.transform(player.front_check.)
      temp_flashlight.translate_object_local(Vector3(-90,0,0))
      player.add_child(temp_flashlight)
      flashlight_status = true
    else:
      var test = player.get_child(-1)
      test.queue_free()
      flashlight_status = false
      print("Light is off ", test)
  return

func movement_handler(player: Player, walk_speed: float, delta: float) -> void: 
  var wants_to_crouch = Input.is_action_pressed("crouch")
  var wants_to_sprint = Input.is_action_pressed("sprint")
  var collision_shape = player.collisionShape.shape as CapsuleShape3D
  var target_height: float
  var target_camera_y: float

  if not player.is_on_floor():
    player.velocity += player.get_gravity() * delta
  if player.JUMP_ENABLE:
    if Input.is_action_just_pressed("jump") and player.is_on_floor():
      player.velocity.y = player.JUMP_VELOCITY

  var input_dir = Input.get_vector("right", "left", "backward", "forward")
  var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

  var was_walking = _is_walking
  
  if wants_to_crouch:
    is_crouching = true
  elif is_crouching:
    if not player.top_check.is_colliding():
      is_crouching = false

  if wants_to_sprint:
    if not is_crouching:
      walk_speed = player.SPRINT_SPEED
  else:
    walk_speed = player.SPEED

  if is_crouching:
    target_height = player.CROUCH_HEIGHT
    target_camera_y = player.CROUCH_HEIGHT * 0.8
    player.SPEED = player.CROUCH_SPEED
  else:
    target_height = player.PLAYER_HEIGHT
    target_camera_y = player.PLAYER_HEIGHT * 0.8
    player.SPEED = player.base_speed

  if direction:
    player.velocity.x = direction.x * walk_speed
    player.velocity.z = direction.z * walk_speed
    _is_walking = true
  else:
    player.velocity.x = move_toward(player.velocity.x, 0, walk_speed)
    player.velocity.z = move_toward(player.velocity.z, 0, walk_speed)
    _is_walking = false
  if _is_walking != was_walking:
    walking_changed.emit(_is_walking)

  collision_shape.height = lerp(collision_shape.height, target_height, player.CROUCH_TRANSITION_SPEED * delta)
  player.collisionShape.position.y = lerp(player.collisionShape.position.y, target_height / 2.0, player.CROUCH_TRANSITION_SPEED * delta)
  player.camera_holder.position.y = lerp(player.camera_holder.position.y, target_camera_y, player.CROUCH_TRANSITION_SPEED * delta)
  return

func camera_handler(player: Player, mouse_sensitivity: float, event: InputEvent) -> void: 
  player.camera.rotation_degrees.x -= event.screen_relative.y*(mouse_sensitivity/10.0)
  player.camera.rotation_degrees.x = clamp(player.camera.rotation_degrees.x, -90, 90)
  player.rotation_degrees.y -= event.screen_relative.x*(mouse_sensitivity/10.0)
  return
