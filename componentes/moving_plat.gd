class_name MovingPlat
extends AnimatableBody2D

@export var throw_speed: Vector2
@export var start_on_touch: bool
@export var animation: AnimationPlayer
@export var animation_on_other_plat: bool
#@export var player: Player

var coyote_time: bool = false

var speed_x: float
var speed_y: float
var previous_position: Vector2

func _ready() -> void:
#	var children = get_children()
#	for child in children:
#		if child is CollisionShape2D:
#			child.one_way_collision = true
	speed_x = 0
	speed_y = 0

func coyote_time_true():
	coyote_time = true

func coyote_time_false():
	coyote_time = false

func play_animation():
	animation.play("1")

func set_speeds():
	speed_x = 0
	speed_y = 0

func _physics_process(delta: float) -> void:
	if animation_on_other_plat:
		return
	if not animation.is_playing():
		return
	speed_x = (global_position.x - previous_position.x) / delta
	speed_y = (global_position.y - previous_position.y) / delta
	previous_position = global_position
	#print("Speed X: " + str(speed_x))
	#print("Speed Y: " + str(speed_y))
