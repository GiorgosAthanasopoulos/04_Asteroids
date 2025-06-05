extends Node2D


@onready var escape_menu: CanvasLayer = $EscapeMenu/CanvasLayer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&'ui_cancel'):
		State.paused = not State.paused
		escape_menu.visible = State.paused
