extends Node

signal PlayerDies()
signal BG_MUSIC
signal BGMENU_MUSIC
signal StopMusicBGMENU
signal PauseMusic
signal ResumeMusic
var light: int = 1
signal lightchange
signal shader_toggled(enabled: bool)
var score: int = 0
signal ScoreChanged



func add_point(amount: int = 1):
	score += amount
	print("Score updated:", score)
var apply_shader: bool = false:
	set(value):
		if apply_shader != value:
			apply_shader = value
			shader_toggled.emit(value)
var Volume: float = 50.0

func _ready() -> void:
	_apply_startup_volume()

func _apply_startup_volume() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if Volume <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(Volume / 100.0))
