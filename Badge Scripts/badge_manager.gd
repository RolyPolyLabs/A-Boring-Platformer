extends Control
@onready var menu: CanvasLayer = $CanvasLayer
@onready var boot: Control = $CanvasLayer/GridContainer/Boot
@onready var jump: Control = $CanvasLayer/GridContainer/Jump
@onready var flash: Control = $CanvasLayer/GridContainer/Flash
@onready var bread: Control = $CanvasLayer/GridContainer/Bread

signal pause_requested
var frozen: bool = false

func _ready() -> void:
	pause_requested.connect(_on_pause_requested)
	SignalBus.ObtainedBadge.connect(_refresh_badges)
	frozen = false
	get_tree().paused = false
	if menu:
		menu.visible = false
	_refresh_badges()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_badge"):
		pause_requested.emit()

func _refresh_badges() -> void:
	if boot:
		boot.visible = SignalBus.HasBootBadge
	if jump:
		jump.visible = SignalBus.HasJumpBadge
	if flash:
		flash.visible = SignalBus.HasFlashBadge
	if bread:
		bread.visible = SignalBus.HasBreadBadge

func _on_pause_requested() -> void:
	frozen = !frozen
	
	if frozen:
		print("Game Paused!")
		get_tree().paused = true
		if menu:
			menu.visible = true
		_refresh_badges()
	else:
		print("Game Resumed!")
		if menu:
			menu.visible = false
		get_tree().paused = false
		SignalBus.emit_signal("PauseMusic")
