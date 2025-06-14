extends StaticBody2D


@export var active_time: float = 3 # seconds


func _ready() -> void:
    print('infinite reload')


func _process(_delta: float) -> void:
    var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
    handle_collisions(collision)


func handle_collisions(collision: KinematicCollision2D) -> void:
    if collision == null:
        return

    var collider: PhysicsBody2D = collision.get_collider()
    if not is_instance_valid(collider):
        return

    assert(collider.collision_layer == 1)
    Events.infinite_reload_powerup.emit(active_time)
    queue_free()
