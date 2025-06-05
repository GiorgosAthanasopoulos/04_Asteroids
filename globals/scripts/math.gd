extends Node


func get_angle_to_mouse_clockwise(player_pos: Vector2, mouse_pos: Vector2) -> float:
	var up_vector = Vector2(0, -1)
	var to_mouse = (mouse_pos - player_pos).normalized()

	var cross = up_vector.x * to_mouse.y - up_vector.y * to_mouse.x
	var dot = up_vector.dot(to_mouse)

	var angle_rad = atan2(cross, dot)
	var angle_deg = rad_to_deg(angle_rad)

	return fposmod(angle_deg, 360.0)
