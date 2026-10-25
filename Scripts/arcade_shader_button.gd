extends CheckButton

func _ready() -> void:
	# 1. Set the initial state based on the global variable when loaded
	set_pressed_no_signal(SignalBus.apply_shader)
	
	# 2. Listen for user clicks on this button
	toggled.connect(_on_button_toggled)
	
	# 3. Listen if the *other* button (or code) changes the state via SignalBus
	SignalBus.shader_toggled.connect(_on_signal_bus_toggled)

func _on_button_toggled(toggled_on: bool) -> void:
	# Update the global variable in SignalBus when clicked
	SignalBus.apply_shader = toggled_on

func _on_signal_bus_toggled(toggled_on: bool) -> void:
	# Safely update this button's visual state to match without triggering loops
	set_pressed_no_signal(toggled_on)
