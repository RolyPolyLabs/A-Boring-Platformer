
extends Node2D

const TOUCH_DISTANCE := 64.0
const MOVE_DURATION := 3.0
const SWIRL_DURATION := 3.0
const SWIRL_SPINS := 11.0
const FORWARD_RATIO := 1.0
const REVERSE_RATIO := 0.0
@onready var audio_stream_player: AudioStreamPlayer = $"../../../AudioStreamPlayer"

@export var level_1_scene: PackedScene
@export var level_2_scene: PackedScene
@export_range(0.0, 1.0, 0.01) var start_ratio: float = 0.0
@onready var portal: AnimatedSprite2D = $"../Animated Sprite 2d"
@onready var path_follow_2d: PathFollow2D = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var point_1: Node2D = $"../../../Point1"
@onready var point_2: Node2D = $"../../../Point2"
@onready var first_path: CanvasItem = $"../../../First Path"
@onready var camera_2d_unzoomed: Camera2D = $Camera2D
@onready var camera_2d: Camera2D = $"../../../Camera2D"

var _active_tween: Tween
var _swirl_tween: Tween
var _is_swirling := false


func _ready() -> void:
	if path_follow_2d != null:
		path_follow_2d.progress_ratio = clampf(start_ratio, 0.0, 1.0)

	if animated_sprite_2d != null:
		animated_sprite_2d.play("default")


func _process(_delta: float) -> void:
	if _is_swirling:
		return

	_update_cameras()
	_try_enter_level_on_space()
	_try_start_path_movement()


func _try_enter_level_on_space() -> void:
	if point_1 == null or point_2 == null:
		return

	if not Input.is_key_pressed(KEY_SPACE):
		return

	var near_p1 := global_position.distance_to(point_1.global_position) <= TOUCH_DISTANCE
	var near_p2 := global_position.distance_to(point_2.global_position) <= TOUCH_DISTANCE
	portal.show()
	if near_p1:
		_start_swirl_and_enter(point_1.global_position, level_1_scene)
	elif near_p2:
		_start_swirl_and_enter(point_2.global_position, level_2_scene)


func _start_swirl_and_enter(center_pos: Vector2, target_scene: PackedScene) -> void:
	_is_swirling = true
	audio_stream_player.play()
	if _active_tween != null and _active_tween.is_running():
		_active_tween.kill()

	if _swirl_tween != null and _swirl_tween.is_running():
		_swirl_tween.kill()

	if animated_sprite_2d != null:
		animated_sprite_2d.play("walk")

	var start_rot := rotation_degrees
	var end_rot := start_rot + 360.0 * SWIRL_SPINS

	var start_scale := scale

	_swirl_tween = create_tween()
	_swirl_tween.set_parallel(true)

	_swirl_tween.tween_method(func(t: float) -> void:
		global_position = center_pos
		rotation_degrees = lerp(start_rot, end_rot, t)
	, 0.0, 1.0, SWIRL_DURATION)

	_swirl_tween.tween_property(
		self,
		"scale",
		Vector2.ZERO,
		SWIRL_DURATION
	)

	_swirl_tween.finished.connect(func() -> void:
		rotation_degrees = 0.0

		if path_follow_2d != null:
			global_position = path_follow_2d.global_position

		if target_scene != null:
			get_tree().change_scene_to_packed(target_scene)
		else:
			_is_swirling = false

			scale = start_scale

			if animated_sprite_2d != null:
				animated_sprite_2d.play("default")
	)


func _try_start_path_movement() -> void:
	if path_follow_2d == null or point_1 == null or point_2 == null or first_path == null:
		return

	var near_p1 := global_position.distance_to(point_1.global_position) <= TOUCH_DISTANCE
	var near_p2 := global_position.distance_to(point_2.global_position) <= TOUCH_DISTANCE

	# Block movement at Point1 when First Path is visible.
	if near_p1 and first_path.visible:
		if _active_tween != null and _active_tween.is_running():
			_active_tween.kill()

		if animated_sprite_2d != null:
			animated_sprite_2d.play("default")
		return

	if _active_tween != null and _active_tween.is_running():
		return

	if near_p1 and Input.is_action_pressed("move_right"):
		_start_move(FORWARD_RATIO)
	elif near_p1 and Input.is_action_pressed("move_left"):
		_start_move(REVERSE_RATIO)
	elif near_p2 and Input.is_action_pressed("move_left"):
		_start_move(REVERSE_RATIO)

func _start_move(target_ratio: float) -> void:
	if is_equal_approx(path_follow_2d.progress_ratio, target_ratio):
		return

	if animated_sprite_2d != null:
		animated_sprite_2d.flip_h = target_ratio < path_follow_2d.progress_ratio
		animated_sprite_2d.play("walk")

	_active_tween = create_tween()
	_active_tween.tween_property(
		path_follow_2d,
		"progress_ratio",
		target_ratio,
		MOVE_DURATION
	)

	_active_tween.finished.connect(func() -> void:
		if animated_sprite_2d != null:
			animated_sprite_2d.play("default")
	)


func _update_cameras() -> void:
	if camera_2d == null or camera_2d_unzoomed == null:
		return

	var use_main := Input.is_key_pressed(KEY_V)

	camera_2d_unzoomed.enabled = not use_main
	camera_2d.enabled = use_main
