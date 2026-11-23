extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if Engine.has_meta("next_spawn") and Engine.get_meta("next_spawn") == "TownHallSpawn":
		Engine.remove_meta("next_spawn")
		var town_hall_spawn: Marker2D = get_node_or_null("TownHallSpawn")
		if town_hall_spawn != null and player != null:
			player.global_position = town_hall_spawn.global_position

func _process(delta: float) -> void:
	pass


func _on_audio_stream_player_finished() -> void:
	SceneManager.change_scene("res://Scenes/title_screen.tscn", {
	"pattern": "diagonal"
})
