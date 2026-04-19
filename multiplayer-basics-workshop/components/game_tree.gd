class_name GameTree
extends Node

@onready var gui_manager := $GuiMgr
@onready var enet_server := $Server/EnetServer
@onready var server_connector := $Server/ServerConnector
@onready var player_manager := $PlayersMgr

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_manager.gui_host_game.connect(enet_server.start_server)
	gui_manager.gui_join_game.connect(server_connector.connect_to_server)
	enet_server.spawn_player_for_host.connect(player_manager.spawn_player_for_host)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
