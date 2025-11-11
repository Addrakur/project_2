extends StaticBody2D

@export var on_time: float
@export var off_time: float

@onready var on_timer: Timer = $on_timer
@onready var off_timer: Timer = $off_timer
@onready var animation: AnimationPlayer = $animation

var player_inside_area: bool = false
var off_timer_finish: bool = false

func _ready() -> void:
	on_timer.wait_time = on_time
	off_timer.wait_time = off_time
	on_timer.start()

func _process(_delta: float) -> void:
	if not player_inside_area and off_timer_finish:
		off_timer_finish = false
		animation.play("on")
		on_timer.start()

func _on_on_timer_timeout() -> void:
	animation.play("off")
	off_timer.start()

func _on_off_timer_timeout() -> void:
	off_timer_finish = true

func _on_player_inside_body_entered(_body: Node2D) -> void:
	player_inside_area = true

func _on_player_inside_body_exited(_body: Node2D) -> void:
	player_inside_area = false
