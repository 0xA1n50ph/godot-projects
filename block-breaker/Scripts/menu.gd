extends Node2D

@onready var btn_start := $Control/VBoxContainer/Button
@onready var btn_exit := $Control/VBoxContainer/Button2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_start.pressed.connect(_on_start_pressed)
	btn_exit.pressed.connect(_on_exit_pressed)
	return

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level.tscn")
	return

func _on_exit_pressed() -> void:
	get_tree().quit()
	return
