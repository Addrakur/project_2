extends Node2D

@export var laser_origin_a: Marker2D
@export var laser_origin_b: Marker2D
@export var laser_time_on: float
@export var laser_cooldown: float
@export var laser_start_delay: float
@export var laser_collision: CollisionPolygon2D
@export var turning_on_speed: float

@onready var laser_timer: Timer = $laser_timer
@onready var laser_cooldown_timer: Timer = $laser_cooldown
@onready var laser_start_delay_timer: Timer = $laser_start_delay_timer
@onready var laser: Line2D = $laser
@onready var animation: AnimationPlayer = $animation

func _ready() -> void:
	if turning_on_speed == 0:
		turning_on_speed = 1
	laser_collision.disabled = true
	laser.points[0] = laser_origin_a.position
	laser.points[1] = laser_origin_b.position
	laser_timer.wait_time = laser_time_on
	laser_cooldown_timer.wait_time = laser_cooldown
	if laser_start_delay != 0:
		laser_start_delay_timer.wait_time = laser_start_delay
		laser_start_delay_timer.start()
	else:
		animation.play("on")
		laser_collision.disabled = false
		laser_timer.start()


func _on_laser_timer_timeout() -> void:
	animation.play("off")
	laser_collision.disabled = true
	laser_cooldown_timer.start()

func _on_laser_cooldown_timeout() -> void:
	animation.play("turning_on",-1,turning_on_speed, false)

func _on_laser_start_delay_timer_timeout() -> void:
	animation.play("on")
	laser_collision.disabled = false
	laser_timer.start()

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "turning_on":
		animation.play("on")
		laser_collision.disabled = false
		laser_timer.start()
