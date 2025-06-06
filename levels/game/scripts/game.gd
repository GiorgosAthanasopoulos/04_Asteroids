extends Node2D


# TODO: play bgm music
# TODO: when do we win? (maybe reaching a certain score - add score)


@onready var lifes_label: Label = $UI/CanvasLayer/LifesLabel


var _player_lifes: int = 3


@onready var escape_menu: CanvasLayer = $EscapeMenu/CanvasLayer


func _ready() -> void:
	Events.player_hit.connect(_on_player_hit)


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
