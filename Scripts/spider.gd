extends Node2D

@onready var killzone: Area2D = $Killzone
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var deathzone: Area2D = $Deathzone
@onready var bounce_zone: Area2D = $BounceZone
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var texture_rect: TextureRect = $TextureRect

var hits = 0


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass


func _on_bounce_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = -400.0


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Explode":
		texture_rect.show()


func _on_deathzone_body_entered(body: Node2D) -> void:
	hits += 1
	print("+1 Hit")
	audio_stream_player_2d.play()
	if hits >= 3:
		if is_instance_valid(killzone): killzone.queue_free()
		if is_instance_valid(deathzone): deathzone.queue_free()
		if is_instance_valid(bounce_zone): bounce_zone.queue_free()
		animated_sprite_2d.play("Dead")
		var locked_position = global_position 
		animation_player.stop()
		animation_player.play("Explode")
		global_position = locked_position
		SignalBus.emit_signal("PauseMusic")
		audio_stream_player_2d_2.play()
