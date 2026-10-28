extends Label
var Bread_Amount = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.ScoreChanged.connect(on_score_changed)
	update_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Bread_Amount = SignalBus.score
	text = str(Bread_Amount)
func on_score_changed(new_count: int) -> void:
	# Set your variable to the new score coming from the Signal Bus
	Bread_Amount = new_count
	print("Bread")
func update_display() -> void:
	text = "Bread: " + str(Bread_Amount)
