extends StaticBody2D

const Flowers = preload("res://content/content.gd").FLOWERS

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var shop = get_node("CanvasLayer/Shop")

func hint():
	return "Talk to Clover"

func interact():
	var choice = yield(dialogue.open([
		"Hi Maia!  What can I do for you?",
	], [
		"Talk",
		"Shop"
	]), "completed")
	
	if choice == 1:
		yield(shop.open(Flowers.values(), false), "completed")

func _on_Shop_exchange(item, value):
	if not game_state:
		return

	if value < 0: # bought seeds
		game_state.inventory["seed:%s" % item.id] += 1
	else:
		game_state.inventory[item.id] -= 1
