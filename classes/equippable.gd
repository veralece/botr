extends Item
class_name Equippable
@export var state: equip_state = equip_state.EQUIPPABLE 
enum equip_state {EQUIPPABLE, STORED, EQUIPPED}
func equip():
	state = equip_state.EQUIPPED

func store():
	state = equip_state.STORED

func drop():
	state = equip_state.EQUIPPABLE
	global_position = Vector3(global_position.x, .125, global_position.z)

func is_equippable():
	return state == equip_state.EQUIPPABLE

func is_equipped():
	return state == equip_state.EQUIPPED

func is_stored():
	return state == equip_state.STORED
