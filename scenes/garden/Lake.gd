extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var minigame = get_tree().get_nodes_in_group("fishing").front()

func hint():
	return "Fish (Pond)"
	
func interact():
	if not minigame:
		return
		
	var fish = game_state.get_fish("pond")
	yield(minigame.open(fish), "completed")
	
