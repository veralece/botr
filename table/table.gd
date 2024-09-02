extends StaticBody3D

func store_item(new_item): 
	var attached_item = %ItemPivot.get_children()
	if attached_item.size() == 0:
		new_item.reparent(%ItemPivot)
		new_item.global_position = %ItemPivot.global_position

func get_item(): 
	var attached_item = %ItemPivot.get_children()
	if attached_item.size() > 0:
		return attached_item[0]


func has_item():
	return %ItemPivot.get_children().size() > 0
