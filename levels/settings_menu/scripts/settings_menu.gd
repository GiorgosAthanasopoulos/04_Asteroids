extends Node2D


@onready var music_volume_slider: HSlider = $UI/CanvasLayer/VBoxContainer/MusicVolumeSlider
@onready var sound_volume_slider: HSlider = $UI/CanvasLayer/VBoxContainer/SoundVolumeSlider
@onready var fullscreen_toggle: CheckButton = $UI/CanvasLayer/VBoxContainer/FullscreenToggle


func _ready() -> void:
    music_volume_slider.set_value_no_signal(Audio.get_music_volume())
    sound_volume_slider.set_value_no_signal(Audio.get_sound_volume())
    fullscreen_toggle.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed(&'ui_cancel'):
        if State.in_settings_from_main:
            get_tree().change_scene_to_file(&'res://levels/main_menu/main_menu.tscn')
            State.in_settings_from_main = false
        else:
            get_tree().change_scene_to_file(&'res://levels/game/game.tscn')


func _on_sound_volume_slider_value_changed(value: float) -> void:
    Audio.set_sound_volume(value)


func _on_music_volume_slider_value_changed(value: float) -> void:
    Audio.set_music_volume(value)


func _on_master_volume_slider_value_changed(value: float) -> void:
    Audio.set_master_volume(value)


func _on_button_pressed() -> void:
    if State.in_settings_from_main:
        get_tree().change_scene_to_file(&'res://levels/main_menu/main_menu.tscn')
        State.in_settings_from_main = false
    else:
        get_tree().change_scene_to_file(&'res://levels/game/game.tscn')


func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)
