class_name Player
extends CharacterBody2D

@export var screen_manager: ScreenManager

@export_group("Player move")
@export var max_side_force: float
@export var side_to_side_force: float 
@export var air_side_to_side_force: float
@export var no_gravity_directional_force: float
@export var floor_delta_towards_zero: float
@export var air_delta_towards_zero: float
@export var speed: float
@export var max_running_speed: float
@export var jump_force: float
@export var max_x_velocity: float
@export var max_speed_zero_gravity: float
@export_group("Rocket")
@export var max_fuel: float
@export var fuel_consume: float
@export var fuel_restore: float
@export var fuel_air_restore: float
@export var fuel_zero_gravity_restore: float
@export var rocket_speed: float
@export var rocket_max_force: float
@export var rocket_force_up: float
@export var rocket_force_down: float
@export var rocket_max_speed: float
@export var less_gravity_limit: float

var rocket_active: bool = true
var rocket_force: float
var rocket_velocity_x: float
var rocket_velocity_y: float
var side_force: float
var side_velocity: float
var up_down_force: float
var up_down_velocity: float
var fuel: float
var gravity_mult: float = 1
var gravity: float
var no_gravity: bool = false
var rocket_no_recharge: bool = false

var on_moving_plat: bool = false
var moving_plat: AnimatableBody2D

@export var progress_bar: ProgressBar
@onready var texture: Node2D = $texture
@onready var texture_image: Sprite2D = $texture/texture
@onready var player_sprite: Sprite2D = $player_sprite
@onready var animations: AnimationPlayer = $animations

@onready var state_machine: StateMachine = $StateMachine
@onready var ground_state: Node = $StateMachine/ground_state
@onready var air_state: Node = $StateMachine/air_state
@onready var zero_gravity_state: Node = $StateMachine/zero_gravity_state

func _ready() -> void:
	fuel = max_fuel
	progress_bar.max_value = max_fuel

func _physics_process(delta: float) -> void:
	
	#Codigo que verifica qual vai ser a velocidade no eixo Y
	if no_gravity:
		velocity.y += rocket_velocity_y
	elif gravity_mult > 0:
		if Input.is_action_pressed("jetpack") and fuel > 0 and sin(deg_to_rad(texture.rotation_degrees)) > 0:
			if velocity.y > less_gravity_limit:
				velocity.y += rocket_velocity_y
			else:
				velocity.y +=  gravity * delta * gravity_mult * 0.3 + rocket_velocity_y
		else:
			velocity.y += gravity * delta * gravity_mult + rocket_velocity_y
	else:
		if Input.is_action_pressed("jetpack") and fuel > 0 and sin(deg_to_rad(texture.rotation_degrees)) < 0:
			if velocity.y < -less_gravity_limit:
				velocity.y += rocket_velocity_y
			else:
				velocity.y +=  gravity * delta * gravity_mult * 0.3 + rocket_velocity_y
		else:
			velocity.y += gravity * delta * gravity_mult + rocket_velocity_y
	
	#Faz a velocidade do jogador no chao ir para zero caso ele pare de apertar os direcionais
	if not Input.is_action_pressed("jetpack") and not no_gravity:
		if on_floor_or_ceiling() and not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
			velocity.x = move_toward(velocity.x,0,floor_delta_towards_zero)
		else:
			velocity.x = move_toward(velocity.x,0,air_delta_towards_zero)
	 
	#Faz o jogador andar para os lados
	velocity.x += side_velocity + rocket_velocity_x
	rocket_logic(delta)
	
	#Faz o foguete sempre voltar para a velocidade maxima no eixo X
	if velocity.x > max_x_velocity:
		velocity.x = move_toward(velocity.x, max_x_velocity, floor_delta_towards_zero/2)
	elif velocity.x < -max_x_velocity:
		velocity.x = move_toward(velocity.x, -max_x_velocity, floor_delta_towards_zero/2)
	
	#Faz o foguete sempre voltar para a velocidade maxima no eixo Y
	if velocity.y < -rocket_max_speed:
		velocity.y = move_toward(velocity.y, -rocket_max_speed, air_delta_towards_zero)
	
	#Gira o sprite para a direção do input
	if Input.is_action_just_pressed("right"):
		player_sprite.flip_h = false
	if Input.is_action_just_pressed("left"):
		player_sprite.flip_h = true
	
	#Representação visual do combustível
	progress_bar.value = fuel
	
	#Faz o foguete girar com o mouse
	texture.look_at(get_global_mouse_position())
	texture.rotation_degrees = fposmod(texture.rotation_degrees, 360.0)
	
	for i in range(get_slide_collision_count()):
		var collider = get_slide_collision(i).get_collider()
		if collider is FragileGround:
			collider.animation.play("break")
		elif collider.name == "kill_tileset":
			screen_manager.player_die()
		elif collider is MovingPlat:
			on_moving_plat = true
			moving_plat = collider
			if collider.start_on_touch:
				collider.play_animation()
		else:
			on_moving_plat = false
			moving_plat = null
	
	set_animation()
	
	move_and_slide()

func rocket_logic(delta: float):
	if Input.is_action_pressed("jetpack") and fuel > 0 and rocket_active:
		if no_gravity:
			fuel -= fuel_consume
		elif not on_floor_or_ceiling():
			fuel -= fuel_consume
		
		if rocket_force < rocket_max_force:
			rocket_force += rocket_force_up
	elif rocket_force > 0:
		rocket_force -= rocket_force_down
	if rocket_force < 0:
		rocket_force = 0
		
	rocket_velocity_x = rocket_speed * rocket_force * delta * cos(deg_to_rad(texture.rotation_degrees))
		
	rocket_velocity_y = rocket_speed * rocket_force * delta * sin(deg_to_rad(texture.rotation_degrees))
	
	
	#Codigo que faz sempre o mesmo lado do foguete estar para cima
	#if cos(deg_to_rad(texture.rotation_degrees)) < 0:
		#texture_image.flip_v = true
	#else:
		#texture_image.flip_v = false
		

func move_side_logic(delta: float, side_to_side_current_force: float, current_max_running_speed: float):
	if Input.is_action_pressed("right"):
		if side_force < max_side_force:
			side_force += side_to_side_current_force
	elif Input.is_action_pressed("left"):
		if side_force > -max_side_force:
			side_force -= side_to_side_current_force
	else:
		side_force = move_toward(side_force, 0, floor_delta_towards_zero)
	
	if velocity.x > current_max_running_speed and Input.is_action_pressed("right") or velocity.x < -current_max_running_speed and Input.is_action_pressed("left"):
		side_velocity = 0
	else:
		side_velocity = side_force * speed * delta

func move_up_down_logic(delta: float, up_down_current_force: float, current_max_running_speed: float):
	if Input.is_action_pressed("down"):
		if up_down_force < max_side_force:
			up_down_force += up_down_current_force
	elif Input.is_action_pressed("up"):
		if up_down_force > -max_side_force:
				up_down_force -= up_down_current_force
	else:
		up_down_force = move_toward(up_down_force, 0, floor_delta_towards_zero)
	
	if velocity.y > current_max_running_speed and Input.is_action_pressed("down") or velocity.y < -current_max_running_speed and Input.is_action_pressed("up"):
		up_down_velocity = 0
	else:
		up_down_velocity = up_down_force * speed * delta

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn")

func set_animation():
	if gravity_mult < 0:
		player_sprite.flip_v = true
	else:
		player_sprite.flip_v = false
	
	if on_floor_or_ceiling():
		if velocity.x != 0:
			animations.play("walk")
		else:
			animations.play("idle")
	else:
		animations.play("idle")
	
func on_floor_or_ceiling() -> bool:
	if no_gravity:
		return false
	else:
		if gravity_mult > 0 and is_on_floor() or gravity_mult < 0 and is_on_ceiling():
			return true
		else:
			return false
