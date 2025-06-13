extends Node


const MASTER_BUS: String = 'Master'
const MUSIC_BUS: String = 'Music'
const SFX_BUS: String = 'SFX'


@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var sound_player: AudioStreamPlayer = AudioStreamPlayer.new()


func _ready() -> void:
    music_player.bus = MUSIC_BUS
    sound_player.bus = SFX_BUS


# Master
func get_master_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(MASTER_BUS))


func set_master_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MASTER_BUS), volume_db)


# Music
func get_music_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS))


func set_music_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS), volume_db)


func play_music(music: AudioStream) -> void:
    music_player.stream = music
    music_player.play()


# Sound
func get_sound_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(SFX_BUS))


func set_sound_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), volume_db)


func play_sound(sound: AudioStream, only: bool = false) -> void:
    if only:
        sound_player.stop()
    sound_player.stream = sound
    sound_player.play()


# TODO: Player 
func player_hit_sfx() -> void:
    pass


func player_shoot_sfx() -> void:
    pass


func player_died_sfx() -> void:
    pass


# TODO: Asteroid
func asteroid_hit_sfx() -> void:
    pass


func asteroid_died_sfx() -> void:
    pass


# TOOD: Game
func play_win_sfx() -> void:
    pass


func play_lose_sfx() -> void:
    pass


func play_bgm() -> void:
    pass
