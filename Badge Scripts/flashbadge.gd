extends Control
@onready var badge: AnimatedSprite2D = $Badge
@onready var label: Label = $Label
@onready var button: Button = $Button


func _ready() -> void:
	# Set initial default appearance
	button.text = "Equip"
	# Modulate tints the button; you can also swap styleboxes for cleaner colors
	button.modulate = Color.GREEN 
	badge.modulate = Color(0.255, 0.255, 0.255, 1.0)
	SignalBus.BadgeFlashAmount = 1
	

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Un-Equip"
		button.modulate = Color.RED
		badge.modulate = Color.WHITE
		SignalBus.BadgeFlashAmount = 1.5
	else:
		button.text = "Equip"
		button.modulate = Color.GREEN
		badge.modulate = Color(0.255, 0.255, 0.255, 1.0)
		SignalBus.BadgeFlashAmount = 1
