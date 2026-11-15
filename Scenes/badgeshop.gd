extends Control
@onready var color_rect: ColorRect = $ColorRect
var audiopos = 0
func _ready() -> void:
	SignalBus.openbadgeshop.connect(_on_openbadgeshop)

func _on_openbadgeshop():
	print("Opened")
	color_rect.show()
	
