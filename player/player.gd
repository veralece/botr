extends CharacterBody3D
#speed and fall force (gravity)
signal player_spawned

func _ready(): 
	emit_signal("player_spawned", self)

@export var current_item: Node3D = null
@export var speed = 14.0
@export var jump_impulse = 20.0
@export var gravity = 75.0
@export var bounce_impulse = 16.0
@export var rotation_speed = 5.0
@export var actionable_item: Node = null 
@export var action_queue: Array[Node] = []

enum ACTIONS {IDLE, WALKING, JUMPING, PROCESSING, ATTACKING}
var action_state = ACTIONS.IDLE
var frames_since_last_action = 0.0
#TODO process input with player.process(actionable_item)
func _input(event):
	#if event.is_action_pressed("attack"):
			#attack()
	if event.is_action_pressed("action"):
		if actionable_item != null: 
			#player.process()
			if actionable_item.is_in_group("equippable_items"):
				actionable_item.equip()
				var old_item = change_equipped_item(actionable_item)
				if old_item != null:
					old_item.drop()

			elif actionable_item.is_in_group("item_storage"):
				#? renaming to the item to storage for clarity
				var storage = actionable_item.get_parent() #the actual storage script is stored in the parent of the action, maybe this can be refactored for clarity

				if storage.has_item() && current_item != null:
					var item = storage.get_item()
					item.equip()
					var old_item = change_equipped_item(item)
					old_item.store()
					storage.store_item(old_item)
					%Prompt.text = "Swap for %s" % old_item.name

				elif storage.has_item(): 
					var item = storage.get_item()
					item.equip()
					change_equipped_item(item)
					%Prompt.text = "Place %s" % item.name

				elif current_item != null:
					current_item.store()
					storage.store_item(current_item)
					current_item = null
					%Prompt.text = "Take %s" % storage.get_item().name


#func attack():
	#%Rat.play_attack()

func change_equipped_item(new_item):
	var old_item = null
	if current_item != null:
		old_item = current_item
	current_item = new_item
	%Rat.change_item(new_item)
	return old_item

func remove_item():
	if current_item != null:
		var item = current_item
		%Rat.drop_item()
		item.drop()
		current_item = null
		return item

func double_action():
	frames_since_last_action = 0.0
	remove_item()
	print("double action!!!")

func _physics_process(delta):
	var direction = Vector3.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var wants_to_jump = Input.is_action_just_pressed("jump") && is_on_floor()
	var action_pressed = Input.is_action_just_pressed("action")

	if frames_since_last_action > 0.0:
		frames_since_last_action += delta
		if action_pressed:
			double_action()
		
		if frames_since_last_action > .25:
			frames_since_last_action = 0.0

	if action_pressed:
		frames_since_last_action += delta

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
