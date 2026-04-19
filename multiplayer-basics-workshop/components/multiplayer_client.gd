class_name MultiplayerClient
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enter_tree() -> void:
	var peer_id := str(name).to_int()
	print("PEER ID => ", peer_id)
	set_multiplayer_authority(peer_id)