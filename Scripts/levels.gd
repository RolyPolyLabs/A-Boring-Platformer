extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_level_1_pressed() -> void:
	SignalBus.emit_signal ("StopMusicBGMENU")
	SignalBus.emit_signal ("BG_MUSIC")
	get_tree().change_scene_to_file("res://Scenes/level 1.tscn")
