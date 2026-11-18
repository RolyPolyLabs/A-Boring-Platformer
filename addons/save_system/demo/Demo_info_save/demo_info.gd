extends Control

@onready var item_list: ItemList = %ItemList
@onready var filename: LineEdit = %filename
@onready var save_btn: Button = %save
@onready var load_btn: Button = %load

var selected_save:=""
var saves:Array=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scan_saves()

func scan_saves():
	saves=SaveManager.get_save_files()
	item_list.clear()
	for save in saves:
		item_list.add_item(save)
		
func _on_save_pressed() -> void:
	SaveManager.save_game(selected_save)
	scan_saves()

func _on_load_button_down() -> void:
	SaveManager.load_game(selected_save)


func _on_filename_text_changed(new_text: String) -> void:
	selected_save=new_text


func _on_item_list_item_selected(index: int) -> void:
	selected_save=item_list.get_item_text(index)
	filename.text=selected_save


func _on_delete_pressed() -> void:
	SaveManager.delete_save(selected_save)
	scan_saves()
