extends Node2D


@onready var escape_menu: CanvasLayer = $CanvasLayer


func _on_resume_button_pressed() -> void:
	State.paused = false
	escape_menu.visible = false


func _on_settings_button_pressed() -> void:
	State.paused = false
	get_tree().change_scene_to_file('res://ui/settings_menu/settings_menu.tscn')


func _on_quit_to_menu_button_pressed() -> void:
	State.paused = false
	get_tree().change_scene_to_file('res://ui/main_menu/main_menu.tscn')


func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()
