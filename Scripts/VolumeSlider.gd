extends HSlider

@export var audio_bus_name: String = "Master"
@export var volume_label: Label  # Drag your Label node here in the Inspector
var _bus_index: int

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index(audio_bus_name)
	
	# Initialize slider position and label from the SignalBus variable
	value = SignalBus.Volume
	_update_label(SignalBus.Volume)
	
	# Apply initial volume to the audio server
	_update_audio_volume(SignalBus.Volume)
	
	# Connect the value_changed signal
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	# Update the SignalBus variable
	SignalBus.Volume = new_value
	
	# Update the label display
	_update_label(new_value)
	
	# Apply the change to the audio
	_update_audio_volume(new_value)

func _update_label(slider_value: float) -> void:
	if volume_label:
		# Converts float to a whole number percentage string (e.g., "50%")
		volume_label.text = str(round(slider_value)) + "%"

func _update_audio_volume(slider_value: float) -> void:
	if slider_value <= 0.0:
		AudioServer.set_bus_mute(_bus_index, true)
	else:
		AudioServer.set_bus_mute(_bus_index, false)
		var db = linear_to_db(slider_value / 100.0)
		AudioServer.set_bus_volume_db(_bus_index, db)
