extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var spike_texture: Texture2D:
	set(value):
		spike_texture = value
		if sprite_2d:
			sprite_2d.texture = value

func _ready() -> void:
	if spike_texture:
		sprite_2d.texture = spike_texture
