extends Node2D

@onready var bottom_limit := $BottomLimit as Node2D
@onready var ground := $Ground as Node2D
@onready var background := $Background as Node2D
@export var clock_scene: PackedScene
@export var clock_radius := 128.0

@export_group("Clock Instances Configs")
@export var time_scale_min := -10.0
@export var time_scale_max := 10.0
@export_range(0.1, 1.0) var scale_min := 0.25
@export_range(0.1, 1.0) var scale_max := 1.0


func _ready() -> void:
	get_window().size_changed.connect(onSizeChanged)
	onSizeChanged()
	return
	
func _process(_delta: float) -> void:
	#if(clock_root != null):
		#var clock = clock_root.get_node("Clock") as Clock
		#clock.setRandomColor(true)
	return


func _on_bottom_body_entered(body: Node2D) -> void:
	body.queue_free()
	#print(body.name, " - Deleted")


func _on_spawn_timer_timeout() -> void:
	var clock_root = clock_scene.instantiate()
	var clock := clock_root.get_node("Clock") as Clock
	clock.start_time = Clock.StartTimeMode.RANDOM_TIME
	clock.time_scale = randf_range(time_scale_min,time_scale_max)
	clock.setScale(randf_range(scale_min,scale_max))
	clock.position = Vector2(randf_range(clock_radius, get_window().size.x - clock_radius),clock_radius * -3)
	add_child(clock_root)
	return
	
func onSizeChanged() -> void:
	bottom_limit.position.y = get_window().size.y + 2.0 * clock_radius
	bottom_limit.scale.x = get_window().size.x
	ground.position.y = get_window().size.y
	ground.position.x = get_window().size.x / 2.0
	ground.scale.x = get_window().size.x
	background.scale = Vector2(get_window().size.x, get_window().size.y)
	return
