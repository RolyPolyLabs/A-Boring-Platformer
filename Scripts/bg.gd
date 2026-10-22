extends Node2D

@onready var background: TextureRect = $TextureRect # Make sure this matches your node name

# How much the background can move at maximum (in pixels)
@export var max_move_amount: float = 30.0

# How smooth the movement is (lower = smoother/slower lerp)
@export var lerp_speed: float = 5.0

# Store the default starting position of the background
var base_position: Vector2

func _ready() -> void:
	if background:
		base_position = background.position
	else:
		push_error("TextureRect child not found! Check your node name.")

func _process(delta: float) -> void:
	if not background:
		return
		
	# 1. Get the total screen/viewport size
	var viewport_size = get_viewport_rect().size
	var center = viewport_size / 2.0
	
	# 2. Get current mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	
	# 3. Calculate how far the mouse is from the center (-1.0 to 1.0 range)
	var mouse_offset_percentage = Vector2(
		(mouse_pos.x - center.x) / center.x,
		(mouse_pos.y - center.y) / center.y
	)
	
	# 4. Calculate the target position based on that offset
	# We multiply by -1 so the background moves *away* from the mouse, creating depth
	var target_offset = mouse_offset_percentage * max_move_amount * -1.0
	var target_position = base_position + target_offset
	
	# 5. Smoothly slide the background to the target position
	background.position = background.position.lerp(target_position, lerp_speed * delta)
