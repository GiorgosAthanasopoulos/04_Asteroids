extends Node2D

@onready var tilemap1: TileMapLayer = $CanvasLayer/TileMapLayer
@onready var tilemap2: TileMapLayer = $CanvasLayer/TileMapLayer2


var scroll_speed: float = 50 # pixels per second


func _ready() -> void:
	# Make sure TileMap2 starts right next to TileMap1
	tilemap2.position.x = tilemap1.position.x + tilemap1.get_used_rect().size.x * tilemap1.tile_set.tile_size.x


func _process(delta: float) -> void:
	# if State.paused: # dont render animated background when game is paused
	# 	return
	var dx: float = scroll_speed * delta

	tilemap1.position.x -= dx
	tilemap2.position.x -= dx

	# Width of one tilemap in pixels
	var map_width: float = tilemap1.get_used_rect().size.x * tilemap1.tile_set.tile_size.x

	# Loop each tilemap when it goes completely offscreen
	if tilemap1.position.x + map_width < 0:
		tilemap1.position.x = tilemap2.position.x + map_width

	if tilemap2.position.x + map_width < 0:
		tilemap2.position.x = tilemap1.position.x + map_width
