extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  mouse_filter = Control.MOUSE_FILTER_IGNORE
  _update_size()
  get_tree().root.size_changed.connect(_update_size)
  return

func _update_size() -> void:
  var viewport_size = get_viewport_rect().size

  size = viewport_size
  global_position = Vector2.ZERO

  var parent = get_parent()
  if parent is BackBufferCopy:
    parent.rect = Rect2(Vector2.ZERO, viewport_size)
  return
