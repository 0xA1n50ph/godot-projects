extends RigidBody2D

@onready var brickSprite := $Sprite2D
@onready var brickCollision := $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func hit() -> void:
	brickSprite.visible = false
	brickCollision.disabled = true
	GameManager.addScore(100)
	GameManager.brick_hit.emit()
	var bricksLeft = get_tree().get_nodes_in_group("Bricks")
	if bricksLeft.size() == 1:
		GameManager.levelComplete()
	else:
		await get_tree().create_timer(1).timeout
		queue_free()
	return
