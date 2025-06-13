extends RigidBody2D


@export var speed: float = 500
@export var kill_score: int = 10


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var lifes: int = 3


func _physics_process(_delta: float) -> void:
	var movement_vector: Vector2 = Vector2.ZERO
	movement_vector.x = cos(global_rotation) * speed
	movement_vector.y = sin(global_rotation) * speed
	var collision: KinematicCollision2D = move_and_collide(movement_vector)
	handle_collision(collision)
	handle_screen_wrap()


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	if collider.name.contains('Player'):
		Audio.asteroid_died_sfx()
		queue_free()
	elif collider.name.contains('Bullet'):
		animated_sprite.frame += 1
		if animated_sprite.frame > 2:
			animated_sprite.frame = 0

		lifes -= 1
		if lifes <= 0:
			Audio.asteroid_died_sfx()
			queue_free()
			Events.asteroid_died.emit(kill_score)


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
