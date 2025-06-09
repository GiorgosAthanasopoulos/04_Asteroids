extends Node2D


# TODO: play bgm music
# TODO: when do we win? (maybe reaching a certain score - add score)
# TODO: at random? intervals spawn new asteroids from different screen edges


@onready var lifes_label: Label = $UI/CanvasLayer/LifesLabel


var _player_lifes: int = 3


@onready var escape_menu: CanvasLayer = $EscapeMenu/CanvasLayer


func _ready() -> void:
    var err: Error = Events.player_hit.connect(_on_player_hit) as Error
    if err != OK:
        print("Failed to connect player_hit in game.gd: ", error_string(err))

    err = Events.asteroid_hit.connect(_on_asteroid_hit) as Error
    if err != OK:
        print("Failed to connect asteroid_hit in game.gd: ", error_string(err))


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed('ui_cancel'):
        State.paused = not State.paused
        escape_menu.visible = State.paused


func _on_player_hit() -> void:
    _player_lifes -= 1
    lifes_label.text = 'Lifes: ' + str(_player_lifes)
    
    if _player_lifes <= 0:
        # TODO: maybe play lose sound?
        Events.player_died.emit()


func _on_asteroid_hit(_score: int) -> void:
    # TODO: implement game.gd::_on_asteroid_hit
    pass


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
