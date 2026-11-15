extends Node

@export var required_score: int = 10
@export var signal_bus_flag: String = ""
@export var button: Button

func _ready() -> void:
	if button:
		button.pressed.connect(_on_button_pressed)
		update_button_state()
	else:
		push_warning("Button reference is not assigned in the Inspector.")

func _process(_delta: float) -> void:
	update_button_state()

func update_button_state() -> void:
	if not button:
		return
	
	# Disable button if already unlocked or if score is too low
	if signal_bus_flag != "" and signal_bus_flag in SignalBus and SignalBus.get(signal_bus_flag) == true:
		button.disabled = true
	elif SignalBus.score < required_score:
		button.disabled = true
	else:
		button.disabled = false

func _on_button_pressed() -> void:
	if SignalBus.score >= required_score:
		if signal_bus_flag != "" and signal_bus_flag in SignalBus:
			SignalBus.set(signal_bus_flag, true)
			update_button_state()
