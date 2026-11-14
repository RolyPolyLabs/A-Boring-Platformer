extends Area2D
@onready var coin_2: AudioStreamPlayer2D = $Coin2

func _on_body_entered(body):
	var BreadMultiplier = SignalBus.BadgeBreadAmount
	SignalBus.ScoreChanged.emit(SignalBus.score)
	$Coin2.play()
	for i in range(BreadMultiplier):
		SignalBus.add_point()
	await get_tree().create_timer(0.2).timeout
	queue_free()


	
