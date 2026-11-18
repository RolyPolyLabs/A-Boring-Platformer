@tool
extends EditorPlugin
const savemanger ="res://addons/save_system/SaveManager.gd"



func _enter_tree() -> void:
	add_autoload_singleton("SaveManager",savemanger)

		
func _exit_tree() -> void:
	remove_autoload_singleton("SaveManager")
