extends Camera2D
@onready var death: ColorRect = $"../../Death"
@onready var death_label: CanvasLayer = $"../../DeathLabel"

func _ready() -> void:
	# Connect to the global SignalBus
	SignalBus.connect("PlayerDies", _Player_Died)
	

func _Player_Died() -> void:
	# Tint the screen red (with a slight alpha/transparency so it looks like a tint)
	death.color = Color(1, 0, 0, 0.4)
	death_label.show()
