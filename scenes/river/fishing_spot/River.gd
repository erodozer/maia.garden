extends StaticBody2D

onready var fishing = get_node("CanvasLayer/Fishing")

func hint():
	return "Fish (River)"
	
func interact():
	yield(fishing.open("river"), "completed")
	return
