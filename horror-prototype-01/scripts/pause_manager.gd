extends Node

signal game_paused
signal game_unpaused

func _ready() -> void:
  process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_cancel"):
    toggle_pause()

func toggle_pause() -> void:
  if get_tree().paused:
    get_tree().paused = false
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    game_unpaused.emit()
  else:
    get_tree().paused = true
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    game_paused.emit()