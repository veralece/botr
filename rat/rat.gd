extends Node3D
func play_walk():
	%AnimationPlayer.play("walk")

func stop_walk():
	%AnimationPlayer.play("RESET")

func change_item(new_item): 
	print("change_item called")
	var attached_item = %ItemPivot.get_children()
	if attached_item.size() > 0:
		for child_item in attached_item:
			child_item.reparent(get_tree().get_root())
	new_item.reparent(%ItemPivot)
	new_item.global_position = %ItemPivot.global_position

func remove_item(): 
	var attached_item = %ItemPivot.get_children()
	if attached_item.size() > 0:
		for child_item in attached_item:
			child_item.reparent(get_tree().get_root())
