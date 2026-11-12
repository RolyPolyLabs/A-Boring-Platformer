extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label
@export var balloon: DialogueResource
func _input(event: InputEvent) -> void:
	# Check if action is pressed, bodies array is NOT empty, and text isn't already active
	if event.is_action_pressed("Interact") and not area_2d.get_overlapping_bodies().is_empty() and SignalBus.intext == false:
		print("Text Entered")
		SignalBus.intext = true
		
		# Show the dialogue balloon
		animated_sprite_2d.play("Talk")
		DialogueManager.show_dialogue_balloon(balloon, "start")
		SignalBus.emit_signal("PlayerPause")
		# Wait for DialogueManager to finish the dialogue session
		await DialogueManager.dialogue_ended
		animated_sprite_2d.play("Idle")
		SignalBus.intext = false
		SignalBus.emit_signal("PlayerUnpause")


func _on_area_2d_body_entered(body: Node2D) -> void:
	label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	label.hide()
