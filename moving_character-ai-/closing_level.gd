extends Node2D


func _ready():
	print("Victory! Game completed!")

func _input(event):
	if event.is_action_pressed("ui_accept"): #ENTER or SPACE
		#Restarts to the beginning  
		get_tree().change_scene_to_file("res://world.tscn") 
