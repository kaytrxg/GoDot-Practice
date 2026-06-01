extends Area2D

signal necklace_clicked

var _press_position := Vector2.ZERO
const CLICK_THRESHOLD := 10.0

func _ready() -> void:
	print("necklace ready")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		if event.pressed:
			_press_position = mouse_pos
			print("pressed at: ", mouse_pos)
			print("necklace global pos: ", global_position)
		else:
			var travel = _press_position.distance_to(mouse_pos)
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = _press_position
			query.collide_with_areas = true
			query.collide_with_bodies = false
			var results = space_state.intersect_point(query)
			print("travel: ", travel, " hits: ", results.size())
			for result in results:
				if result["collider"] == self and travel < CLICK_THRESHOLD:
					emit_signal("necklace_clicked")
					print("necklace clicked!")


'''
Older Version: 
	--> input_event was unreliable, input_pickable true; using the mouse event
		before touching the Necklace Node. A forcus click; game window 
		needed one click to focus before any input registered.  

var _can_click := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("necklace script ready")
	input_pickable = true
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if _can_click:
			_can_click = false
			emit_signal("necklace_clicked")
			print("necklace_clicked")
			await get_tree().create_timer(0.3).timeout
			_can_click = true
		else:
			print("released at: ", event.position)
'''
