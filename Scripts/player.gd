extends CharacterBody2D
@onready var dash_sound: AudioStreamPlayer = $DashSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var eye_laser: Marker2D = $EyeLaser

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 600.0
const FRICTION = 1200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_dash = true
var skin = SignalBus.skin
@export var push_force = 120.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_trail = $DashTrail
@onready var up_dash_trail = $UpDashTrail
@onready var walk_particles: CPUParticles2D = $WalkParticles
const LASER = preload("res://Scenes/laser.tscn")

func trigger_jump_pad(launch_force: float):
	velocity.y = launch_force
	
	up_dash_trail.emitting = false
	up_dash_trail.rotation = 0.0
	up_dash_trail.direction = Vector2(0, -1)
	up_dash_trail.restart()
	up_dash_trail.emitting = true

# Updated helper function to handle different skins
func play_anim(anim_name: String):
	if skin == "tophat":
		animated_sprite.play(anim_name + " tophat")
	elif skin == "IRL":
		animated_sprite.play(anim_name + " IRL") 
	elif skin == "robot":
		animated_sprite.play(anim_name + " robot")
	elif skin == "icecream":
		animated_sprite.play(anim_name + " icecream")
	elif skin == "goose":
		animated_sprite.play(anim_name + " goose")
	elif skin == "racer":
		animated_sprite.play(anim_name + " racer")
	else:
		animated_sprite.play(anim_name)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_dash = true
		
	if Input.is_action_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# --- Walking Particle Logic ---
	if is_on_floor() and direction != 0:
		walk_particles.emitting = true
		
		if animated_sprite.flip_h:
			walk_particles.direction = Vector2(1, -0.5)
			walk_particles.position.x = 5
		else:
			walk_particles.direction = Vector2(-1, -0.5)
			walk_particles.position.x = -5
	else:
		walk_particles.emitting = false
	# -----------------------------

	if Input.is_action_just_pressed("dash") and (is_on_floor() or can_dash):
		dash_sound.play()
		var input_x = Input.get_axis("move_left", "move_right")
		var input_y = -1.0 if (Input.is_action_pressed("jump") and not is_on_floor()) else 0.0
		
		var dash_dir = Vector2(input_x, input_y)
		
		if dash_dir == Vector2.ZERO:
			dash_dir = Vector2(-1.0 if animated_sprite.flip_h else 1.0, 0.0)
		else:
			dash_dir = dash_dir.normalized()
			
		if dash_dir.y < 0:
			velocity.y = 0
			
		move_and_collide(dash_dir * 50.0)
		
		if not is_on_floor():
			if dash_dir.y < 0:
				up_dash_trail.emitting = false
				up_dash_trail.rotation = dash_dir.angle() + (PI / 2)
				up_dash_trail.direction = Vector2(0, 1)
				up_dash_trail.restart()
				up_dash_trail.emitting = true
			else:
				dash_trail.emitting = false
				dash_trail.direction = -dash_dir
				dash_trail.restart()
				dash_trail.emitting = true

		if not is_on_floor():
			can_dash = false

	if is_on_floor():
		if Input.is_action_pressed("down"):
			play_anim("crouch")
		elif direction == 0:
			play_anim("Idle")
		else:
			play_anim("run")
	else:
		play_anim("jump")

	# Horizontal movement calculation
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# --- Movement & PushableBlock Integration ---
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is PushableBlock:
			collider.apply_central_impulse(-collision.get_normal() * push_force)
@onready var default_laser_x: float = eye_laser.position.x # 1. Cache the default positive offset

func _process(delta: float) -> void:
	if skin == "robot":
		if Input.is_action_just_pressed("fire"):
			var laser_instance = LASER.instantiate()
			get_tree().current_scene.add_child(laser_instance)
			laser_instance.global_position = eye_laser.global_position 
			laser_instance.rotation = rotation
			$Laser.play()
		
		var direction = Input.get_axis("move_left", "move_right")
		if direction > 0:
			SignalBus.bulletspeed = 1000
			eye_laser.position.x = abs(default_laser_x) # 2. Ensure position is positive on the right
		elif direction < 0:
			SignalBus.bulletspeed = -1000
			eye_laser.position.x = -abs(default_laser_x) # 3. Negate position to flip to the left
