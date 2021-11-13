extends StaticBody2D

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()
onready var eat_sfx = get_node("Eat")

func on_exchange(_item, _value):
	eat_sfx.play()
	if GameState.player.stamina >= 100:
		shop.emit_signal("end")

func hint():
	return "Eat"
	
func get_edibles():
	var select = {}
	for i in GameState.inventory.data:
		if not i.ref.get("stamina"):
			continue
			
		select[i.id] = {
			"id": i.id,
			"icon": i.icon,
			"ref": i.ref,
			"price": 0,
			"stock": i.amount + select.get(i.id, {}).get("stock", 0),
		}
	
	return select.values()
	
func can_interact():
	return GameState.player.stamina < 100 and len(get_edibles())
	
func interact():
	# get consumable items
	var select = get_edibles()
	
	shop.connect("exchange", self, "on_exchange")
	yield(shop.open(select), "completed")
	shop.disconnect("exchange", self, "on_exchange")
