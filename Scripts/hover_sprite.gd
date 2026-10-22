extends Node2D

@onready var hover_sprite: Sprite2D = $Area2D/hover_sprite
var hover_state: bool = false
@export var fade_speed: float = 2.0

func _ready():
	hover_sprite.modulate.a = 0.0
	hover_sprite.visible = false

func _process(delta):
	if hover_state:
		# Fade in
		if not hover_sprite.visible:
			hover_sprite.visible = true
		hover_sprite.modulate.a = move_toward(hover_sprite.modulate.a, 1.0, fade_speed * delta)
	else:
		# Fade out
		hover_sprite.modulate.a = move_toward(hover_sprite.modulate.a, 0.0, fade_speed * delta)
		if hover_sprite.modulate.a == 0.0:
			hover_sprite.visible = false

func _on_area_2d_mouse_entered() -> void:
	hover_state = true

func _on_area_2d_mouse_exited() -> void:
	hover_state = false
