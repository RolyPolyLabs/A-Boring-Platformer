extends Area2D
@onready var death_sfx: AudioStreamPlayer2D = $DeathSFX
@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	# Exit early if whatever entered is NOT the player
	if not body.is_in_group("Player"):
		return
		
	print("You Died!")
	death_sfx.play()
	SignalBus.emit_signal("PlayerDies")
	Engine.time_scale = 0.5
	
	var collision_shape = body.get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.queue_free()
		
	timer.start()
func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
 
