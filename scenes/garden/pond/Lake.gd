extends StaticBody2D

onready var minigame = get_tree().get_nodes_in_group("fishing").front()

func hint():
	return "Fish (Pond)"
	
func interact():
	if not minigame:
		return
		
	yield(minigame.open("pond"), "completed")
	
