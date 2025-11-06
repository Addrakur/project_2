extends CharacterBody2D

@export var speed: float
@export var jump_force: float
@export var max_fuel: float
@export var fuel_consume: float
@export var jetpack_speed: float
@export var jetpack_max_force: float
@export var jetpack_force_up: float
@export var jetpack_force_down: float
@export var max_side_force: float
@export var side_to_side_force: float
@export var delta_towards_zero: float

var jetpack_force: float
var side_force: float
var fuel

@onready var progress_bar: ProgressBar = $"../CanvasLayer/Control/ProgressBar"


func _ready() -> void:
	fuel = max_fuel
	progress_bar.max_value = max_fuel

func _physics_process(delta: float) -> void:
	#Gravidade que afeta o jogador
	velocity += get_gravity() * delta
	
	move_side_logic(delta)
	jetpack_logic(delta)
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = jump_force
	
	if is_on_floor():
		fuel = max_fuel
	
	move_and_slide()
	
	progress_bar.value = fuel

func jetpack_logic(delta: float):
	if Input.is_action_pressed("jetpack") and fuel > 0:
		fuel -= fuel_consume
		if jetpack_force < jetpack_max_force:
			jetpack_force += jetpack_force_up
	elif jetpack_force > 0:
		jetpack_force -= jetpack_force_down
	
	velocity.y += jetpack_force * jetpack_speed * delta

func move_side_logic(delta: float):
	if Input.is_action_pressed("right"):
		if side_force < max_side_force:
			side_force += side_to_side_force
	elif Input.is_action_pressed("left"):
		if side_force > -max_side_force:
			side_force -= side_to_side_force
	else:
		side_force = move_toward(side_force, 0, delta_towards_zero)
	
	velocity.x = side_force * speed * delta
