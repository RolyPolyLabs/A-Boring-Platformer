extends Node

var playerName:=""
var player_speed:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveManager.loaded_save_file.connect(_on_data_loaded)
	SaveManager.saved.connect(_on_data_saved)
	
	SaveManager.save_game("save1")
	SaveManager.load_game("save1")
	print(playerName,player_speed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_data_loaded(recived_data:Dictionary):
	if recived_data.has("player"):
		var data=recived_data["player"]
		playerName=data["playerName"]
		player_speed=data["player_speed"]
		
func _on_data_saved(exported_data:Dictionary):
	var data={
		"player":{
			"playerName":"whats code",
			"player_speed": 300	
		}
	}
	exported_data.merge(data,true)
