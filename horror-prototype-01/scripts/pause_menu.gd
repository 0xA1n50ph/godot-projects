extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  visible = false
  process_mode = Node.PROCESS_MODE_ALWAYS

  PauseManager.game_paused.connect(_on_game_paused)
  PauseManager.game_unpaused.connect(_on_game_unpaused)
  return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  pass

func _on_game_paused() -> void:
  visible = true

func _on_game_unpaused() -> void:
  visible = false