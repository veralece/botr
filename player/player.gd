extends CharacterBody3D
#speed and fall force (gravity)
@export var speed = 14.0
@export var jump_impulse = 20.0
@export var gravity = 75.0
@export var bounce_impulse = 16.0
@export var rotation_speed = 5.0
func _physics_process(delta):
	var direction = Vector3.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var is_jumping = Input.is_action_just_pressed("jump") && is_on_floor()
	
	#check to see if direction was modified on this frame, then normalize it.
	if direction != Vector3.ZERO:
		direction = direction.rotated(Vector3.UP, %CameraPivot.rotation.y).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	
	if is_jumping:
		velocity.y += jump_impulse
	
	if velocity.length() > 1.25:
		var look_direction = Vector2(velocity.z, velocity.x)
		%Rat.rotation.y = lerp_angle(%Rat.rotation.y, look_direction.angle(), delta * rotation_speed)
	
	if (abs(velocity.x) > 1.0 || abs(velocity.z) > 1.0) && is_on_floor():
		%Rat.play_walk()
	else: 
		%Rat.stop_walk()
	
	move_and_slide()

func _process(_delta):
	%CameraPivot.position = position
