class_name AnimationComponent extends Node

@onready var input_component := %InputComponent
@onready var headbob := %HeadbobAnim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  input_component.walking_changed.connect(walk_anim)
  return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  return

func walk_anim(is_walking: bool) -> void:
  if is_walking:
    headbob.play("headbob_walk")
  else:
    headbob.pause()
  return