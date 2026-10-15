extends StaticBody2D
@export var Spike_Texture: Texture2D:
	set(value):
		Spike_Texture = value
		if has_node("Sprite2D"):
			$Sprite2D.texture = value
