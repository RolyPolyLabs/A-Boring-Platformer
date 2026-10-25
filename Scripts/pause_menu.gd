extends Node
@onready var menu: CanvasLayer = $Menu
signal pause_requested
var paused: bool = false

func _ready() -> void:
	pause_requested.connect(_on_pause_requested)

func _input(event: InputEvent) -> void:
	# Listens for 'P' at all times because Process Mode is set to 'Always'
	if event.is_action_pressed("toggle_pause"):
		pause_requested.emit()

func _on_pause_requested() -> void:
	paused = !paused
	
	# This pauses everything else in the scene tree except this autoload node
	get_tree().paused = paused
	
	if paused:
		print("Game Paused! (Autoload is still running)")
		menu.show()
	else:
		print("Game Resumed!")
		menu.hide()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	pause_requested.emit()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	pause_requested.emit()
	SignalBus.emit_signal("PauseMusic")
