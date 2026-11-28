extends PathFollow2D

const TARGET_RATIO := 1
const DURATION := 3.0
const TOUCH_DISTANCE := 5.0

@onready var player: Node2D = $Player
@onready var animated_sprite_2d: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var point_1: Marker2D = $"../../Point1"
@onready var point_2: Marker2D = $"../../Point2"

var _elapsed := 0.0
var _start_ratio := 0.0
var _end_ratio := 0.0
var _moving := false

func _ready() -> void:
	progress_ratio = 0.0
	_moving = false
	if animated_sprite_2d != null:
		animated_sprite_2d.play("default")

func _process(delta: float) -> void:
	if not _moving:
		_try_start_movement()
		return

	_elapsed += delta
	var t := clampf(_elapsed / DURATION, 0.0, 1.0)
	progress_ratio = lerpf(_start_ratio, _end_ratio, t)

	if t >= 1.0:
		_moving = false
		if animated_sprite_2d != null:
			animated_sprite_2d.play("default")

func _try_start_movement() -> void:
	if player == null or point_1 == null or point_2 == null:
		return

	var near_point_1 := player.global_position.distance_to(point_1.global_position) <= TOUCH_DISTANCE
	var near_point_2 := player.global_position.distance_to(point_2.global_position) <= TOUCH_DISTANCE

	if near_point_1 and Input.is_action_pressed("move_right") and not is_equal_approx(progress_ratio, TARGET_RATIO):
		_begin_move(TARGET_RATIO)
	elif near_point_2 and Input.is_action_pressed("move_left") and not is_equal_approx(progress_ratio, 0.0):
		_begin_move(0.0)

func _begin_move(new_target: float) -> void:
	_start_ratio = progress_ratio
	_end_ratio = new_target
	_elapsed = 0.0
	_moving = true
	if animated_sprite_2d != null:
		animated_sprite_2d.play("walk")
