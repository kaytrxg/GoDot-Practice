extends CharacterBody2D

const SPEED = 150.0 
var reached_button := false
var is_moving := false

@onready var lullaby_vocals: AudioStreamPlayer2D = $LullabyVocals

func _physics_process(_delta: float) -> void: 
	if reached_button:
		velocity = Vector2.ZERO
		return
		
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		if not is_moving: 
			is_moving = true
			lullaby_vocals.play()
	else: 
		velocity.x = 0.0
	
	velocity.y = 0.0
	move_and_slide()
	
	#Triggers: when character reaches button area
	if global_position.x >= 880: 
		reached_button = true
		velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
