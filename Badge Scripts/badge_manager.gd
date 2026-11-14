extends Control
@onready var menu: CanvasLayer = $CanvasLayer

signal pause_requested
var frozen: bool = false

func _ready() -> void:
	pause_requested.connect(_on_pause_requested)
	frozen = false
	get_tree().paused = false
	if menu:
		menu.visible = false 	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_badge"):
		pause_requested.emit()

func _on_pause_requested() -> void:
	frozen = !frozen
	
	if frozen:
		print("Game Paused!")
		get_tree().paused = true
		if menu:
			menu.visible = true
	else:
		print("Game Resumed!")
		if menu:
			menu.visible = false
		get_tree().paused = false
