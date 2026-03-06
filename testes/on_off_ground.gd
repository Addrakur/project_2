extends StaticBody2D

@export var on_time: float
@export var off_time: float
@export var delay_time: float
@export var start_off: bool

@onready var on_timer: Timer = $on_timer
@onready var off_timer: Timer = $off_timer
@onready var delay_timer: Timer = $delay_timer
@onready var animation: AnimationPlayer = $animation

func _ready() -> void:
	on_timer.wait_time = on_time
	off_timer.wait_time = off_time
	delay_timer.wait_time = delay_time 
	if delay_time > 0:
		delay_timer.start()
	else:
		if start_off:
			animation.play("off")
			off_timer.start()
		else:
			animation.play("on")
			on_timer.start()
	

func _on_on_timer_timeout() -> void:
	animation.play("off")
	off_timer.start()

func _on_off_timer_timeout() -> void:
	animation.play("on")
	on_timer.start()

func _on_delay_timer_timeout() -> void:
	if start_off:
		animation.play("off")
		off_timer.start()
	else:
		animation.play("on")
		on_timer.start()
		
