extends StaticBody2D

@export var speed: float
@export var move_points: Array[Marker2D]
@export var starting_point_index: float

var current_point: Marker2D

func _ready() -> void:
	#position = move_points[starting_point_index].position
	pass

func _process(_delta: float) -> void:
	pass
