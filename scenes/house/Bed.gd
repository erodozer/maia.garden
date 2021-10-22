extends StaticBody2D

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()
onready var game_state = get_tree().get_nodes_in_group("game_state").front()

func hint():
	return "Go to Sleep"

func interact():
	if not game_state:
		return
	if not scene_manager:
		return
	
	scene_manager.change_scene("res://scenes/garden/Garden.tscn", {"location": "home"})
	game_state.advance_day()
