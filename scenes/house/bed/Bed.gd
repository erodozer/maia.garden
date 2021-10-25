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
	
	if game_state.flag("introduce.proller") and not game_state.flag("introduce.proller.complete"):
		scene_manager.change_scene("darkness")
	else:
		scene_manager.change_scene("garden", {"location": "home"})
	game_state.advance_day()
