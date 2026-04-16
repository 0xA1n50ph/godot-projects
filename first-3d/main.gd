extends Node

@export var enemy : PackedScene
@onready var player := $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var mob = enemy.instantiate()
	
	var spawn_location = get_node("SpawnArea/SpawnLocation")
	spawn_location.progress_ratio = randf()
	
	var player_position = player.position
	mob.enemyInit(spawn_location.position, player_position)
	add_child(mob)
	print("Enemy Spawned: ", mob)
	pass # Replace with function body.
