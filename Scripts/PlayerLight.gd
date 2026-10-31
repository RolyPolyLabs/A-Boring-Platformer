extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		texture_scale = .1
		SignalBus.lightchange.connect(on_light_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func on_light_change() -> void:
	texture_scale += .2
