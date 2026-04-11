extends Control

const LETTERS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const TOTAL_LETTERS := 26

var current_letter_index: int = 0 	#tracks the current letter player is on. 
var score: int = 0
var visited_letters: Array[bool] = [] #is an array of 26, true/false, values. 

@onready var current_letter_label: Label = $CenterContainer/VBoxContainer/CurrentLetterLabel
@onready var score_label: Label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var visited_label: Label = $CenterContainer/VBoxContainer/VisitedLabel

func _ready() -> void:
	visited_letters.resize(TOTAL_LETTERS)
	for i in TOTAL_LETTERS:
		visited_letters[i] = false 	#initializes all 26 slots to false at the start, immediately visits A 

	_visit_current_letter()
	_refresh_ui()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if not event.pressed or event.echo:
		return

	var step := 0 # A --> B = 1 step; A --> C = 2 steps
	# refers to the arrow key representing the amount of steps used to get through the alphabet. 
	if event.is_action_pressed("ui_right"):
		step = 1
	elif event.is_action_pressed("ui_up"):
		step = 2
	elif event.is_action_pressed("ui_down"):
		step = -3
	elif event.is_action_pressed("ui_left"):
		step = -1

	if step != 0:
		_move_by(step)
		get_viewport().set_input_as_handled()

func _move_by(step: int) -> void:
	#A wrapping Logic
	var next_index := current_letter_index + step
	current_letter_index = ((next_index % TOTAL_LETTERS) + TOTAL_LETTERS) % TOTAL_LETTERS		# if the player was to press left at A, it would wrap to Z instead  of crashing. 
	_visit_current_letter()
	_refresh_ui()

func _visit_current_letter() -> void:
	if visited_letters[current_letter_index]:
		return #already visited this letter, no points
	#When you land on a letter for the first time, its slots flips to true and the score goes up by 1. 
	visited_letters[current_letter_index] = true
	score += 1

func _refresh_ui() -> void:
	var letter := LETTERS.substr(current_letter_index, 1)
	current_letter_label.text = "Current Letter: %s" % letter
	score_label.text = "Score: %d / %d" % [score, TOTAL_LETTERS]
	visited_label.text = "Visited letters: %d / %d" % [score, TOTAL_LETTERS]
