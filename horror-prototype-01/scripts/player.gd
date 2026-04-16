class_name Player extends CharacterBody3D

@export var SPEED := 2.5
@export var SPRINT_SPEED := 4.5
@export var JUMP_VELOCITY := 4.5
@export var CROUCH_SPEED := 1.5
@export var MOUSE_SENSITIVITY := 1.0
@export var JUMP_ENABLE := false

@export var PLAYER_HEIGHT := 2.0
@export var CROUCH_HEIGHT := 1.0
@export var CROUCH_TRANSITION_SPEED := 4.0

@onready var input_component: InputComponent = %InputComponent

@onready var camera_holder = $CameraHolder
@onready var camera = $CameraHolder/Camera3D
@onready var collisionShape = $CollisionShape3D
@onready var top_check = $TopCheckRayCast
@onready var front_check = $CameraHolder/Camera3D/FrontCheckShapeCast3D
@onready var headbob = $HeadbobAnim
@onready var footstep_audio = $FootstepAudio3D


var base_speed := SPEED
var is_sprinting := false
var can_move: bool = true

func set_can_move(value: bool) -> void:
  can_move = value
  return

func _ready() -> void:
  base_speed = SPEED
  return

func _physics_process(delta: float) -> void:
  if not can_move:
    return
  input_component.movement_handler(self, SPEED, delta)
  input_component.interaction_handler(self)
  move_and_slide()
  return

func _input(event: InputEvent) -> void:
  if not can_move:
      return
  if event is InputEventMouseMotion:
    input_component.camera_handler(self, MOUSE_SENSITIVITY, event)
  return
