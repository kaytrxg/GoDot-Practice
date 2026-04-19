extends Node2D

@onready var http_request: HTTPRequest = $HTTPRequest
 
func _log_play() -> void:
	var url := "https://godot-play-api-831129541610.us-east1.run.app/log/twinkle-twinkle"
	var headers = ["Content-Type: application/json", "Content-Length: 2"]
	#http_request.request_completed.connect(_on_request_completed)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, "{}")
	if error != OK:
		print("HTTPRequest failed: ", error)
	

func _ready() -> void:
	# Character and button will be added separately.
	_log_play()
	pass
