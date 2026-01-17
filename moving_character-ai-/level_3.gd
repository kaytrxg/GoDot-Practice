extends Node2D

func _ready():
	print("Level 3 script is loaded!")

func _on_fallzone_body_entered(body: Node2D):
	#Checks if player reaches new level
	if body.is_in_group("player"):
		print("Character fell off! Loading final level")
		get_tree().change_scene_to_file("res://closing_level.tscn")
