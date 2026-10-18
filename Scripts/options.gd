extends Control
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"Main Menu/Menu Options/TestVolume/AudioStreamPlayer2D"


func _on_test_volume_pressed() -> void:
	audio_stream_player_2d.play()


func _on_arcade_shader_pressed() -> void:
	SignalBus.apply_shader = true
