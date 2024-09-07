extends Area3D
func item_stored_or_equipped(item) -> bool:
	return (item.equipped || item.stored)

## processes alll hits done to player
func process_hit(hitbox):
	if hitbox.get_parent().is_equipped(): ##hitboxes are usually separate child 3DAreas under the model's 3D Node
		print("Hit from %s" % hitbox)

## Adds actions to the queue 
func process_action(action):
	var player = get_tree().get_nodes_in_group("main")[0].player
	if player.actionable_item == null:
		player.action_queue.push_back(action)
	
	if player.actionable_item != null && player.actionable_item != action:
		player.action_queue.push_back(action)
	elif action.is_in_group("equippable_items") && action.is_equippable():
		#TODO: Maybe we can find a way to show a picture of the button depending on their controller type (xbox, swtich, etc.)  
		player.actionable_item = action
		if player.current_item != null:
			%Prompt.text = "Swap for %s" % action.name
		else:
			%Prompt.text = "Take %s" % action.name
	elif action.is_in_group("item_storage"):
		player.actionable_item = action 
		var storage = player.actionable_item.get_parent() #the actual storage script is stored in the parent of the action, maybe this can be refactored for clarity
		if storage.has_item() && player.current_item != null:
			%Prompt.text = "Swap for %s" % storage.get_item().name
		elif player.current_item != null:
			%Prompt.text = "Place %s" % player.current_item.name
		elif storage.has_item():
			%Prompt.text = "Take %s" % storage.get_item().name
	elif action == null:
		player.actionable_item = null

func process_action_exit(exiting_action):
	var player = get_tree().get_nodes_in_group("main")[0].player
	var size = player.action_queue.size()
	var exiting_action_currently_queued = player.action_queue.any(func(q_action): return q_action == exiting_action)
	if exiting_action_currently_queued:
		player.action_queue = player.action_queue.filter(func(q_action): return q_action != exiting_action)
	
	if player.actionable_item == exiting_action:
		player.actionable_item = null
		%Prompt.text = ""
	
	if player.action_queue.size() > 0 && player.actionable_item == null:
		process_action(player.action_queue.pop_front())

func _on_area_entered(body):
	#TODO if player.enemy_detected, then prioritize combat
	if body.is_in_group("hitboxes"): #hitboxes are usually on a separate child area under the node that stores state
		process_hit(body)
	elif body.is_in_group("actionable"): #TODO && player.enemy_detected == false
		process_action(body)
	

func _on_area_exited(body):
	if body.is_in_group("actionable"): 
		process_action_exit(body)
