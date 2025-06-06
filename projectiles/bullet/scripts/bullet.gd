extends RigidBody2D


@export var speed: float = 500


func _physics_process(delta: float) -> void:
    var movement_vector: Vector2 = Vector2.ZERO
    movement_vector.x = speed * cos(deg_to_rad(global_rotation_degrees))
    movement_vector.y = speed * sin(deg_to_rad(global_rotation_degrees))
    var collision: KinematicCollision2D = move_and_collide(movement_vector * delta)
    handle_collision(collision)

    if not get_viewport().get_visible_rect().has_point(global_position):
        queue_free()


func handle_collision(collision: KinematicCollision2D) -> void:
    if collision == null:
        return

    var collider: PhysicsBody2D = collision.get_collider()
    if not is_instance_valid(collider):
        return

    queue_free()
