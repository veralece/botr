extends Node3D
func play_walk():
	%AnimationPlayer.play("walk")

func stop_walk():
	%AnimationPlayer.play("RESET")

func change_item(new_item): 
	var attached_item = %ItemPivot.get_children()
	if attached_item.size() > 0:
		attached_item[0].reparent(get_tree().get_root())
	new_item.reparent(%ItemPivot)
	new_item.global_position = %ItemPivot.global_position
	print(new_item.rotation.y)
	new_item.rotation.y = wrapf(%ItemPivot.rotation.y, -PI, PI) - 90
	print(new_item.rotation.y)
	

func drop_item(): 
	var attached_item: Array[Node] = %ItemPivot.get_children()
	if attached_item.size() > 0:
		var pos = attached_item[0].global_position
		attached_item[0].global_position = Vector3(pos.x, 0.0125, pos.z)
		attached_item[0].reparent(get_tree().get_root())
