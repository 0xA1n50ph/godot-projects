extends Node

var score := 0
var level := 1
var lives := 3

signal gameover
signal brick_hit
signal game_paused
signal game_unpaused

var scoreLabel: Label
var levelLabel: Label
var lifeIcons: Array[Sprite2D] = []
var gamePauseStatus := false
var currentScene: Node
var pauseScreenInstance: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("GAME MANAGER IS LOADED!")
	process_mode = Node.PROCESS_MODE_ALWAYS
	brick_hit.connect(_on_brick_hit)
	return

func _input(event: InputEvent) -> void:
	currentScene = get_tree().current_scene
	if event.is_action_pressed("ui_cancel"):
		if currentScene != null and currentScene.name == "Level":
			gamePause()
	return

func register_ui(score_label: Label, level_label: Label) -> void:
	scoreLabel = score_label
	levelLabel = level_label
	update_ui()
	return

func register_lives(icons: Array[Sprite2D]) -> void:
	lifeIcons = icons
	_update_lives_ui()

func addScore(value: int) -> void:
	score += value
	update_ui()
	return

func lose_life() -> void:
	lives -= 1
	_update_lives_ui()
	if lives <= 0:
		game_over()

func update_ui() -> void:
	if scoreLabel:
		scoreLabel.text = str(score)
	if levelLabel:
		levelLabel.text = "Level: "+str(level)
	return

func _update_lives_ui() -> void:
	for i in lifeIcons.size():
		lifeIcons[i].visible = i < lives
	return

func _on_brick_hit() -> void:
	print("BRICK HIT!")
	return

func game_over() -> void:
	print("GAME OVER")
	# get_tree().get("Ball").queue_free()
	score = 0
	lives = 3
	level = 1
	gameover.emit()
	return

func levelComplete() -> void:
	level += 1
	get_tree().reload_current_scene()
	return

func gamePause() -> void:
	if !gamePauseStatus:
		print("PAUSE!")
		gamePauseStatus = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		game_paused.emit()
	else:
		print("UNPAUSE!")
		gamePauseStatus = false
		get_tree().paused = false
		game_unpaused.emit()
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)	
	return
