extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var current_direction
func _ready() -> void:
	animated_sprite_2d.play("forward")
	SaveManager.loaded_save_file.connect(_on_data_loaded)
	SaveManager.saved.connect(_on_data_saved)
	
func  _on_data_loaded(incoming_data: Dictionary) :
	if incoming_data.has("player_data"):
		
		var data=incoming_data["player_data"]
		global_position.x=float(data["pos"]["x"])
		global_position.y=float(data["pos"]["y"])

		current_direction=data["facing"]

func _on_data_saved(export_data: Dictionary):
	var data={
		"player_data":{
			"pos":{"x":global_position.x,
				"y":global_position.y},
			"facing":current_direction,
		}
	}
	export_data.merge(data,true)

func _physics_process(delta: float) -> void:


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity=Vector2.ZERO
		
	if current_direction=="back":
		animated_sprite_2d.play("backward")
	else:
		animated_sprite_2d.play("forward")


	if velocity.y<0:
		current_direction="back"
	elif velocity.y>0:
		current_direction="forward"

	move_and_slide()
