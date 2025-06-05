extends Node


const MASTER_BUS: String = &'Master'
const MUSIC_BUS: String = &'Music'
const SFX_BUS: String = &'SFX'


func get_master_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(MASTER_BUS))


func get_music_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS))


func get_sound_volume() -> float:
    return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(SFX_BUS))


func set_master_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MASTER_BUS), volume_db)


func set_music_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS), volume_db)


func set_sound_volume(volume_db: float) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), volume_db)
