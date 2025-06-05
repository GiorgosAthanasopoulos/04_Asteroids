extends Node2D


func _on_play_button_pressed() -> void:
    get_tree().change_scene_to_file(&'res://levels/game/game.tscn')


func _on_settings_button_pressed() -> void:
    State.in_settings_from_main = true
    get_tree().change_scene_to_file(&'res://levels/settings_menu/settings_menu.tscn')


func _on_quit_button_pressed() -> void:
    get_tree().quit()
