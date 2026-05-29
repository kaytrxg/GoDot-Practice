extends Area2D

signal necklace_clicked

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
