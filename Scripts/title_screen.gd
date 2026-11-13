extends Control

@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var start_button: Button = $"Main Menu/Menu Options/Start"
var hasmap = false
func _ready() -> void:
	start_button.call_deferred("grab_focus")

func _on_start_pressed() -> void:
	hasmap = SignalBus.hasmap
	if hasmap == true:
		get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
	else:
		SignalBus.emit_signal("StopMusicBGMENU")
		audio_stream_player.play()
		timer.start()
		

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_timer_timeout() -> void:
	SignalBus.emit_signal("BG_MUSIC")
	SceneManager.change_scene("res://Scenes/level 1.tscn", {
	"pattern": "diagonal",
	"speed": 10
	})
	

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	SignalBus.emit_signal("StopMusicBGMENU")

func _on_waterflame_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@WaterflameMusic")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Breadshop.tscn")


func _on_map_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/map.tscn")
