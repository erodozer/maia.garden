extends StaticBody2D

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()

func hint():
	return "Eat"
	
func interact():
	
	# get consumable items
	var select = []
	for i in GameState.inventory.data:
		if i.ref.type == "cafe":
			select.append({
				"ref": i.ref,
				"price": 0,
			})
	yield(shop.open(select), "closed")
