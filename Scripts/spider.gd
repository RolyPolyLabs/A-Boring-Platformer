extends Node2D

@onready var killzone: Area2D = $Killzone
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var deathzone: Area2D = $Deathzone
@onready var bounce_zone: Area2D = $BounceZone
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var hits = 0


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_deathzone_body_entered(body: Node2D) -> void:
	hits += 1
	print("+1 Hit")
	audio_stream_player_2d.play()
	if hits >= 5:
		if is_instance_valid(killzone): killzone.queue_free()
		if is_instance_valid(animation_player): animation_player.queue_free()
		if is_instance_valid(deathzone): deathzone.queue_free()
		if is_instance_valid(bounce_zone): bounce_zone.queue_free()
		animated_sprite_2d.play("Dead")

func _on_bounce_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = -400.0
