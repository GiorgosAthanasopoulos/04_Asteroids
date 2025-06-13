extends Node2D


@export var asteroid: PackedScene = preload('res://objects/asteroid/asteroid.tscn')
@export var asteroid_spawn_delay: Vector2 = Vector2(0.1, 1) # min, max
@export var max_score: int = 200


@onready var lifes_label: Label = $UI/CanvasLayer/LifesLabel
@onready var score_label: Label = $UI/CanvasLayer/ScoreLabel
@onready var escape_menu: CanvasLayer = $EscapeMenu/CanvasLayer
@onready var win_lost_menu: CanvasLayer = $WinLoseMenu/CanvasLayer


var _player_lifes: int = 3
var _score: int = 0
var _asteroid_spawn_timer: float = 0


func _ready() -> void:
    var err: Error = Events.player_hit.connect(_on_player_hit) as Error
    if err != OK:
        print("Failed to connect player_hit in game.gd: ", error_string(err))

    err = Events.asteroid_died.connect(_on_asteroid_died) as Error
    if err != OK:
        print("Failed to connect asteroid_hit in game.gd: ", error_string(err))

    Audio.play_bgm()


func _process(delta: float) -> void:
    if Input.is_action_just_pressed('ui_cancel'):
        State.paused = not State.paused
        escape_menu.visible = State.paused

    handle_asteroid_spawning(delta)


func _on_player_hit() -> void:
    _player_lifes -= 1
    lifes_label.text = 'Lifes: ' + str(_player_lifes)
    
    if _player_lifes <= 0:
        Audio.play_lose_sfx()
        Events.player_died.emit()


func _on_asteroid_died(score: int) -> void:
    _score += score
    score_label.text = 'Score: ' + str(_score)
    if score >= max_score:
        State.paused = true
        win_lost_menu.visible = true


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
    # TODO: change global_rotation to go toward center/player?


func handle_asteroid_spawning(delta: float) -> void:
    _asteroid_spawn_timer -= delta

    if _asteroid_spawn_timer <= 0:
        _asteroid_spawn_timer = randf_range(asteroid_spawn_delay.x, asteroid_spawn_delay.y)
        spawn_asteroid()
