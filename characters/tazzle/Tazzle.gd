extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func can_sell():
	var value = 0
	for f in GameState.inventory.data:
		if f.ref.type == "fish" and f.amount > 0:
			var price = f.ref.price
			if f.id.ends_with(":rare"):
				price *= 2
			value += price * f.amount

	return value <= 0

func sell():
	var value = 0
	var fish = []
	for f in GameState.inventory.data:
		if f.ref.type == "fish" and f.amount > 0:
			var price = f.ref.price
			if f.id.ends_with(":rare"):
				price *= 2
			value += price * f.amount
			fish.append(f)
	
	var choice = yield(dialogue.open([
		"Do you have some fish for me?",
		"Oh, these look delicious!",
		"How does %d sound?" % [value]
	], ["Yes", "No"]), "completed")
	
	if choice == "Yes":
		yield(dialogue.open([
			"My mouth is already watering~",
			"Thank you, Maia!",
		]), "completed")
		for f in fish:
			GameState.inventory.insert_item({
				"id": f.id,
				"amount": -f.amount
			})
		GameState.player.balance += value
	else:
		yield(dialogue.open([
			"Oh, that's too bad",
			"Maybe some other time",
		]), "completed")

func hint():
	return "Talk to Tazzle"
	
func interact():
	var choices = []
	if can_sell():
		choices.append("Sell")
	if can_talk():
		choices.push_front("Talk")
	
	var choice = yield(dialogue.open([
		"Hi Maia! Good to see you!",
	], choices), "completed")
	
	if choice == "Talk":
		yield(check_requests(), "completed")
		return
		
	if choice == "Sell":
		yield(sell(), "completed")
		return
