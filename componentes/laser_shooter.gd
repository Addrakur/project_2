extends Node2D

@export var laser_origin_a: Marker2D
@export var laser_origin_b: Marker2D
@export var laser_time_on: float
@export var laser_cooldown: float
@export var laser_start_delay: float
@export var laser_collision: CollisionPolygon2D

@onready var laser_timer: Timer = $laser_timer
@onready var laser_cooldown_timer: Timer = $laser_cooldown
@onready var laser_start_delay_timer: Timer = $laser_start_delay_timer
@onready var laser: Line2D = $laser

func _ready() -> void:
	laser_collision.disabled = true
	laser.points[0] = laser_origin_a.position
	laser.points[1] = laser_origin_b.position
	laser_timer.wait_time = laser_time_on
	laser_cooldown_timer.wait_time = laser_cooldown
	if laser_start_delay != 0:
		laser_start_delay_timer.wait_time = laser_start_delay
		laser_start_delay_timer.start()
	else:
		laser.visible = true
		laser_collision.disabled = false
		laser_timer.start()


func _on_laser_timer_timeout() -> void:
	laser.visible = false
	laser_collision.disabled = true
	laser_cooldown_timer.start()

func _on_laser_cooldown_timeout() -> void:
	laser.visible = true
	laser_collision.disabled = false
	laser_timer.start()

func _on_laser_start_delay_timer_timeout() -> void:
	laser.visible = true
	laser_collision.disabled = false
	laser_timer.start()
