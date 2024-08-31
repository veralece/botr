extends CharacterBody3D
#speed and fall force (gravity)
@export var current_item: Node3D = null
@export var speed = 14.0
@export var jump_impulse = 20.0
@export var gravity = 75.0
@export var bounce_impulse = 16.0
@export var rotation_speed = 5.0

enum ACTIONS {IDLE, WALKING, JUMPING, PROCESSING, ATTACKING}
var action_state = ACTIONS.IDLE
var actionable_item = null

func _input(event):
	#if event.is_action_pressed("attack"):
			#attack()
	if event.is_action_pressed("action"):
		if actionable_item != null: 
			if actionable_item.is_in_group("equippable_items"):
				if current_item != actionable_item:
					change_equipped_item(actionable_item)
			
			elif actionable_item.is_in_group("item_storage"):
				#? renaming to the item to storage for clarity
				var storage = actionable_item
				
				if storage.has_item() && current_item != null:
					var item = storage.get_item()
					storage.store_item(current_item)
					change_equipped_item(item)
					
				elif storage.has_item(): 
					var item = storage.get_item()
					change_equipped_item(item)
				
				elif current_item != null:
					storage.store_item(current_item)
					current_item = null


func _physics_process(delta):
	var direction = Vector3.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var wants_to_jump = Input.is_action_just_pressed("jump") && is_on_floor()
	
	#check to see if direction was modified on this frame, then normalize it.
	if direction != Vector3.ZERO:
		direction = direction.rotated(Vector3.UP, %CameraPivot.rotation.y).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	
	if wants_to_jump && (action_state == ACTIONS.IDLE || action_state == ACTIONS.WALKING):
		velocity.y += jump_impulse
		action_state = ACTIONS.JUMPING
	
	if velocity.length() > 1.25:
		var look_direction = Vector2(velocity.z, velocity.x)
		%Rat.rotation.y = lerp_angle(%Rat.rotation.y, look_direction.angle(), delta * rotation_speed)
	
	if (abs(velocity.x) > 1.0 || abs(velocity.z) > 1.0) && is_on_floor():
		%Rat.play_walk()
		action_state = ACTIONS.WALKING
	else: 
		%Rat.stop_walk()
		action_state = ACTIONS.IDLE
	move_and_slide()

func _process(_delta):
	%CameraPivot.position = position
	

#func attack():
	#%Rat.play_attack()

func change_equipped_item(new_item):
	current_item = new_item
	%Rat.change_item(new_item)

func remove_item():
	%Rat.remove_item()


func _on_action_detector_body_entered(body):
	if body.is_in_group("equippable_items") && body != current_item:
		#TODO: Maybe we can find a way to show a picture of the button depending on their controller type (xbox, swtich, etc.)  
		%Prompt.text = "Take"
		actionable_item = body
	elif body.is_in_group("item_storage"):
		actionable_item = body
		var storage = actionable_item
		if storage.has_item() && current_item != null:
			%Prompt.text = "Swap"
		elif current_item != null:
			%Prompt.text = "Place"
		elif storage.has_item():
			%Prompt.text = "Take"
			


func _on_action_detector_body_exited(body):
	if body.is_in_group("promptable_items"):
		%Prompt.text = ""
		actionable_item = null
