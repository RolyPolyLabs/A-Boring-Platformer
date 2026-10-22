extends AudioStreamPlayer

func _ready() -> void:
	SignalBus.BG_MUSIC.connect(_on_bg_music_received)
	SignalBus.PauseMusic.connect(Pause_Music)
	SignalBus.ResumeMusic.connect(Resume_Music)

func _on_bg_music_received() -> void:
	print("Signal received!")
	play()

func Pause_Music() -> void:
	stream_paused = true

func Resume_Music() -> void:
	stream_paused = false
