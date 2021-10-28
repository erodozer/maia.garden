extends StaticBody2D

onready var fishing = get_tree().get_nodes_in_group("fishing").front()

func hint():
	return "Fish (River)"
	
func interact():
	yield(fishing.open("river"), "completed")
	return
