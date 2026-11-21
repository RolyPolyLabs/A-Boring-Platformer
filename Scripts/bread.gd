extends Area2D

@onready var coin_2: AudioStreamPlayer2D = $Coin2

func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	var bread_multiplier: int = max(1, int(SignalBus.BadgeBreadAmount))
	for i in range(bread_multiplier):
		SignalBus.add_point()
	SignalBus.ScoreChanged.emit(SignalBus.score)
	coin_2.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()
