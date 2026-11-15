extends Node2D

const SPEED = 60
var direction = 1
@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var killzone: Area2D = $Killzone

func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	position.x += direction * SPEED * delta


func _on_deathzone_body_entered(body: Node2D) -> void:
	
	if body is CharacterBody2D:
		killzone.monitoring = false
		body.velocity.y = -200.0
		print("Snake Killed")
		audio_stream_player_2d.play()
		
		
		


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
