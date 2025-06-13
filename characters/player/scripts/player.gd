extends CharacterBody2D


@export var max_speed: float = 300
@export var min_speed: float = 50
@export var acceleration_speed: float = 200
@export var deceleration_speed: float = 150
@export var rotation_speed: float = 10 # degrees per sec

@export var bullet: PackedScene = preload('res://projectiles/bullet/bullet.tscn')
@export var shoot_delay: float = .33


var _angle: float
var _speed: Vector2
var _shoot_timer: float = 0
var _bullet_counter: int = 0


func _ready() -> void:
	var err: Error = Events.player_died.connect(_on_player_died) as Error
	if err != OK:
		print("Failed to connect player_died signal in player.gd: ", err)


func _physics_process(delta: float) -> void:
	if State.paused:
		return

	look_at_mouse(delta)
	handle_input(delta)
	var collision: KinematicCollision2D = move_and_collide(_speed * delta)
	handle_collision(collision)
	handle_shooting(delta)
	handle_screen_wrap()


func look_at_mouse(delta: float) -> void:
	var new_angle: float = Math.get_angle_to_mouse_clockwise(global_position, get_global_mouse_position())
	if new_angle >= 0:
		_angle = new_angle
		rotation = lerp_angle(rotation, deg_to_rad(_angle), rotation_speed * delta)


func handle_input(delta: float) -> void:
	var direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

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

	Events.player_hit.emit()
	Audio.player_hit_sfx()


func handle_shooting(delta: float) -> void:
	_shoot_timer -= delta
	if Input.is_action_just_pressed('shoot') and _shoot_timer <= 0:
		Audio.player_shoot_sfx()
		_shoot_timer = shoot_delay
		shoot()


func shoot() -> void:
		var instance: RigidBody2D = bullet.instantiate()
		instance.name = "Bullet" + str(_bullet_counter)
		_bullet_counter += 1
		instance.global_position = global_position
		instance.global_rotation_degrees = _angle - 90
		get_tree().current_scene.add_child(instance)


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
