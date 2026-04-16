class_name VirtualInputComponent extends Node
## Handles input forwarding to a SubViewport for virtual mouse/keyboard interaction.
## Used for interactables like computers that render UI to a SubViewport.

signal activated
signal deactivated

@export var target_viewport_path: NodePath

var target_viewport: SubViewport = null
var virtual_mouse_position := Vector2.ZERO
var is_active := false


func _ready() -> void:
	set_process_input(false)
	if target_viewport_path:
		target_viewport = get_node(target_viewport_path) as SubViewport
	return


func set_target_viewport(viewport: SubViewport) -> void:
	target_viewport = viewport
	return


func activate() -> void:
	if target_viewport == null:
		push_error("No target viewport assigned")
		return
	is_active = true
	# virtual_mouse_position = Vector2(target_viewport.size) / 2.0
	set_process_input(true)
	activated.emit()
	return


func deactivate() -> void:
	is_active = false
	set_process_input(false)
	deactivated.emit()
	return


func _input(event: InputEvent) -> void:
	if not is_active or target_viewport == null:
		return

	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)
	elif event is InputEventMouseButton:
		_handle_mouse_button(event)
	else:
		target_viewport.push_input(event)
	return


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	virtual_mouse_position += event.relative
	virtual_mouse_position = virtual_mouse_position.clamp(
		Vector2.ZERO,
		Vector2(target_viewport.size)
	)

	var virtual_event := InputEventMouseMotion.new()
	virtual_event.position = virtual_mouse_position
	virtual_event.global_position = virtual_mouse_position
	virtual_event.relative = event.relative
	virtual_event.button_mask = event.button_mask
	target_viewport.push_input(virtual_event)
	return


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	var virtual_event := InputEventMouseButton.new()
	virtual_event.position = virtual_mouse_position
	virtual_event.global_position = virtual_mouse_position
	virtual_event.button_index = event.button_index
	virtual_event.pressed = event.pressed
	virtual_event.button_mask = event.button_mask
	virtual_event.double_click = event.double_click
	target_viewport.push_input(virtual_event)
	return


func get_virtual_mouse_position() -> Vector2:
	return virtual_mouse_position
