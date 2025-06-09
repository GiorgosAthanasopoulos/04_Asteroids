extends Node2D


func _on_play_button_pressed() -> void:
    var err: Error = get_tree().change_scene_to_file('res://levels/game/game.tscn')
    if err != OK:
        print("_on_play_button_pressed failed to change scene to game: ", error_string(err))


func _on_settings_button_pressed() -> void:
    State.in_settings_from_main = true
    var err: Error = get_tree().change_scene_to_file('res://ui/settings_menu/settings_menu.tscn')
    if err != OK:
        print("_on_settings_button_pressed failed to change scene to settings menu: ", error_string(err))


func _on_quit_button_pressed() -> void:
    get_tree().quit()
