extends RigidBody2D


@export var speed: float = 200
@export var kill_score: int = 30
@export var my_scale: Vector2 = Vector2(1, 1)
@export var shooting_delay: float = 2 # seconds
@export var bullet: PackedScene = preload('res://projectiles/bullet/bullet.tscn')


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var _shooting_timer: float = 0
var _bullet_counter: int = 0


func _ready() -> void:
	sprite.scale = my_scale
	collision_shape.scale = my_scale
	print('saucer')


func _physics_process(delta: float) -> void:
	if State.paused:
		return

	var movement_vector: Vector2 = Vector2.ZERO
	movement_vector.x = cos(global_rotation) * speed
	movement_vector.y = sin(global_rotation) * speed
	var collision: KinematicCollision2D = move_and_collide(movement_vector * delta)
	handle_collision(collision)
	handle_screen_wrap()
	handle_shooting(delta)


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	if collider.collision_layer == 1:
		print('saucer hit by player')
		Events.player_hit.emit()

	print('saucer died')
	die()


func die() -> void:
	Audio.asteroid_died_sfx()
	Particles.spawn_explosives(global_position, global_rotation)
	Events.saucer_died.emit(kill_score)
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


func handle_shooting(delta: float) -> void:
	_shooting_timer -= delta

	if _shooting_timer <= 0:
		_shooting_timer = shooting_delay
		shoot()


func shoot() -> void:
	var instance: RigidBody2D = bullet.instantiate()
	instance.name = "Bullet" + str(_bullet_counter)
	_bullet_counter += 1
	instance.global_position = global_position
	instance.global_rotation_degrees = global_rotation_degrees - 90
	get_tree().current_scene.add_child(instance)
	Audio.player_shoot_sfx()
