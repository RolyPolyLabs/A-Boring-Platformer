extends PointLight2D

var flash_applied: bool = false

func _ready() -> void:
	texture_scale = 0.1
	SignalBus.lightchange.connect(on_light_change)

func _process(delta: float) -> void:
	check_badge_flash()

func on_light_change() -> void:
	texture_scale += 0.1

func check_badge_flash() -> void:
	if SignalBus.BadgeFlashAmount == 1.5:
		if not flash_applied:
			texture_scale += 0.1
			flash_applied = true
	else:
		if flash_applied:
			texture_scale -= 0.1
			flash_applied = false
