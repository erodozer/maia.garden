extends StaticBody2D

onready var minigame = get_node("CanvasLayer/Fishing")

func hint():
	return "Fish (Pond)"
	
func interact():
	if not minigame:
		return
		
	yield(minigame.open("pond"), "completed")
	
