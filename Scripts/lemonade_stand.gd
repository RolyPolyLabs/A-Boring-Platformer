extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(.5).timeout  # Wait for 1 second
	SignalBus.emit_signal("ResumeMusic")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("This reminds you of something...")
	SignalBus.emit_signal("PauseMusic")


func _on_area_2d_body_exited(body: Node2D) -> void:
	SignalBus.emit_signal("ResumeMusic")
