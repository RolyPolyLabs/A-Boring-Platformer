extends TextureRect
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var canvas_modulate: CanvasModulate = $"../../CanvasModulate"
@onready var canvas_layer_2: CanvasLayer = $"../../CanvasLayer2"




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	SignalBus.hasmap = true
	canvas_layer_2.show()
	$AudioStreamPlayer.play()
	SignalBus.map1 = 1
	
	
	
