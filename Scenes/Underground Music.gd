extends Area2D
@onready var audio_player: AudioStreamPlayer2D = $Bg


func _ready() -> void:
	audio_player.volume_db = -80.0
	audio_player.play()

func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", 0.0, 1)

func _on_body_exited(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -80.0, 1.5)
