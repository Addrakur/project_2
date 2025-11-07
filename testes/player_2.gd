extends CharacterBody2D

@export_group("Player move")
@export var max_side_force: float
@export var side_to_side_force: float
@export var delta_towards_zero: float
@export var speed: float
@export var max_running_speed: float
@export var jump_force: float
@export_group("Jetpack")
@export var max_fuel: float
@export var fuel_consume: float
@export var jetpack_speed: float
@export var jetpack_max_force: float
@export var jetpack_force_up: float
@export var jetpack_force_down: float

var jetpack_force: float
var rocket_velocity_x: float
var side_force: float
var side_velocity: float
var fuel

@export var progress_bar: ProgressBar
@onready var texture: Node2D = $texture

func _ready() -> void:
	fuel = max_fuel
	progress_bar.max_value = max_fuel

func _physics_process(delta: float) -> void:
	#Gravidade que afeta o jogador
	velocity += get_gravity() * delta
	velocity.x = move_toward(velocity.x,0,delta_towards_zero)
	
	move_side_logic(delta)
	velocity.x += side_velocity + rocket_velocity_x
	
	rocket_logic(delta)
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_force
	
	if is_on_floor():
		fuel = max_fuel
	
	move_and_slide()
	
	progress_bar.value = fuel
	

func rocket_logic(delta: float):
	texture.look_at(get_global_mouse_position())
	texture.rotation_degrees = fposmod(texture.rotation_degrees, 360.0)
	if Input.is_action_pressed("jetpack") and fuel > 0:
		fuel -= fuel_consume
		if jetpack_force < jetpack_max_force:
			jetpack_force += jetpack_force_up
	elif jetpack_force > 0:
		jetpack_force -= jetpack_force_down
	if jetpack_force < 0:
		jetpack_force = 0
	
	rocket_velocity_x = jetpack_speed * jetpack_force * delta * cos(deg_to_rad(texture.rotation_degrees))
	velocity.y += jetpack_speed * jetpack_force * delta * sin(deg_to_rad(texture.rotation_degrees))

func move_side_logic(delta: float):
	if Input.is_action_pressed("right"):
		if side_force < max_side_force:
			side_force += side_to_side_force
	elif Input.is_action_pressed("left"):
		if side_force > -max_side_force:
			side_force -= side_to_side_force
	else:
		side_force = move_toward(side_force, 0, delta_towards_zero)
	
	if velocity.x < max_running_speed and velocity.x > -max_running_speed:
		side_velocity = side_force * speed * delta
	else:
		side_velocity = 0
