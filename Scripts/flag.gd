extends StaticBody2D

@export_file("*.tscn") var next_scene: String

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var node2d_particles: Node2D = $Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		trigger_all_bursts()
		audio_stream_player.play()
		await get_tree().create_timer(0.5).timeout
		
		if next_scene:
			get_tree().change_scene_to_file(next_scene)

func trigger_all_bursts() -> void:
	for child in node2d_particles.get_children():
		if child is CPUParticles2D:
			child.restart()
