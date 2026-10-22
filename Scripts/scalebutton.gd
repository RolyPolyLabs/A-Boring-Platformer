extends Button

@export var hover_scale: Vector2 = Vector2(1.05, 1.05) # Scales up by 5%
@export var tween_duration: float = 0.15

var default_scale: Vector2

func _ready() -> void:
	default_scale = scale
	# Connect the mouse signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", hover_scale, tween_duration)

func _on_mouse_exited() -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", default_scale, tween_duration)
