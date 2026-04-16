extends Node2D

@onready var brickObject = preload("res://Scenes/S_Brick.tscn")
@export var columns := 18
@export var rows := 7
@export var margin := 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.register_ui($UI/ScoreLabel,$UI/LevelLabel)
	GameManager.register_lives([$UI/LivesIcon1,$UI/LivesIcon2,$UI/LivesIcon3] as Array[Sprite2D])
	setupLevel()
	setup_background_shader()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	GameManager.gameover.connect(_on_game_over)
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func setupLevel() -> void:
	var colors = getBrickColors()
	colors.shuffle()

	var brick_width := 42
	var brick_height := 28
	var screen_width := get_viewport_rect().size.x
	var grid_width := brick_width * columns
	var start_x = (screen_width - grid_width) / 2.0

	for row in rows:
		for column in columns:
			# var randomBricks := randi_range(0, 2)
			# if randomBricks == 2:
				var brick = brickObject.instantiate()
				brick.position = Vector2(start_x + (brick_width * column), (margin + 60) + (brick_height * row))
				brick.rotation = 0
				var sprite = brick.get_node("Sprite2D")
				if row <= 9:
					sprite.modulate = colors[0]
				if(row < 6):
					sprite.modulate = colors[1]
				if(row < 3):
					sprite.modulate = colors[2]
				add_child(brick)
	return

func getBrickColors() -> Array:
	var colors = [
		Color(0,1,1,1),
		Color(0.54, 0.54, 0.89, 1),
		Color(0.68, 1, 0.18, 1),
		Color(1,1,1,1)
	]
	return colors

func setup_background_shader() -> void:
	var bg = $Background
	var mat: ShaderMaterial = bg.material as ShaderMaterial

	var count := randi_range(3, 6)
	mat.set_shader_parameter("emitter_count", count)

	var positions: Array = []
	for i in count:
		positions.append(Vector2(randf_range(0.1, 0.9), randf_range(0.1, 0.9)))
	while positions.size() < 6:
		positions.append(Vector2.ZERO)
	mat.set_shader_parameter("emitters", PackedVector2Array(positions))

	var freqs := PackedFloat32Array()
	var spds := PackedFloat32Array()
	var amps := PackedFloat32Array()
	var phases := PackedFloat32Array()
	for i in 6:
		freqs.append(randf_range(8.0, 25.0))
		spds.append(randf_range(0.3, 1.2))
		amps.append(randf_range(0.05, 0.20))
		phases.append(randf_range(0.0, TAU))
	mat.set_shader_parameter("frequencies", freqs)
	mat.set_shader_parameter("speeds", spds)
	mat.set_shader_parameter("amplitudes", amps)
	mat.set_shader_parameter("phase_offsets", phases)

	var palettes := [
		[Color(0.02, 0.02, 0.12), Color(0.05, 0.15, 0.35), Color(0.15, 0.45, 0.65)],
		[Color(0.05, 0.02, 0.10), Color(0.20, 0.05, 0.30), Color(0.50, 0.15, 0.55)],
		[Color(0.02, 0.08, 0.05), Color(0.05, 0.25, 0.15), Color(0.10, 0.55, 0.35)],
		[Color(0.08, 0.02, 0.02), Color(0.30, 0.05, 0.08), Color(0.60, 0.15, 0.12)],
		[Color(0.02, 0.05, 0.10), Color(0.10, 0.20, 0.35), Color(0.30, 0.50, 0.70)],
	]
	var palette: Array = palettes[randi() % palettes.size()]
	mat.set_shader_parameter("color_deep", palette[0])
	mat.set_shader_parameter("color_mid", palette[1])
	mat.set_shader_parameter("color_bright", palette[2])
	mat.set_shader_parameter("aspect_ratio", 1152.0 / 648.0)


func _on_game_over() -> void:
	get_tree().reload_current_scene()
	return
