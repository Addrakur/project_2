extends State

@export var player: Player

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	if player.on_moving_plat:
		player.velocity = Vector2(player.velocity.x - player.moving_plat.speed_x, player.velocity.y - player.moving_plat.speed_y)

func exit_state():
	set_physics_process(false)
	player.on_moving_plat = false
	#print("saiu " + name)

func _physics_process(delta: float) -> void:
	#print(name)
	if player.no_gravity:
		player.state_machine.change_state(player.zero_gravity_state)
	
	if not player.is_on_floor():
		player.state_machine.change_state(player.air_state)
	
	if not Input.is_action_pressed("jetpack") and player.fuel < player.max_fuel and not player.rocket_no_recharge:
		player.fuel += player.fuel_restore * delta
	player.move_side_logic(delta,player.side_to_side_force,player.max_running_speed)
	
	if Input.is_action_just_pressed("up") and player.is_on_floor() and player.gravity_mult == 1:
		if player.on_moving_plat:
			if player.moving_plat.coyote_time:
				player.on_moving_plat = false
				player.velocity += player.moving_plat.throw_speed
			else:
				player.velocity.y = player.jump_force
				#player.velocity.x = 0
		else:
			player.velocity.y = player.jump_force
	
	if Input.is_action_just_pressed("down") and player.is_on_ceiling() and player.gravity_mult == -1:
		player.velocity.y = -player.jump_force
