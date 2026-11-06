extends Node2D
@onready var deathzone: Area2D = $Deathzone
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_deathzone_area_entered(area: Area2D) -> void:
	print("Something entered the bat: ", area.name, " | Groups: ", area.get_groups())
	
	if area.is_in_group("Projectiles"):
		print("Bat hit by laser!")
		area.queue_free()
		audio_stream_player_2d.play()
		


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
