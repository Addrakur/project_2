class_name MovingPlat
extends AnimatableBody2D

@export var throw_speed: Vector2
@export var start_on_touch: bool
@export var animation: AnimationPlayer
@export var animation_on_other_plat: bool
## Seconds without a rider before a touch-activated platform resets.
@export_range(0.0, 60.0, 0.1, "or_greater") var return_delay: float = 5.0
## Duration of the fast trip back along the original path.
@export_range(0.05, 10.0, 0.05, "or_greater") var return_duration: float = 0.5
#@export var player: Player

var coyote_time: bool = false

var speed_x: float
var speed_y: float
var previous_position: Vector2
var _rider: WeakRef
var _return_pending: bool = false
var _return_remaining: float = 0.0
var _returning: bool = false
var _return_elapsed: float = 0.0
var _return_from: float = 0.0

func _ready() -> void:
#	var children = get_children()
#	for child in children:
#		if child is CollisionShape2D:
#			child.one_way_collision = true
	speed_x = 0
	speed_y = 0
	previous_position = global_position
	add_to_group("moving_platforms")

func coyote_time_true():
	coyote_time = true

func play_animation():
	if not is_instance_valid(animation):
		return
	if start_on_touch and _return_pending:
		return
	animation.play("1")
	if start_on_touch and not _return_pending:
		_return_pending = true
		_return_remaining = return_delay

func register_rider(player: CharacterBody2D) -> void:
	_rider = weakref(player)

func _has_rider_on_top() -> bool:
	if _rider == null:
		return false
	var player := _rider.get_ref() as CharacterBody2D
	if not is_instance_valid(player) or not (player.is_on_floor() or player.is_on_ceiling()):
		return false
	var support_normal := Vector2.UP
	if player.get("gravity_mult") != null and float(player.get("gravity_mult")) < 0:
		support_normal = Vector2.DOWN
	for i in range(player.get_slide_collision_count()):
		var contact := player.get_slide_collision(i)
		if contact.get_collider() == self and contact.get_normal().dot(support_normal) > 0.5:
			return true
	return false

func _has_rider_on_shared_animation() -> bool:
	for platform in get_tree().get_nodes_in_group("moving_platforms"):
		if platform is MovingPlat and platform.animation == animation and platform._has_rider_on_top():
			return true
	return false

func reset_platform() -> void:
	_returning = false
	_return_elapsed = 0.0
	_return_pending = false
	_return_remaining = 0.0
	_rider = null
	if is_instance_valid(animation):
		if animation.has_animation("RESET"):
			animation.play("RESET")
			animation.advance(0.0)
		animation.stop(true)
	coyote_time = false
	set_speeds()
	previous_position = global_position

func _start_return() -> void:
	_return_from = animation.current_animation_position
	animation.pause()
	_return_elapsed = 0.0
	_returning = true

func _advance_return(delta: float) -> void:
	_return_elapsed += delta
	var weight := minf(1.0, _return_elapsed / maxf(0.05, return_duration))
	animation.seek(lerpf(_return_from, 0.0, weight), true)
	if weight >= 1.0:
		reset_platform()

func set_speeds():
	speed_x = 0
	speed_y = 0

func _physics_process(delta: float) -> void:
	if start_on_touch and _return_pending and is_instance_valid(animation):
		if _has_rider_on_shared_animation():
			if _returning:
				_returning = false
				animation.play("1")
			_return_remaining = return_delay
		elif _returning:
			_advance_return(delta)
		else:
			_return_remaining -= delta
			if _return_remaining <= 0.0:
				_start_return()
	if animation_on_other_plat:
		return
	if not animation.is_playing() and not _returning:
		set_speeds()
		previous_position = global_position
		return
	speed_x = (global_position.x - previous_position.x) / delta
	speed_y = (global_position.y - previous_position.y) / delta
	previous_position = global_position
	#print("Speed X: " + str(speed_x))
	#print("Speed Y: " + str(speed_y))
