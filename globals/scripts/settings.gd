extends Node


# Audio
const AUDIO_SECTION: String = 'Audio'

var master_volume: float = 1.0
const MASTER_VOLUME: String = 'master_volume'

var music_volume: float = 1.0
const MUSIC_VOLUME: String = 'music_volume'

var sound_volume: float = 1.0
const SOUND_VOLUME: String = 'sound_volume'

# Graphics
const GRAPHICS_SECTION: String = 'Graphics'

var fullscreen: bool = false
const FULLSCREEN: String = 'is_fullscreen'


var _settings_file: ConfigFile = ConfigFile.new()
const SETTINGS_FILENAME: String = 'user://settings.cfg'


func _ready() -> void:
	load_settings()
	apply_loaded_settings()


func _exit_tree() -> void:
	save_settings()


func save_settings() -> void:
	_settings_file.set_value(AUDIO_SECTION, MASTER_VOLUME, master_volume)
	_settings_file.set_value(AUDIO_SECTION, MUSIC_VOLUME, music_volume)
	_settings_file.set_value(AUDIO_SECTION, SOUND_VOLUME, sound_volume)

	_settings_file.set_value(GRAPHICS_SECTION, FULLSCREEN, fullscreen)

	var error: Error = _settings_file.save(SETTINGS_FILENAME)
	if error != OK:
		print('Failed to save settings: ', error_string(error))


func load_settings() -> void:
	var error: Error = _settings_file.load(SETTINGS_FILENAME)
	if error != OK:
		print('Failed to load settings: ', error_string(error))
		return

	master_volume = _settings_file.get_value(AUDIO_SECTION, MASTER_VOLUME)
	music_volume = _settings_file.get_value(AUDIO_SECTION, MUSIC_VOLUME)
	sound_volume = _settings_file.get_value(AUDIO_SECTION, SOUND_VOLUME)

	fullscreen = _settings_file.get_value(GRAPHICS_SECTION, FULLSCREEN)


func apply_loaded_settings() -> void:
	Audio.set_master_volume(master_volume)
	Audio.set_music_volume(music_volume)
	Audio.set_sound_volume(sound_volume)

	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
