extends Control

@onready var mouse_cursor = $MouseCursor
@onready var email_window = $EmailWindow
@onready var email_icon = $Desktop/EmailIcon

var subviewport: SubViewport = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  subviewport = get_parent()
  email_icon.pressed.connect(_on_email_icon_pressed)

  _apply_window_theme()
  return

func _input(event: InputEvent) -> void:
  if event is InputEventMouseMotion:
    mouse_cursor.position = event.position
  elif event is InputEventMouseButton:
    print("Mouse Click Position => ", event.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_email_icon_pressed() -> void:
  email_window.visible = true
  return

func _on_close_pressed() -> void:
  email_window.visible = false
  return

func _apply_window_theme() -> void:
  var window_style := StyleBoxFlat.new()
  window_style.bg_color = Color("0d1117")
  window_style.border_color = Color("30363d")
  window_style.set_border_width_all(1)
  window_style.set_corner_radius_all(6)
  window_style.shadow_color = Color(0, 0, 0, 0.5)
  window_style.shadow_size = 8
  email_window.add_theme_stylebox_override("panel", window_style)
  return