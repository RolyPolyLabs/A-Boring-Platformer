extends AudioStreamPlayer
@onready var bg_music: AudioStreamPlayer = $"."

func _ready() -> void:
	SignalBus.BGMENU_MUSIC.connect(_on_bg_music_received)
	SignalBus.StopMusicBGMENU.connect(_on_stop_received)
	SignalBus.emit_signal ("BGMENU_MUSIC")

func _on_bg_music_received() -> void:
	bg_music.play()
func _on_stop_received() -> void:
	bg_music.stop()
