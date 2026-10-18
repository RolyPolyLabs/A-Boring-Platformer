extends CanvasLayer

@onready var scanline_shader: CanvasLayer = $"."

func _ready() -> void:
	# Check the global variable right when the node loads
	if SignalBus.apply_shader:
		show()  # Show if true
	else:
		hide()  # Hide if false
