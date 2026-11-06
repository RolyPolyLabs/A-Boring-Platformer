extends Area2D
var speed = SignalBus.bulletspeed
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	position += transform.x * speed *delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
