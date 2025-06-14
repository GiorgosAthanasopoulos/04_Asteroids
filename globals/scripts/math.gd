extends Node


@export var min_mouse_distance: float = 10


func get_angle_to_mouse_clockwise(player_pos: Vector2, mouse_pos: Vector2) -> float:
	var up_vector: Vector2 = Vector2(0, -1)
	var to_mouse: Vector2 = (mouse_pos - player_pos)

	if to_mouse.length() < min_mouse_distance:
		return -1

	to_mouse = to_mouse.normalized()

	var cross: float = up_vector.x * to_mouse.y - up_vector.y * to_mouse.x
	var dot: float = up_vector.dot(to_mouse)

	var angle_rad: float = atan2(cross, dot)
	var angle_deg: float = rad_to_deg(angle_rad)

	return fposmod(angle_deg, 360.0)
