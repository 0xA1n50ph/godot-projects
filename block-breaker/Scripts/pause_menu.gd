extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.game_paused.connect(_on_game_paused)
	GameManager.game_unpaused.connect(_on_game_unpaused)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_paused() -> void:
	visible = true

func _on_game_unpaused() -> void:
	visible = false