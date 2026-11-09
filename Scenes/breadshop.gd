extends Control

var Irl_Bought: bool = false
var Top_Bought: bool = false
var Robot_Bought: bool = false
var icecream_bought: bool = false
var goose_bought: bool = false
var Racer_bought: bool = false
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var not_enough: AudioStreamPlayer = $"Not Enough"

func _on_normal_pressed() -> void:
	SignalBus.skin = "Normal"


func _on_irl_pressed() -> void:
	if Irl_Bought:
		SignalBus.skin = "IRL"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 0:
		SignalBus.score -= 0
		Irl_Bought = true
		SignalBus.skin = "IRL"
		audio_stream_player.play()
	else:
		not_enough.play()
		


func _on_tophat_pressed() -> void:
	if Top_Bought:
		SignalBus.skin = "tophat"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 2:
		SignalBus.score -= 2
		Top_Bought = true
		SignalBus.skin = "tophat"
		audio_stream_player.play()
		
	else:
		not_enough.play()

func _on_terminator_pressed() -> void:
	if Robot_Bought:
		SignalBus.skin = "robot"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 10:
		SignalBus.score -= 10
		Robot_Bought = true
		SignalBus.skin = "robot"
		audio_stream_player.play()
		
	else:
		not_enough.play()


func _on_ice_cream_pressed() -> void:
	if icecream_bought:
		SignalBus.skin = "icecream"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 5:
		SignalBus.score -= 5
		icecream_bought = true
		SignalBus.skin = "icecream"
		audio_stream_player.play()
		
	else:
		not_enough.play()


func _on_goose_pressed() -> void:
	if goose_bought:
		SignalBus.skin = "goose"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 5:
		SignalBus.score -= 5
		goose_bought = true
		SignalBus.skin = "goose"
		audio_stream_player.play()
		
	else:
		not_enough.play()


func _on_racer_pressed() -> void:
	if Racer_bought:
		SignalBus.skin = "racer"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 5:
		SignalBus.score -= 5
		Racer_bought = true
		SignalBus.skin = "racer"
		audio_stream_player.play()
		
	else:
		not_enough.play()
