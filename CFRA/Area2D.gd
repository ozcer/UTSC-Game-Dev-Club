extends KinematicBody2D

signal playerJump
signal pauseGame

var ground_level:float = 412
var initial_gravity:float = 100
var curr_gravity:float = initial_gravity
var initial_lift:float = 15
var lift:float = 1

var velocity = Vector2()

var state

var phaseFive = false
var devMode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state("jump")

func change_state(n_state):
	if n_state == "run":
		get_node("Jump").visible = false
		get_node("Run").visible = true
		get_node("Rise").visible = false
		get_node("AnimationPlayer").play("Run")
		get_node("JumpHurtbox").collision_layer = 2
		get_node("RunHurtbox").collision_layer = 1
		get_node("JumpHurtbox").collision_mask = 2
		get_node("RunHurtbox").collision_mask = 1
		get_node("Footstep").volume_db = -15
	elif n_state == "jump":
		get_node("Jump").visible = true
		get_node("Run").visible = false
		get_node("Rise").visible = false
		get_node("JumpTimer").start()
		get_node("RunHurtbox").collision_layer = 2
		get_node("JumpHurtbox").collision_layer = 1
		get_node("RunHurtbox").collision_mask = 2
		get_node("JumpHurtbox").collision_mask = 1
		get_node("Footstep").volume_db = -80
		emit_signal("playerJump")
	elif n_state == "rise":
		get_node("Jump").visible = false
		get_node("Run").visible = false
		get_node("Rise").visible = true
	state = n_state

func _process(delta):
	if state == "run":
		if Input.is_action_just_pressed("Jump"):
			velocity.y -= initial_lift
			change_state("jump")
	else:
		velocity.y += curr_gravity * delta
		curr_gravity -= 125 * delta
		if state == "jump":
			if Input.is_action_just_released("Jump"):
				change_state("rise")
			else:
				velocity.y -= lift

	var floor_collision = move_and_collide(velocity)

	if floor_collision:
		global_position.y = ground_level
		curr_gravity = initial_gravity
		velocity = Vector2()
		change_state("run")

	get_node("Run/SpeedTrail").process_material.hue_variation += 0.005
	if get_node("Run/SpeedTrail").process_material.hue_variation == 1:
		get_node("Run/SpeedTrail").process_material.hue_variation = 0

func _on_JumpTimer_timeout():
	change_state("rise")

func _on_player_area_entered(area):
	if area.get_name() == "Boost":
		get_node("Run/Boost").visible = true
	elif not(phaseFive) and not(devMode):
		emit_signal("pauseGame")

func _on_player_area_exited(area):
	if area.get_name() == "Boost":
		get_node("Run/Boost").visible = false

func _on_devMode():
	devMode = not(devMode)

func _on_newPhase(num):
	if num >= 3:
		get_node("Run/Sparks").visible = true
	else:
		get_node("Run/Sparks").visible = false
	if num >= 4:
		get_node("Run").frames.get_frame("default", 0).fps = 24
		get_node("Footstep").pitch_scale = 3.2
	else:
		get_node("Run").frames.get_frame("default", 0).fps = 12
		get_node("Footstep").pitch_scale = 1.6
	if num >= 5:
		phaseFive = true
		get_node("Run/SpeedTrail").visible = true
		get_node("Jump/SpeedTrail").visible = true
		get_node("Rise/SpeedTrail").visible = true
	else:
		phaseFive = false
		get_node("Run/SpeedTrail").visible = false
		get_node("Jump/SpeedTrail").visible = false
		get_node("Rise/SpeedTrail").visible = false