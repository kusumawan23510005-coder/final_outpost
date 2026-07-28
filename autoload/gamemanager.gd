extends Node

signal score_changed(new_score: int)
signal wave_changed(current_wave: int, max_waves: int)

var score: int = 0
var current_wave: int = 0
var max_waves: int = 6

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func set_wave(wave: int, max_w: int) -> void:
	current_wave = wave
	max_waves = max_w
	wave_changed.emit(current_wave, max_waves)

func reset_game() -> void:
	score = 0
	current_wave = 0
	score_changed.emit(score)
