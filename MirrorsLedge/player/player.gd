extends KinematicBody2D

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 500.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 300
const JUMP_MAX_AIRBORNE_TIME = 1.0

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false
var air_jumping = false


func _physics_process(delta):
	# Create force/move direction
	var force = Vector2(0, GRAVITY)
	
	# Player inputs
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	# Player stopped giving horizontal movement inputs.
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	# Start to slow down velocity
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Get player velocity from movement direction * frame delta
	velocity += force * delta	
	# Move player's velocity with vector normal pointing towards ceiling (0, -1)
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	# Reset player air time
	if is_on_floor():
		on_air_time = 0
	
	# When the player starts to fall, reset jumping flags
	if jumping and velocity.y > 0:
		jumping = false
		air_jumping = false
	
	# Player is jumping
	if jump:
		# Single jump
		if on_air_time < JUMP_MAX_AIRBORNE_TIME and not jumping and not air_jumping:
			# Jump must also be allowed to happen if the character left the floor a litle bit ago.
			# Makes the controls more snappy.
			velocity.y = -JUMP_SPEED
			jumping = true
		# Air jump/double jumping
		elif jumping and not air_jumping:
			velocity.y = -JUMP_SPEED
			air_jumping = true 
	
	on_air_time += delta