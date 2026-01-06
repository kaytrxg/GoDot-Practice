extends CharacterBody2D

# Variables - storing values we'll use
var speed = 200.0  # How fast the character moves (pixels per second)
var jump_velocity = -400.0 #Negative b/c up is negative in GoDot
var gravity = 980.0 #standard gravity (pixels per second squared)

# _ready() runs once when the node enters the scene
func _ready():
	#position = get_viewport_rect().size/2
	#^^^ this would be the manual input for the icon being set to the middle of the screen 
	print("Character is ready!")

# _physics_process() runs every physics frame (60 times per second by default)
func _physics_process(delta):
	# Get input direction (-1, 0, or 1 for each axis)
	#var direction = Vector2.ZERO #orignal for simple up, down, left, right
	
	#Apply gravity if not of the floor
	if not is_on_floor():
		velocity.y += gravity * delta 
	#Handles jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	'''
	# Check for input and set direction: Simple up, down, left, right
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	'''
	#Get a horizontal input direction
	var direction = 0.0
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	'''
	# Normalize diagonal movement so it's not faster: Simple up, down, left, right
	if direction.length() > 0:
		direction = direction.normalized()
	'''
	# Set the velocity
	velocity.x = direction * speed
	
	# Move the character (built-in function)
	move_and_slide()
	
	#Checks is we landed on a bouncy platform
	if is_on_floor(): 
		for i in get_slide_collision_count(): 
			var collision = get_slide_collision(i)
			if collision.get_collider().is_in_group("bouncy"):
				velocity.y = jump_velocity * 2.5 #Bounces higher
				
