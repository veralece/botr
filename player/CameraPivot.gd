extends SpringArm3D

@export var mouse_sensitivity = 0.01

func _ready():
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clampf(rotation.x, -1.0, -0.1)
		
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation.y = wrapf(rotation.y, -PI, PI)

		%Prompt.rotation.y = rotation.y + 90
