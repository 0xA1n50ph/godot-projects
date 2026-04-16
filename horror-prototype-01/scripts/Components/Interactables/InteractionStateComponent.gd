class_name InteractionStateComponent extends Node
## Manages the interaction state between player and an interactable object.
## Tracks whether the player is currently using the interactable and stores the player reference.

signal state_changed(is_using: bool)

var is_player_using := false
var player_ref: Player = null


func enter_interaction(player: Player) -> void:
	if is_player_using:
		push_warning("Already in interaction state")
		return
	is_player_using = true
	player_ref = player
	state_changed.emit(true)
	return


func exit_interaction() -> void:
	if not is_player_using:
		push_warning("Not in interaction state")
		return
	is_player_using = false
	player_ref = null
	state_changed.emit(false)
	return


func get_player() -> Player:
	return player_ref
