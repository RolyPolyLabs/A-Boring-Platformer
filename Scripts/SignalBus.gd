extends Node

signal PlayerDies()
signal BG_MUSIC
signal BGMENU_MUSIC
signal StopMusicBGMENU
var apply_shader: bool = false

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
