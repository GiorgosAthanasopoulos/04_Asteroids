extends Node2D


func _on_quit_to_desktop_button_pressed() -> void:
    get_tree().quit()


func _on_main_menu_button_pressed() -> void:
    State.paused = false
    var err: Error = get_tree().change_scene_to_file('res://ui/main_menu/main_menu.tscn')
    if err != OK:
        print('Failed to go to main menu scene from win/lost menu: ', error_string(err))


func _on_restart_button_pressed() -> void:
    State.paused = false
    var err: Error = get_tree().reload_current_scene()
    if err != OK:
        print('Failed to reload game scene from win/lost menu: ', error_string(err))
