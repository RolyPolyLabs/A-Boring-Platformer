extends Control


func _on_button_pressed() -> void:
	OS.shell_open("https://www.youtube.com/channel/UCVuv5iaVR55QXIc_BHQLakA")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
