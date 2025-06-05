extends CharacterBody2D


var _angle: float


func _physics_process(_delta: float) -> void:
	if State.paused:
		return

	_angle = Math.get_angle_to_mouse_clockwise(global_position, get_global_mouse_position())
	rotation_degrees = _angle
