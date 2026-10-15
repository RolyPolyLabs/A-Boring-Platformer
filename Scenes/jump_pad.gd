extends StaticBody2D
@onready var sound_effect: AudioStreamPlayer = $SoundEffect

@export var launch_force: float = -400.0

@export var pad_texture: Texture2D:
	set(value):
		pad_texture = value
		if has_node("Sprite2D"):
			$Sprite2D.texture = value

func _ready() -> void:
	$LaunchZone.body_entered.connect(_on_launch_zone_body_entered)
	if pad_texture and has_node("Sprite2D"):
		$Sprite2D.texture = pad_texture

func _on_launch_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		sound_effect.play()
		body.velocity.y = launch_force
	elif body is RigidBody2D:
		body.linear_velocity = Vector2(body.linear_velocity.x, launch_force)
