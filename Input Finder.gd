extends Node

func _input(event):
	if event is InputEventJoypadButton and event.pressed:
		print("DEBUG INPUT: Pressed Joypad Button Index -> ", event.button_index)
	elif event is InputEventKey and event.pressed:
		print("DEBUG INPUT: Pressed Key -> ", event.keycode)
