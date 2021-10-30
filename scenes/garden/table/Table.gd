extends StaticBody2D

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()

func on_exchange(_item, _value):
	if GameState.stamina >= 100:
		shop.emit_signal("end")

func hint():
	return "Eat"
	
func interact():
	if GameState.stamina >= 100:
		yield(dialogue.open([
			"I'm not hungry"
		]), "completed")
		return
		
	# get consumable items
	var select = []
	for i in GameState.inventory.data:
		if i.ref.get("stamina") and i.ref.stamina > 0:
			select.append({
				"ref": i.ref,
				"price": 0,
				"stock": i.amount,
			})
			
	if len(select) == 0:
		yield(dialogue.open([
			"I have nothing to eat"
		]), "completed")
		return
	
	shop.connect("exchange", self, "on_exchange")
	yield(shop.open(select), "completed")
	shop.disconnect("exchange", self, "on_exchange")
