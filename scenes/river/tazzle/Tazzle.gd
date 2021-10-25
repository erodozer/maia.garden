extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var shop = get_node("CanvasLayer/Shop")

func hint():
	return "Talk to Tazzle"
	
func interact():	
	yield(dialogue.open([
		"Hi Maia, good to see you!",
		"Do you have some fish for me?"
	]), "completed")

	# var list = []
	
	# for i in game_state.inventory:
	# 	if i.ref.type == "fish":
	# 		list.append(i)
	
	# if len(list) <= 0:
	# 	return
	
	# yield(shop.open([]), "completed")
