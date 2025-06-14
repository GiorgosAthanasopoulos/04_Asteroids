extends RigidBody2D


@export var speed: float = 300
@export var kill_score: int = 10
@export var my_scale: Vector2 = Vector2(1, 1)


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var lifes: int = 3


func _ready() -> void:
	animated_sprite.scale = my_scale
	collision_shape.scale = my_scale


func _physics_process(delta: float) -> void:
	if State.paused:
		return

	var movement_vector: Vector2 = Vector2.ZERO
	movement_vector.x = cos(global_rotation) * speed
	movement_vector.y = sin(global_rotation) * speed
	var collision: KinematicCollision2D = move_and_collide(movement_vector * delta)
	handle_collision(collision)
	handle_screen_wrap()


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	if collider.collision_layer == 1:
		Events.player_hit.emit()
		die()
	if collider.collision_layer == 2:
		animated_sprite.frame += 1 if animated_sprite.frame + 1 < 3 else -2
		lifes -= 1
		if lifes <= 0:
			die()
		else:
			Audio.asteroid_hit_sfx()


func die() -> void:
	Audio.asteroid_died_sfx()
	Particles.spawn_explosives(global_position, global_rotation)
	Events.asteroid_died.emit(kill_score)
	queue_free()


func handle_screen_wrap() -> void:
	# const WRAP_PADDING = 10.0
	# if global_position.x < -WRAP_PADDING:
	# 	global_position.x = screen_size.x + WRAP_PADDING
	# elif global_position.x > screen_size.x + WRAP_PADDING:
	# 	global_position.x = -WRAP_PADDING
	# if global_position.y < -WRAP_PADDING:
	# 	global_position.y = screen_size.y + WRAP_PADDING
	# elif global_position.y > screen_size.y + WRAP_PADDING:
	# 	global_position.y = -WRAP_PADDING
	var screen_size: Vector2 = get_viewport_rect().size
	
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
