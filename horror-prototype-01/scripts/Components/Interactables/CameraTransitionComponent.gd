class_name CameraTransitionComponent extends Node
## Handles smooth camera transitions between the player camera and an interaction camera.
## Reusable for any interactable that needs camera focus (computers, terminals, etc.)

signal transition_started
signal transition_finished

@export var transition_duration := 1.5
@export var ease_type := Tween.EASE_IN_OUT
@export var trans_type := Tween.TRANS_CUBIC

var original_camera: Camera3D = null
var _is_transitioning := false


func store_original_camera(viewport: Viewport) -> void:
	original_camera = viewport.get_camera_3d()
	return


func transition_to(target_camera: Camera3D) -> void:
	if _is_transitioning:
		push_warning("Already transitioning")
		return
	await _perform_transition(target_camera)
	return


func transition_back() -> void:
	if _is_transitioning:
		push_warning("Already transitioning")
		return
	if original_camera == null:
		push_error("No original camera stored")
		return
	await _perform_transition(original_camera)
	original_camera = null
	return


func _perform_transition(target_camera: Camera3D) -> void:
	_is_transitioning = true
	transition_started.emit()

	var current_camera := get_viewport().get_camera_3d()
	var start_transform := current_camera.global_transform
	var end_transform := target_camera.global_transform

	target_camera.global_transform = start_transform
	target_camera.current = true

	var tween := create_tween()
	tween.set_ease(ease_type)
	tween.set_trans(trans_type)
	tween.tween_property(target_camera, "global_transform", end_transform, transition_duration)
	await tween.finished

	_is_transitioning = false
	transition_finished.emit()
	return


func is_transitioning() -> bool:
	return _is_transitioning
