extends CharacterBody2D


@export var max_speed: float = 400
@export var min_speed: float = max_speed / 10
@export var acceleration_speed: float = max_speed * 40
@export var deceleration_speed: float = max_speed * 20
@export var bullet: PackedScene = preload('res://projectiles/bullet/bullet.tscn')
@export var shoot_delay: float = .33


var _angle: float
var _speed: Vector2
var _shoot_timer: float = 0
var _bullet_counter: int = 0


func _ready() -> void:
	Events.player_died.connect(_on_player_died)


func _physics_process(delta: float) -> void:
	if State.paused:
		return

	look_at_mouse()
	handle_input()
	var collision: KinematicCollision2D = move_and_collide(_speed * delta)
	handle_collision(collision)
	handle_shooting(delta)
	handle_screen_wrap()


func look_at_mouse() -> void:
	# TODO: when standing still player rotation goes crazy around cursor
	_angle = Math.get_angle_to_mouse_clockwise(global_position, get_global_mouse_position())
	rotation_degrees = _angle


func handle_input() -> void:
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	_speed = direction * min_speed # TODO: decelerate to min speed
	if Input.is_action_pressed('thrust'):
		_speed = direction * max_speed # TODO: accelerate to max speed


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return

	Events.player_hit.emit()
	# TODO: handle player collisions (play sound - hit/die)


func handle_shooting(delta: float) -> void:
	_shoot_timer -= delta
	if Input.is_action_just_pressed('shoot') and _shoot_timer <= 0:
		# TODO: play sound
		_shoot_timer = shoot_delay
		var instance: RigidBody2D = bullet.instantiate()
		instance.name = "Bullet" + str(_bullet_counter)
		_bullet_counter += 1
		instance.global_position = global_position
		instance.global_rotation_degrees = _angle - 90
		get_tree().current_scene.add_child(instance)


func handle_screen_wrap() -> void:
	pass # TODO: implement player screen wrap


func _on_player_died() -> void:
	# TODO: play audio?
	queue_free()
