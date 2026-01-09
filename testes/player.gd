class_name Player
extends CharacterBody2D

@export var screen_manager: ScreenManager

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

var rocket_active: bool = true
var rocket_force: float
var rocket_velocity_x: float
var side_force: float
var side_velocity: float
var fuel
var gravity_mult: float = 1
var gravity: float

var mouse_control: bool = true

@export var progress_bar: ProgressBar
@onready var texture: Node2D = $texture

func _ready() -> void:
	fuel = max_fuel
	progress_bar.max_value = max_fuel

func _physics_process(delta: float) -> void:
	#Gravidade que afeta o jogador
	if not Input.is_action_pressed("jetpack") and not is_on_floor():
		velocity.y += gravity * delta * gravity_mult
	else:
		velocity.y += gravity * delta * gravity_mult * 0.5
	if not Input.is_action_pressed("jetpack") and fuel > 0:
		if is_on_floor() and not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
			velocity.x = move_toward(velocity.x,0,floor_delta_towards_zero)
		else:
			velocity.x = move_toward(velocity.x,0,air_delta_towards_zero)
		
	move_side_logic(delta)
	velocity.x += side_velocity + rocket_velocity_x
	
	rocket_logic(delta)
	
	if Input.is_action_just_pressed("up") and is_on_floor() and gravity_mult == 1:
		velocity.y = jump_force
	
	if Input.is_action_just_pressed("down") and is_on_ceiling() and gravity_mult == -1:
		velocity.y = -jump_force
	
	if not Input.is_action_pressed("jetpack") and fuel < max_fuel:
		if is_on_floor():
			fuel += fuel_restore * delta
		else:
			fuel += fuel_restore * delta / 4
	
	move_and_slide()
	
	progress_bar.value = fuel
	
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider is FragileGround:
			collider.animation.play("break")
		elif collider.name == "kill_tileset":
			position = screen_manager.current_checkpoint.position
			fuel = max_fuel

func rocket_logic(delta: float):
	if mouse_control:
		texture.look_at(get_global_mouse_position())
		texture.rotation_degrees = fposmod(texture.rotation_degrees, 360.0)
		if Input.is_action_pressed("jetpack") and fuel > 0 and rocket_active:
			fuel -= fuel_consume
			if rocket_force < rocket_max_force:
				rocket_force += rocket_force_up
		elif rocket_force > 0:
			rocket_force -= rocket_force_down
		if rocket_force < 0:
			rocket_force = 0
		
		rocket_velocity_x = rocket_speed * rocket_force * delta * cos(deg_to_rad(texture.rotation_degrees))
		velocity.y += rocket_speed * rocket_force * delta * sin(deg_to_rad(texture.rotation_degrees))
	else:
		var horizontal_direction = Input.get_axis("right","left")
		var vertical_direction = Input.get_axis("down","up")
		if horizontal_direction == 0 and vertical_direction == 0:
			vertical_direction = 1
		set_texture_rotation(horizontal_direction,vertical_direction)
		if Input.is_action_pressed("jetpack") and fuel > 0 and rocket_active:
			fuel -= fuel_consume
			if rocket_force < rocket_max_force:
				rocket_force += rocket_force_up
		elif rocket_force > 0:
			rocket_force -= rocket_force_down
		if rocket_force < 0:
			rocket_force = 0
		
		rocket_velocity_x = rocket_speed * rocket_force * delta * horizontal_direction
		velocity.y += rocket_speed * rocket_force * delta * vertical_direction

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

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn")

func set_texture_rotation(x: float, y:float):
	if x == 1:
		if y == 1:
			texture.rotation_degrees = 45
		elif y == 0:
			texture.rotation_degrees = 0
		elif y == -1:
			texture.rotation_degrees = -45
	elif x == 0:
		if y == 1:
			texture.rotation_degrees = 90
		elif y == 0:
			texture.rotation_degrees = 90
		elif y == -1:
			texture.rotation_degrees = 270
	elif x == -1:
		if y == 1:
			texture.rotation_degrees = 135
		elif y == 0:
			texture.rotation_degrees = 180
		elif y == -1:
			texture.rotation_degrees = 225
