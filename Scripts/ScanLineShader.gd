extends CanvasLayer

func _ready() -> void:
	# 1. Set the initial state when the scene loads
	_update_shader_visibility(SignalBus.apply_shader)
	
	# 2. Listen for future changes from SignalBus instantly!
	SignalBus.shader_toggled.connect(_update_shader_visibility)

func _update_shader_visibility(is_active: bool) -> void:
	if is_active:
		show()
	else:
		hide()
