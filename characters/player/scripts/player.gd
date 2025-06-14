extends CharacterBody2D


@export var max_speed: float = 300
@export var min_speed: float = 50
@export var acceleration_speed: float = 200
@export var deceleration_speed: float = 150
@export var rotation_speed: float = 10 # degrees per sec
@export var min_move_distance: float = 10 # pixels
@export var wrap_delay: float = 10 # seconds

@export var bullet: PackedScene = preload('res://projectiles/bullet/bullet.tscn')
@export var shoot_delay: float = .33


var _angle: float
var _speed: Vector2
var _shoot_timer: float = 0
var _bullet_counter: int = 0
var _wrap_timer: float = 0
var _powerup: int = -1 # -1 no powerup, 0 infinite reload
var _powerup_timer: float = 0


func _ready() -> void:
	var err: Error = Events.player_died.connect(_on_player_died) as Error
	if err != OK:
		print("Failed to connect player_died signal in player.gd: ", error_string(err))

	err = Events.infinite_reload_powerup.connect(_on_infinite_reload_powerup) as Error
	if err != OK:
		print("Failed to connect infinite_reload_powerup signal in player.gd: ", error_string(err))


func _physics_process(delta: float) -> void:
	look_at_mouse(delta)

	if State.paused:
		return

	handle_input(delta)
	var collision: KinematicCollision2D = move_and_collide(_speed * delta)
	handle_collision(collision)
	handle_shooting(delta)
	handle_screen_wrap()
	handle_hyperspace_wrap(delta)
	handle_powerups(delta)


func look_at_mouse(delta: float) -> void:
	var new_angle: float = Math.get_angle_to_mouse_clockwise(global_position, get_global_mouse_position())
	_angle = new_angle
	if new_angle >= 0:
		rotation = lerp_angle(rotation, deg_to_rad(_angle), rotation_speed * delta)


func handle_input(delta: float) -> void:
	var direction: Vector2 = get_global_mouse_position() - global_position

	if direction.length() < min_move_distance:
		_speed = Vector2.ZERO
		return

	direction = direction.normalized()

	if Input.is_action_pressed('thrust'):
		_speed = _speed.move_toward(direction * max_speed, acceleration_speed * delta)
	else:
		_speed = _speed.move_toward(direction * min_speed, deceleration_speed * delta)


func handle_collision(collision: KinematicCollision2D) -> void:
	if collision == null:
		return

	var collider: PhysicsBody2D = collision.get_collider()
	if not is_instance_valid(collider):
		return


func handle_shooting(delta: float) -> void:
	_shoot_timer -= delta

	if Input.is_action_pressed('shoot') and (_shoot_timer <= 0 or _powerup == 0):
		_shoot_timer = shoot_delay
		shoot()


func shoot() -> void:
		var instance: RigidBody2D = bullet.instantiate()
		instance.name = "Bullet" + str(_bullet_counter)
		_bullet_counter += 1
		instance.global_position = global_position
		instance.global_rotation_degrees = _angle - 90
		get_tree().current_scene.add_child(instance)
		Audio.player_shoot_sfx()


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


func _on_player_died() -> void:
	Audio.player_died_sfx()
	queue_free()


func handle_hyperspace_wrap(delta: float) -> void:
	_wrap_timer -= delta

	if Input.is_action_just_pressed('wrap') and _wrap_timer <= 0:
		_wrap_timer = wrap_delay
		Audio.player_hyperspace_wrap_sfx()
		hyperspace_wrap()


func hyperspace_wrap() -> void:
	Particles.spawn_explosives(global_position, global_rotation)
	var viewport_size: Vector2 = get_viewport_rect().size
	var random_x: int = randi_range(0, int(viewport_size.x))
	var random_y: int = randi_range(0, int(viewport_size.y))
	global_position = Vector2(random_x, random_y)


func _on_infinite_reload_powerup(active_time: float) -> void:
	Audio.player_powerup_sfx()
	_powerup = 0
	_powerup_timer = active_time


func handle_powerups(delta: float) -> void:
	_powerup_timer -= delta

	if _powerup_timer <= 0:
		_powerup = -1
