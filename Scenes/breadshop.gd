extends Control

var Irl_Bought: bool = false
var Top_Bought: bool = false

func _on_irl_pressed() -> void:
	if Irl_Bought:
		SignalBus.skin = "IRL"
		return # Exit immediately if already triggered
		
		
	if SignalBus.score >= 1:
		SignalBus.score -= 1
		Irl_Bought = true
		SignalBus.skin = "IRL"
		


func _on_top_pressed() -> void:
	if Top_Bought:
		SignalBus.skin = "tophat"
		return # Exit immediately if already triggered


	if SignalBus.score >= 1:
		SignalBus.score -= 1
		Top_Bought = true
		SignalBus.skin = "tophat"
