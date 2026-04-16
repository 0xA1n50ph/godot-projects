extends Area3D

@export var bullet_speed := 55.0
@export var bullet_range := 40.0

var travelled_distance = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  position += transform.basis.z * bullet_speed * delta
  travelled_distance += bullet_speed * delta
  if travelled_distance > bullet_range:
    queue_free()
  return
