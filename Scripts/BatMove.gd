extends PathFollow2D

@export var normal_speed: float = 150
var speed: float = 0
var direction: int = 1 # 1 = forward, -1 = backward
var stop_pending: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	speed = normal_speed
	stop_pending = false # Cancel any pending stop if you re-enter

func _on_area_2d_body_exited(body: Node2D) -> void:
	# Don't stop immediately; flag it to stop when the current trip finishes
	stop_pending = true

func _process(delta: float) -> void:
	progress += speed * direction * delta

	# Reverse when reaching either end
	if progress_ratio >= 1.0:
		direction = -1
		if stop_pending:
			speed = 0
			stop_pending = false
	elif progress_ratio <= 0.0:
		direction = 1
		if stop_pending:
			speed = 0
			stop_pending = false
