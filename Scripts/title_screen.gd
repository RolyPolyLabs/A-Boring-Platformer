extends Control
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_start_pressed() -> void:
	SignalBus.emit_signal("StopMusicBGMENU")
	audio_stream_player.play()
	timer .start()
	


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")


func _on_timer_timeout() -> void:
	SignalBus.emit_signal ("BG_MUSIC")
	get_tree().change_scene_to_file("res://Scenes/level 1.tscn")


func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	SignalBus.emit_signal("StopMusicBGMENU")



func _on_waterflame_pressed() -> void:
		OS.shell_open("https://www.youtube.com/@WaterflameMusic")
