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
var map1: int = 0
var bulletspeed = 1000
var skin = "normal" # Change to "normal", "tophat", or "IRL"
signal PlayerPause
signal PlayerUnpause
var hasmap = false
var intext = false
var HasBootBadge = false
var HasJumpBadge = false
var HasHeartBadge = false
var HasFlashBadge = false
var HasBreadBadge = false
signal ObtainedBadge
var BadgeSpeedAmount = 1
var BadgeJumpAmount = 1
var BadgeHealthAmount = 1
var BadgeFlashAmount = 1
var BadgeBreadAmount = 1
signal openbadgeshop
var town_unlcoked = false

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
	SaveManager.saved.connect(_on_save_file)
	SaveManager.loaded_save_file.connect(_on_load_file)

func _apply_startup_volume() -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if Volume <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(Volume / 100.0))

func _on_save_file(_export_data: Dictionary) -> void:
	var bus_data := {
		"score": score,
		"skin": skin,
		"hasmap": hasmap,
		"HasBootBadge": HasBootBadge,
		"HasJumpBadge": HasJumpBadge,
		"HasHeartBadge": HasHeartBadge,
		"HasFlashBadge": HasFlashBadge,
		"HasBreadBadge": HasBreadBadge,
	}
	SaveManager.add_to_save({"signal_bus": bus_data})

func _on_load_file(incoming_data: Dictionary = {}) -> void:
	if incoming_data.is_empty():
		incoming_data = SaveManager.get_sav_data()
	if not incoming_data.has("signal_bus"):
		return

	var bus_data: Dictionary = incoming_data["signal_bus"]
	if bus_data.has("score"):
		score = int(bus_data["score"])
		ScoreChanged.emit()
	if bus_data.has("skin"):
		skin = str(bus_data["skin"])
	if bus_data.has("hasmap"):
		hasmap = bool(bus_data["hasmap"])
	if bus_data.has("HasBootBadge"):
		HasBootBadge = bool(bus_data["HasBootBadge"])
	if bus_data.has("HasJumpBadge"):
		HasJumpBadge = bool(bus_data["HasJumpBadge"])
	if bus_data.has("HasHeartBadge"):
		HasHeartBadge = bool(bus_data["HasHeartBadge"])
	if bus_data.has("HasFlashBadge"):
		HasFlashBadge = bool(bus_data["HasFlashBadge"])
	if bus_data.has("HasBreadBadge"):
		HasBreadBadge = bool(bus_data["HasBreadBadge"])

	ScoreChanged.emit()
	ObtainedBadge.emit()
