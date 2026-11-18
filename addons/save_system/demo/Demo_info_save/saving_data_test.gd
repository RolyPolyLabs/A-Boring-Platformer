extends PanelContainer

@export var myname: LineEdit
@export var age: LineEdit
@export var skill: OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.loaded_save_file.connect(_on_data_loaded)
	SaveManager.saved.connect(_on_data_saved)
	
func  _on_data_loaded(incoming_data: Dictionary) :
	if incoming_data.has("player_stat"):
		var data=incoming_data["player_stat"]
		myname.text=data["myname"]
		age.text=data["age"]
		skill.select(data["skill"])

func _on_data_saved(export_data: Dictionary):
	var data={
		"player_stat":{
			"myname":myname.text,
			"age":age.text,
			"skill":skill.get_selected_id(),
		}
	}
	export_data.merge(data,true)
