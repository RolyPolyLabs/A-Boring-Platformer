extends CharacterBody2D
@onready var dash_sound: AudioStreamPlayer = $DashSound
@onready var jump_sound: AudioStreamPlayer = $JumpSound

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const ACCELERATION = 600.0
const FRICTION = 1200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_dash = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_trail = $DashTrail
@onready var up_dash_trail = $UpDashTrail

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_dash = true
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

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
			
		move_and_collide(dash_dir * 100.0)
		
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
			animated_sprite.play("crouch")
		elif direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	move_and_slide()
