extends Node


@warning_ignore('unused_signal')
signal player_hit
@warning_ignore('unused_signal')
signal player_died

@warning_ignore('unused_signal')
signal asteroid_died(score: int)

@warning_ignore('unused_signal')
signal infinite_reload_powerup(timer: float)

@warning_ignore('unused_signal')
signal saucer_died(score: int)
