extends CharacterBody2D

@export var speed := 350.0
@export var maxSpeed := 800.0
@export var speedIncrement := 25.0
@export var maxBounceAngleDeg := 60.0
@export var minVerticalRatio := 0.25
@onready var paddle = get_parent().get_node("Player")

var direction := Vector2.DOWN
var isActive := false
var initialPos := Vector2()
var currentSpeed := speed
var paddleHalfWidth := 0.0
var launchDirection := Vector2.UP

func _ready() -> void:
	currentSpeed = speed
	paddleHalfWidth = (paddle.get_node("CollisionShape2D").shape as CapsuleShape2D).height / 2.0
	velocity = Vector2(speed,speed)
	print("Ball Pos: ", position)
	position = Vector2(paddle.position.x,paddle.position.y)
	GameManager.brick_hit.connect(_on_brick_hit)
	return

func _physics_process(delta: float) -> void:
	if isActive:
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider == paddle:
				var hit_offset = clamp((position.x - paddle.position.x) / paddleHalfWidth, -1.0, 1.0)
				var angle = deg_to_rad(hit_offset * maxBounceAngleDeg)
				velocity = Vector2(sin(angle), -cos(angle)) * currentSpeed
				if(position.y > paddle.position.y):
					velocity = Vector2(sin(angle), cos(angle)) * currentSpeed
				# Unecessary now but can be useful if the ball got stuck inside the paddle(Remove in the future)
				# var paddle_top = paddle.position.y - paddleHalfWidth
				# if position.y > paddle_top:
				# 	position.y = paddle_top - 1.0
			else:
				velocity = velocity.bounce(collision.get_normal())
				minVerticalCheck()
				if collider.has_method("hit"):
					collider.call("hit")
	else:
		position = Vector2(paddle.position.x,paddle.position.y-14)
		var mouse_x = get_global_mouse_position().x
		var offset = clamp((mouse_x - paddle.position.x) / paddleHalfWidth, -1.0, 1.0)
		var angle = deg_to_rad(offset * maxBounceAngleDeg)
		launchDirection = Vector2(sin(angle), -cos(angle))
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("trigger") and isActive == false:
		isActive = true
		velocity = launchDirection * currentSpeed
	return

func _on_death_zone_body_entered(body: Node2D) -> void:
	if(body.name == "Ball"):
		print("BALL DIED ==> ", body.name)
		death()
	return

func _on_brick_hit() -> void:
	currentSpeed =  minf(currentSpeed + speedIncrement, maxSpeed)
	velocity = velocity.normalized() * currentSpeed
	print("Ball speed: ", currentSpeed)
	return

func death() -> void:
	isActive = false
	GameManager.lose_life()
	position = initialPos
	currentSpeed = speed
	return

func minVerticalCheck() -> void:
	var min_y = currentSpeed * minVerticalRatio
	if abs(velocity.y) < min_y:
		# velocity.y = min_y * sign(velocity.y)
		velocity.y = min_y if velocity.y >= 0 else -min_y
		velocity = velocity.normalized() * currentSpeed
	return