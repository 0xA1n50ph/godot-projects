class_name InteractableComputer extends InteractableBase
## A computer that the player can interact with to view and control a SubViewport UI.
## Uses composition with InteractionStateComponent, CameraTransitionComponent, and VirtualInputComponent.

@onready var state: InteractionStateComponent = $InteractionStateComponent
@onready var camera_transition: CameraTransitionComponent = $CameraTransitionComponent
@onready var virtual_input: VirtualInputComponent = $VirtualInputComponent
@onready var interaction_camera: Camera3D = $interaction_camera

var _input_locked := false


func _ready() -> void:
	camera_transition.transition_finished.connect(_on_transition_finished)
	return


func interact(player: Player) -> void:
	if state.is_player_using:
		_exit_pc()
	else:
		_enter_pc(player)
	return


func is_in_use() -> bool:
	return state.is_player_using


func _enter_pc(player: Player) -> void:
	state.enter_interaction(player)
	player.set_can_move(false)
	_input_locked = true
	camera_transition.store_original_camera(get_viewport())
	await camera_transition.transition_to(interaction_camera)
	interaction_started.emit(player)
	return


func _exit_pc() -> void:
	virtual_input.deactivate()
	await camera_transition.transition_back()
	var player := state.get_player()
	state.exit_interaction()
	if player:
		player.set_can_move(true)
	interaction_ended.emit()
	return


func _on_transition_finished() -> void:
	if _input_locked and state.is_player_using:
		_input_locked = false
		virtual_input.activate()
	return


func _input(event: InputEvent) -> void:
	if not state.is_player_using or _input_locked:
		return

	if event.is_action_pressed("exit_pc"):
		_exit_pc()
	return
