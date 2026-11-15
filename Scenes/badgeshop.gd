extends Control
@onready var color_rect: ColorRect = $ColorRect
var audiopos = 0
@onready var badgeshop: CanvasLayer = $".."
func _ready() -> void:
	SignalBus.openbadgeshop.connect(_on_openbadgeshop)

func _on_openbadgeshop():
	print("Opened")
	$".".show()
	


func _on_hide_pressed() -> void:
	hide()


func _on_bread_plus_pressed() -> void:
	SignalBus.score += 1
