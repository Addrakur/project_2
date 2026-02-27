class_name MovingPlat
extends AnimatableBody2D

@export var throw_speed: Vector2
@export var start_on_touch: bool
@export var animation: AnimationPlayer
#@export var player: Player

var coyote_time: bool = false

func _on_coyote_time_timeout() -> void:
	coyote_time = false

func coyote_time_true():
	coyote_time = true
	$coyote_time.start()

func play_animation():
	animation.play("1")
