extends RigidBody2D


@export var speed: float = 500


func _physics_process(_delta: float) -> void:
	# TODO: handle collisions
	var movement_vector: Vector2 = Vector2.ZERO
	movement_vector.x = cos(global_rotation) * speed
	movement_vector.y = sin(global_rotation) * speed
	var collision: KinematicCollision2D = move_and_collide(movement_vector)
	handle_collision(collision)


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	# TODO: if hit by player, die, play sound and remove player life
	# TODO: if hit by bullet, remove life (change texture), if lifes == 0, die, play sound
	# TODO: wrap if outside of screen
