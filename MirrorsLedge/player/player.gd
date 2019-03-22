# Player script. Handles player input and movement.

extends KinematicBody2D

const GRAVITY = 500
const JUMP_FORCE = -300

var move_dir = Vector2()
var move_speed = 200
var air_velocity = 0
var double_jump = false
var wall_jump = false


func _physics_process(delta):
	move_dir.y += GRAVITY * delta
	
	# Horizontal movement
	if Input.is_action_pressed("move_right"):
		move_dir.x = move_speed
	elif Input.is_action_pressed("move_left"):
		move_dir.x = -move_speed
	else:
		move_dir.x = 0
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			move_dir.y = JUMP_FORCE
			double_jump = true		# Can double jump
			wall_jump 	= true		# Can wall jump
		
		# Double jump (can dbl jump when in air, not touching wall, not wall jumping)
		if double_jump and not is_on_floor() and not is_on_wall():
			move_dir.y = JUMP_FORCE
			double_jump = false
		
#		# Wall jump
#		if wall_jump and is_on_wall() and not is_on_floor():
#			move_dir.y = JUMP_FORCE
#			wall_jump = false
	
	
	move_and_slide(move_dir, Vector2(0, -1))