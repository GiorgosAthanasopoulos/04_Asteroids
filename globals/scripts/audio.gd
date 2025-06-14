extends Node


const MASTER_BUS: String = 'Master'
const MUSIC_BUS: String = 'Music'
const SFX_BUS: String = 'SFX'


@export var player_shoot_sound: AudioStreamWAV = preload('res://assets/sounds/player/shoot/source/522095__magnuswaker__energy-riser.wav')
@export var player_hit_sound: AudioStreamWAV = preload('res://assets/sounds/player/hit/wav/725542__whatchar__dsgnimpt_sci-fimpact61_whatley_impacts.wav')

@export var game_lose_sound: AudioStreamMP3 = preload('res://assets/sounds/game/lose/source/792355__diasyl__sci-fi-soldier-death.mp3')
@export var game_win_sound: AudioStreamWAV = preload('res://assets/sounds/game/win/source/270545__littlerobotsoundfactory__jingle_win_01.wav')
@export var game_bgm: AudioStreamWAV = preload('res://assets/music/bgm/source/231254__foolboymedia__action-theme.wav')

@export var asteroid_died_sound: AudioStreamWAV = preload('res://assets/sounds/asteroid/died/source/331156__robinhood76__06167-magnetic-destroy-shot.wav')

@export var global_enable: bool = false


@onready var music_player: AudioStreamPlayer
@onready var sound_player: AudioStreamPlayer


func _ready() -> void:
    music_player = AudioStreamPlayer.new()
    sound_player = AudioStreamPlayer.new()

    music_player.bus = MUSIC_BUS
    sound_player.bus = SFX_BUS

    get_tree().current_scene.add_child(music_player)
    get_tree().current_scene.add_child(sound_player)


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
    if not global_enable:
        return

    music_player.stream = music
    music_player.play()


# Sound
func get_sound_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(SFX_BUS))


func set_sound_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), volume_db)


func play_sound(sound: AudioStream, only: bool = false) -> void:
    if not global_enable:
        return

    if only:
        sound_player.stop()
    sound_player.stream = sound
    sound_player.play()


# Player 
func player_hit_sfx() -> void:
    play_sound(player_hit_sound)


func player_shoot_sfx() -> void:
    play_sound(player_shoot_sound)


func player_died_sfx() -> void:
    # We already play lose sound
    pass


func player_hyperspace_wrap_sfx() -> void:
    pass


func player_powerup_sfx() -> void:
    pass


# Asteroid
func asteroid_hit_sfx() -> void:
    play_sound(player_hit_sound)


func asteroid_died_sfx() -> void:
    play_sound(asteroid_died_sound)


# Game
func play_win_sfx() -> void:
    play_sound(game_win_sound, true)


func play_lose_sfx() -> void:
    play_sound(game_lose_sound, true)


func play_bgm() -> void:
    play_music(game_bgm)
