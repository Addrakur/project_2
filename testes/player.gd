class_name Player
extends CharacterBody2D

@export_group("Player move")
@export var max_side_force: float
@export var side_to_side_force: float 
@export var air_side_to_side_force: float
@export var floor_delta_towards_zero: float
@export var air_delta_towards_zero: float
@export var speed: float
@export var max_running_speed: float
@export var jump_force: float
@export_group("Rocket")
@export var max_fuel: float
@export var fuel_consume: float
@export var fuel_restore: float
@export var rocket_speed: float
@export var rocket_max_force: float
@export var rocket_force_up: float
@export var rocket_force_down: float

var rocket_force: float
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
	if is_on_floor():
		velocity.x = move_toward(velocity.x,0,floor_delta_towards_zero)
	else:
		velocity.x = move_toward(velocity.x,0,air_delta_towards_zero)
	
	move_side_logic(delta)
	velocity.x += side_velocity + rocket_velocity_x
	
	rocket_logic(delta)
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_force
	
	if is_on_floor() and fuel < max_fuel:
		fuel += fuel_restore * delta
	
	move_and_slide()
	
	progress_bar.value = fuel
	

func rocket_logic(delta: float):
	texture.look_at(get_global_mouse_position())
	texture.rotation_degrees = fposmod(texture.rotation_degrees, 360.0)
	if Input.is_action_pressed("jetpack") and fuel > 0:
		fuel -= fuel_consume
		if rocket_force < rocket_max_force:
			rocket_force += rocket_force_up
	elif rocket_force > 0:
		rocket_force -= rocket_force_down
	if rocket_force < 0:
		rocket_force = 0
	
	rocket_velocity_x = rocket_speed * rocket_force * delta * cos(deg_to_rad(texture.rotation_degrees))
	velocity.y += rocket_speed * rocket_force * delta * sin(deg_to_rad(texture.rotation_degrees))

func move_side_logic(delta: float):
	if Input.is_action_pressed("right"):
		if side_force < max_side_force:
			if is_on_floor():
				side_force += side_to_side_force
			else:
				side_force += air_side_to_side_force
	elif Input.is_action_pressed("left"):
		if side_force > -max_side_force:
			if is_on_floor():
				side_force -= side_to_side_force
			else:
				side_force -= air_side_to_side_force
	else:
		side_force = move_toward(side_force, 0, floor_delta_towards_zero)
	
	if velocity.x < max_running_speed and velocity.x > -max_running_speed:
		side_velocity = side_force * speed * delta
	else:
		side_velocity = 0
