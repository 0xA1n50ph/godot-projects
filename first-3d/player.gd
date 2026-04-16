extends CharacterBody3D

@export var speed = 14
@export var fall_accelaration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16
@onready var Pivot = $Pivot

var target_velocity = Vector3.ZERO

func _physics_process(_delta: float) -> void:
	var direction = Vector3.ZERO
	
	if(Input.is_action_pressed("move_forward")):
		direction.z -= 1
	if(Input.is_action_pressed("move_backward")):
		direction.z += 1
	if(Input.is_action_pressed("move_right")):
		direction.x += 1
	if(Input.is_action_pressed("move_left")):
		direction.x -= 1
	if(Input.is_action_just_pressed("jump") && is_on_floor()):
		target_velocity.y = jump_impulse
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if(collision.get_collider().is_in_group("enemy")):
			print("collision: ", collision)
			var mob = collision.get_collider()
			if(Vector3.UP.dot(collision.get_normal()) > 0.1):
				mob.squash()
				target_velocity.y = bounce_impulse
				break
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		Pivot.basis = Basis.looking_at(direction)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	#target_velocity.y = direction.y * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_accelaration * _delta)
	
	velocity = target_velocity
	move_and_slide()
	return
