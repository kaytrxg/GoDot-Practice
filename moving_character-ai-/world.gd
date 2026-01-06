extends Node2D



func _on_fall_zone_body_entered(body: Node2D):
	#Checks if it's the player's character
	if body.is_in_group("player"):
		print("Character fell off! Loading next level")
		get_tree().change_scene_to_file("res://level_2.tscn")
