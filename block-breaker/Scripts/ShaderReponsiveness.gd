extends ColorRect

var stretchMode: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  mouse_filter = Control.MOUSE_FILTER_IGNORE
  _update_size()
  get_tree().root.size_changed.connect(_update_size)
  stretchMode = ProjectSettings.get_setting("display/window/stretch/mode") as String
  return

func _update_size() -> void:
  
  var viewport_size = get_viewport_rect().size
  var window_size := get_window().size
  print_debug("WINDOW SIZE CHANGED: ", window_size)
  print_debug("STRETCH MODE: ", stretchMode)
  size = viewport_size
  global_position = Vector2.ZERO

  var parent = get_parent()
  if parent is BackBufferCopy:
    parent.rect = Rect2(Vector2.ZERO, window_size)
  return
