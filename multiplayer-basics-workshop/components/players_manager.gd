class_name PlayerManager
extends Node

const PLAYER = preload("res://entities/player.tscn")
const MULTIPLAYER_CLIENT = preload("res://components/multiplayer_client.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(on_peer_connected)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_peer_connected(peer_id: int) -> void:
	var player = MULTIPLAYER_CLIENT.instantiate()
	player.name = str(peer_id)
	print("Player : ", player.name, " connected!")
	add_child(player)
	# player.add_child(MULTIPLAYER_CLIENT.instantiate())
	return

func spawn_player_for_host() -> void:
	on_peer_connected(1)
	return