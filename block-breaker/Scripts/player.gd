extends CharacterBody2D

@export var SPEED = 28.0
var paddleInitialY: float

func _ready() -> void:
	paddleInitialY = position.y
	return

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)
	var target_x = clamp(get_viewport().get_mouse_position().x,0.0, get_viewport().get_visible_rect().size.x)
	position.x = lerp(position.x, target_x, SPEED * delta)
	position.y = paddleInitialY
	# velocity = Vector2.ZERO
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Ball":
			print("Collided with Ball")
			# PLAY THE BALL BOUCING SOUND

	return
