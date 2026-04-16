extends Node3D

# @onready var bullet_spawn = $Marker3D
var BULLET_MODEL = preload("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  pass

func _physics_process(_delta: float) -> void:
  shoot()
  return

func shoot() -> void:
  if(Input.is_action_pressed("shoot") and %Timer.is_stopped()):
    var bullet = BULLET_MODEL.instantiate()
    get_tree().current_scene.add_child(bullet)
    bullet.transform = %Marker3D.global_transform
    %Timer.start()
  return
