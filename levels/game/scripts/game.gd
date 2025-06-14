extends Node2D


@export var asteroid: PackedScene = preload('res://characters/asteroid/asteroid.tscn')
@export var asteroid_spawn_delay: Vector2 = Vector2(2, 4) # min, max
@export var max_score: int = 200
@export var max_asteroids_in_screen: int = 15

@export var saucer: PackedScene = preload('res://characters/saucer/saucer.tscn')
@export var saucer_spawn_delay: Vector2 = Vector2(15, 20) # min, max

@export var infinite_reload_powerup: PackedScene = preload('res://powerups/infinite_reload/infinite_reload.tscn')
@export var shield_powerup: PackedScene = preload('res://powerups/shield/shield_powerup.tscn')
@export var powerup_spawn_delay: float = 15 # seconds
@export var powerups: Array[PackedScene] = [infinite_reload_powerup, shield_powerup]
@export var max_powerups_on_screen: int = 3


@onready var lifes_label: Label = $UI/CanvasLayer/LifesLabel
@onready var score_label: Label = $UI/CanvasLayer/ScoreLabel
@onready var escape_menu: CanvasLayer = $EscapeMenu/CanvasLayer
@onready var win_lost_menu: CanvasLayer = $WinLoseMenu/CanvasLayer
@onready var win_lose_label: Label = $WinLoseMenu/CanvasLayer/VBoxContainer/WinLostLabel


var _player_lifes: int = 3
var _score: int = 0
var _asteroid_spawn_timer: float = 0
var _saucer_spawn_timer: float = 0
var _asteroid_counter: int = 0
var _powerup_timer: float = powerup_spawn_delay
var _saucer_active: bool = false
var _saucer_counter: int = 0


func _ready() -> void:
    var err: Error = Events.player_hit.connect(_on_player_hit) as Error
    if err != OK:
        print("Failed to connect player_hit in game.gd: ", error_string(err))

    err = Events.asteroid_died.connect(_on_asteroid_died) as Error
    if err != OK:
        print("Failed to connect asteroid_hit in game.gd: ", error_string(err))

    err = Events.saucer_died.connect(_on_saucer_died) as Error
    if err != OK:
        print("Failed to connect saucer_died in game.gd: ", error_string(err))

    Audio.play_bgm()

    _saucer_spawn_timer = randf_range(saucer_spawn_delay.x, saucer_spawn_delay.y)


func _process(delta: float) -> void:
    if Input.is_action_just_pressed('ui_cancel'):
        State.paused = not State.paused
        escape_menu.visible = State.paused

    if State.paused:
        return

    handle_asteroid_spawning(delta)
    handle_powerup_spawning(delta)
    handle_saucer_spawning(delta)


func _on_player_hit() -> void:
    _player_lifes -= 1
    lifes_label.text = 'Lifes: ' + str(_player_lifes)
    
    if _player_lifes <= 0:
        Events.player_died.emit()
        Audio.play_lose_sfx()
        State.paused = not State.paused
        win_lost_menu.visible = State.paused
        win_lose_label.text = 'You lost!'


func _on_asteroid_died(score: int) -> void:
    _score += score
    score_label.text = 'Score: ' + str(_score)

    if score >= max_score:
        Audio.play_win_sfx()
        State.paused = not State.paused
        win_lost_menu.visible = State.paused


func get_random_edge_spawn_position() -> Vector2:
    var edge: int = randi_range(1, 4)
    var spawn_pos: Vector2 = Vector2.ZERO
    var viewport_size: Vector2 = get_viewport_rect().size
    var horizontal_random: float = randf_range(viewport_size.x, 0)
    var vertical_random: float = randf_range(0, viewport_size.y)

    if edge == 1: # top
        spawn_pos = Vector2(horizontal_random, 0)
    elif edge == 2: # left
        spawn_pos = Vector2(0, vertical_random)
    elif edge == 3: # bottom
        spawn_pos = Vector2(horizontal_random, viewport_size.y)
    elif edge == 4: # right
        spawn_pos = Vector2(viewport_size.x, vertical_random)

    return spawn_pos


func spawn_asteroid() -> void:
    var spawn_position: Vector2 = get_random_edge_spawn_position()
    var instance: Node2D = asteroid.instantiate()
    instance.global_position = spawn_position
    instance.name = 'Asteroid' + str(_asteroid_counter)
    _asteroid_counter += 1
    var player: Node2D = get_node('Entities/Player')
    if player == null:
        print('player is null, spawn_asteroid, game')
        return
    instance.global_rotation = player.global_rotation
    get_tree().current_scene.add_child(instance)


func handle_asteroid_spawning(delta: float) -> void:
    _asteroid_spawn_timer -= delta

    if _asteroid_spawn_timer <= 0 and count_asteroids_on_screen() < max_asteroids_in_screen:
        _asteroid_spawn_timer = randf_range(asteroid_spawn_delay.x, asteroid_spawn_delay.y)
        spawn_asteroid()


func handle_powerup_spawning(delta: float) -> void:
    _powerup_timer -= delta

    if _powerup_timer <= 0 and count_powerups_on_screen() < max_powerups_on_screen:
        _powerup_timer = powerup_spawn_delay
        spawn_powerup()


func spawn_powerup() -> void:
    var powerup_number: int = randi_range(0, len(powerups) - 1)
    var powerup: PackedScene = powerups[powerup_number]
    var instance: Node2D = powerup.instantiate()

    var viewport_size: Vector2 = get_viewport_rect().size
    var spawn_position: Vector2 = Vector2.ZERO
    spawn_position.x = randi_range(0, int(viewport_size.x))
    spawn_position.y = randi_range(0, int(viewport_size.y))
    instance.global_position = spawn_position

    get_tree().current_scene.add_child(instance)


func handle_saucer_spawning(delta: float) -> void:
    if _saucer_active:
        return

    _saucer_spawn_timer -= delta

    if _saucer_spawn_timer <= 0:
        _saucer_spawn_timer = randf_range(saucer_spawn_delay.x, saucer_spawn_delay.y)
        _saucer_active = true
        spawn_saucer()


func spawn_saucer() -> void:
    var instance: Node2D = saucer.instantiate()

    var spawn_position: Vector2 = get_random_edge_spawn_position()
    instance.global_position = spawn_position

    instance.name = 'Saucer ' + str(_saucer_counter)
    _saucer_counter += 1

    var player: Node2D = get_node('Entities/Player')
    if player == null:
        print('player is null, spawn_saucer, game')
        return
    instance.global_rotation = player.global_rotation

    get_tree().current_scene.add_child(instance)


func _on_saucer_died(score: int) -> void:
    _saucer_active = false
    _on_asteroid_died(score)


func count_asteroids_on_screen(root: Node = get_tree().get_current_scene()) -> int:
    var count: int = 0

    if root.scene_file_path == asteroid.resource_path:
        count += 1

    for child: Node in root.get_children():
        count += count_asteroids_on_screen(child)

    return count


func count_powerups_on_screen(root: Node = get_tree().get_current_scene()) -> int:
    var count: int = 0

    if root.scene_file_path == infinite_reload_powerup.resource_path or \
       root.scene_file_path == shield_powerup.resource_path:
        count += 1

    for child: Node in root.get_children():
        count += count_powerups_on_screen(child)

    return count
