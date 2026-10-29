extends Node

@onready var menu: CanvasLayer = $Menu
@onready var first_button: Control = $"Menu/Arcade Shader"

signal pause_requested
var paused: bool = false

func _ready() -> void:
	pause_requested.connect(_on_pause_requested)
	paused = false
	get_tree().paused = false
	if menu:
		menu.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause"):
		pause_requested.emit()

func _on_pause_requested() -> void:
	paused = !paused
	
	if paused:
		print("Game Paused!")
		get_tree().paused = true
		if menu:
			menu.visible = true
		await get_tree().process_frame
		if first_button:
			first_button.grab_focus()
	else:
		print("Game Resumed!")
		if menu:
			menu.visible = false
		get_tree().paused = false

func _on_restart_pressed() -> void:
	if menu:
		menu.visible = false
	paused = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_pressed() -> void:
	if menu:
		menu.visible = false
	paused = false
	get_tree().paused = false
	SignalBus.emit_signal("PauseMusic")
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
