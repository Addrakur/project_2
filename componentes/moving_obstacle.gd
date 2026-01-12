extends PathFollow2D

@export var starting_point: float
@export var move_speed: float

@export_group("Node Variables")
@export var screen: Screen

func _ready() -> void:
	progress_ratio = starting_point

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not screen.active:
		return
	
	progress_ratio += move_speed * delta
