extends Control

const ALPHABET := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

@onready var target_label: Label = $TargetLabel
@onready var score_label: Label = $ScoreLabel
@onready var combo_label: Label = $ComboLabel
@onready var player: ColorRect = $Player

var rng := RandomNumberGenerator.new()
var spawn_cooldown := 0.65 #wait time between letter spawns
var spawn_timer := 0.0 	#Timer gets reset back to spawn_cooldown
var letter_speed_min := 130.0
var letter_speed_max := 240.0
var player_speed := 460.0

var score := 0
var combo := 0
var target_word := "WARP" 	#tracks where you are spelling the targetted word
var target_index := 0	#if W and A are caught; target_index would be 2 --> next letter is R
var active_letters: Array[ColorRect] = []

func _ready() -> void:
	rng.randomize()
	_position_player()
	_update_ui()

func _process(delta: float) -> void: 	#this would be the GAME LOOP
	_move_player(delta) 	# reads the arrow key inpus, slides the catcher too
	_spawn_letters(delta) 	#counts down the timer and drops a new letter when it hits ZERP
	_update_letters(delta) 	#moves every active letter down, checks for collsions

func _position_player() -> void:
	var viewport_size := get_viewport_rect().size #The size of the game window, centers the player/catcher at the bottom of the screen
	player.position = Vector2(
		(viewport_size.x - player.size.x) * 0.5,
		viewport_size.y - 88.0
	)

func _move_player(delta: float) -> void:
	var direction := 0.0
	if Input.is_action_pressed("ui_left"):
		direction -= 1.0
	if Input.is_action_pressed("ui_right"):
		direction += 1.0
	if direction == 0.0:
		return

	player.position.x += direction * player_speed * delta
	var viewport_width := get_viewport_rect().size.x
	player.position.x = clamp(player.position.x, 16.0, viewport_width - player.size.x - 16.0)

func _spawn_letters(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer > 0.0:
		return

	spawn_timer = spawn_cooldown
	var next_target := target_word.substr(target_index, 1)
	
	#telling there's a 45% chance the falling letter is the one needed
	var should_spawn_target := rng.randf() < 0.45 
	var letter_char := next_target if should_spawn_target else ALPHABET.substr(rng.randi_range(0, ALPHABET.length() - 1), 1) # A spawning Logic

	var letter := _create_letter(letter_char)
	add_child(letter)
	active_letters.append(letter)

func _create_letter(letter_char: String) -> ColorRect:
	var letter := ColorRect.new()
	letter.name = "Letter_%s_%d" % [letter_char, Time.get_ticks_msec()]
	letter.color = Color(0.10, 0.11, 0.21, 0.9)
	letter.custom_minimum_size = Vector2(42, 42)
	letter.size = Vector2(42, 42)
	letter.set_meta("char", letter_char)
	letter.set_meta("speed", rng.randf_range(letter_speed_min, letter_speed_max))

	var viewport_size := get_viewport_rect().size #use the width value to randomly place letters anywhere across the top without spawning off-screen
	letter.position = Vector2(
		rng.randf_range(16.0, viewport_size.x - letter.size.x - 16.0),
		-48.0
	)

	var glyph := Label.new()
	glyph.text = letter_char
	glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	glyph.set_anchors_preset(Control.PRESET_FULL_RECT)
	letter.add_child(glyph)
	return letter

func _update_letters(delta: float) -> void:
	var viewport_size := get_viewport_rect().size 	# uses the height to know when a letter has fallen past the bottom
	var player_rect := Rect2(player.position, player.size) 	#Collision Detection
	var letters_to_remove: Array[ColorRect] = []

	for letter in active_letters:
		letter.position.y += float(letter.get_meta("speed")) * delta
		var letter_rect := Rect2(letter.position, letter.size) 	#Collision Detection

		if player_rect.intersects(letter_rect):	#Refers to checking if two rectangles are overlapped --> Rect2.intersects(). 
			_handle_catch(letter)
			letters_to_remove.append(letter)
			continue

		if letter.position.y > viewport_size.y + 20.0:
			combo = 0
			_update_ui()
			letters_to_remove.append(letter)

	for letter in letters_to_remove:
		active_letters.erase(letter)
		letter.queue_free()

func _handle_catch(letter: ColorRect) -> void:
	var caught_char: String = str(letter.get_meta("char"))
	var expected_char := target_word.substr(target_index, 1)

	if caught_char == expected_char:
		combo += 1
		score += 10 + combo * 2
		target_index = (target_index + 1) % target_word.length() 	 # Right letter = score grows faster the longer the combo runs (in order)
	else:
		combo = 0
		score = max(score - 5, 0) #Wrong letter = combo resets, lost 5 points (never below zero)

	_update_ui()

func _update_ui() -> void:
	var next_char := target_word.substr(target_index, 1)
	target_label.text = "Target: %s   Next: %s" % [target_word, next_char]
	score_label.text = "Score: %d" % score
	combo_label.text = "Combo: x%d" % combo
	
	'''
	NOTES: 
		Letters are built entirelyt out of the ColorReact nodes with the PlayerLabel as a child within. 
		No sprites, no textures, 
	'''
