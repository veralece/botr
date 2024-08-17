extends CharacterBody3D
#speed and fall force (gravity)
@export var speed = 14.0
@export var jump_impulse = 20.0
@export var gravity = 75.0
@export var bounce_impulse = 16.0

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y += jump_impulse
	
	#check to see if direction was modified on this frame, then normalize it.
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		%Rat.look_at(position + direction, Vector3.UP)
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	#velocity.y -= gravity * delta
	
	if (abs(velocity.x) > 1.0 || abs(velocity.z) > 1.0) && is_on_floor():
		%Rat.play_walk()
	else: 
		%Rat.stop_walk()
	
	move_and_slide()
