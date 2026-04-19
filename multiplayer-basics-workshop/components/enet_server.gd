class_name EnetServer
extends Node

signal spawn_player_for_host

func start_server(port: int, maxPlayers: int = 16) -> void:
	var network := ENetMultiplayerPeer.new()
	network.create_server(port, maxPlayers)
	multiplayer.multiplayer_peer = network

	spawn_player_for_host.emit()
	print("Hosting server on: ", port)
	return