extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_dash = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var dash_trail = $DashTrail # Reference to your CPUParticles2D node

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_dash = true
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Dash with collision check and air trail
	if Input.is_action_just_pressed("dash") and (is_on_floor() or can_dash):
		move_and_collide(Vector2(100.0 * direction, 0))
		if not is_on_floor():
			can_dash = false
		
		# Set particle direction opposite to where you are dashing, then trigger them
		if not is_on_floor():
			dash_trail.direction = Vector2(-direction, 0)
			dash_trail.restart()
			dash_trail.emitting = true

	# Play animations
	if is_on_floor():
		if Input.is_action_pressed("down"):
			animated_sprite.play("crouch")
		elif direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Apply Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
