class_name Clock
extends RigidBody2D

#const SYSTEM_TIME := 0
#const RANDOM_TIME := 1
enum StartTimeMode { 
	SYSTEM_TIME, 
	RANDOM_TIME, 
	FIXED_TIME, 
	OFFSET_TIME 
}

## Time scale of the clock, can be negative.
@export var time_scale := 1.0
## What time to use fort the starting time of the clock.
@export var start_time := StartTimeMode.SYSTEM_TIME
@export_group("Fixed or Offset Start Time")
@export_range(-11, 11) var start_hour := 0
@export_range(0, 59) var start_minute := 0
@export_range(0, 59) var start_second := 0

@export_group("Clock Nodes")
@export var collision_shape : CollisionShape2D
@export var visualization : Node2D
@export_subgroup("Arms")
@export var hour_arm: Node2D
@export var minute_arm: Node2D
@export var second_arm: Node2D

var seconds: float


#@onready var hour_arm := $HourArm as Node2D
#@onready var minute_arm := $MinuteArm as Node2D
#@onready var second_arm := $SecondArm as Node2D

func _ready() -> void:
	match start_time:
		StartTimeMode.RANDOM_TIME:
			seconds = randf_range(0.0, 43200.0)
		StartTimeMode.FIXED_TIME:
			seconds = start_second + start_minute * 60 + start_hour * 3600
		StartTimeMode.SYSTEM_TIME:
			var current_time := Time.get_datetime_dict_from_system()
			seconds = float(current_time.second + current_time.minute * 60.0 + current_time.hour * 3600.0)
			setTime()
		StartTimeMode.OFFSET_TIME:
			seconds += start_second + start_minute * 60.0 + start_hour * 3600.0
	return

func _process(_delta: float) -> void:
	seconds += _delta * time_scale
	setTime()
	setRandomColor()
	return
	
func setTime() -> void:
	hour_arm.rotation = fmod(seconds / 3600.0, 12.0) * TAU / 12.0
	minute_arm.rotation = fmod(seconds / 60.0, 60.0) * TAU / 60.0
	second_arm.rotation = fmod(seconds, 60.0) * TAU / 60.0
	return
	
func setScale(scale_value: float) -> void:
	scale = Vector2(scale_value, scale_value)
	visualization.scale = scale
	hour_arm.scale = scale
	minute_arm.scale = scale
	second_arm.scale = scale
	collision_shape.scale = scale
	mass *= scale_value * scale_value
	return
	
func setRandomColor(_party_mode := false) -> void:
	#print("Seconds: ", seconds)
	if(_party_mode == false):
		visualization.self_modulate = Color.from_hsv(seconds/1000, 0.25, 1.0)
	else:
		visualization.self_modulate = Color(randf(), randf(), randf())
	return
	
	
