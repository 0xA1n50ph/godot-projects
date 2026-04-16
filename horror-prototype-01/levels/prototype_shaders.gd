extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # PauseManager.game_paused.connect(_on_game_paused)
  # PauseManager.game_unpaused.connect(_on_game_unpaused)
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_game_paused() -> void:
  visible = false
  return

func _on_game_unpaused() -> void:
    visible = true