extends StaticBody2D # Use StaticBody3D if you are in 3D

@export var possible_rewards: Array[PackedScene] = []
@export var opened_texture: Texture2D # Optional: texture for opened box

var is_opened: bool = false

func _ready() -> void:
	# Connect to the child Area2D's signal
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not is_opened:
		open_box()

func open_box() -> void:
	is_opened = true
	
	# 1. Disable the trigger area so it can't be opened again
	# (The StaticBody2D collision remains active, so the box stays solid!)
	set_deferred("monitoring", false)
	
	# 2. Change the visual state to show it's opened
	if opened_texture:
		$Sprite2D.texture = opened_texture
	else:
		modulate = Color(0.6, 0.6, 0.6) # Fallback tint
	
	# 3. Spawn the random reward
	if possible_rewards.size() > 0:
		spawn_reward()
	else:
		print("No rewards assigned to this box!")

func spawn_reward() -> void:
	var random_index = randi() % possible_rewards.size()
	var reward_scene = possible_rewards[random_index]
	
	if reward_scene:
		var reward_instance = reward_scene.instantiate()
		
		# Position the reward slightly above the box
		reward_instance.global_position = global_position + Vector2(0, -10) # Use Vector3(0, 1, 0) for 3D
		
		# Add the reward to the main game scene
		get_tree().current_scene.call_deferred("add_child", reward_instance)
