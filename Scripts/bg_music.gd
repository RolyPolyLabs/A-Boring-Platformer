extends AudioStreamPlayer
@onready var bg_music: AudioStreamPlayer = $"."

func _ready() -> void:
	SignalBus.BG_MUSIC.connect(_on_bg_music_received)
	

func _on_bg_music_received() -> void:
	print("Signal received!")
	bg_music.play()
