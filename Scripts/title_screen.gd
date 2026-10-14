extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var timer: Timer = $Timer


func _on_start_pressed() -> void:
	audio_stream_player.play()
	timer .start()
	


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
