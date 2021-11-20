extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func can_sell():
	var value = 0
	for f in GameState.inventory.safe():
		if f.ref.type == "fish":
			var price = f.ref.price
			if f.id.ends_with(":rare"):
				price *= 2
			value += price * f.amount

	return value > 0

func sell():
	var value = 0
	var fish = {}
	for f in GameState.inventory.safe():
		if f.ref.type == "fish":
			var price = f.ref.price
			if f.id.ends_with(":rare"):
				price *= 2
			value += price * f.amount
			fish[f.id] = fish.get(f.id, 0) + f.amount
	
	var choice = yield(dialogue.open([
		"Oh, these fish look delicious!",
		"I'll pay %d konpeito for 'em" % [value]
	], ["Yes", "No"]), "completed")
	
	if choice == "Yes":
		yield(dialogue.open([
			"My mouth is already watering~",
			"Thank you, Maia!",
		]), "completed")
		var sell = []
		for f in fish:
			sell.append({
				"id": f,
				"amount": -fish[f],
			})
		GameState.inventory.insert_item(sell)
		GameState.player.balance += value
	else:
		yield(dialogue.open([
			"Oh, that's too bad",
			"Maybe some other time",
		]), "completed")

func hint():
	return "Talk to Tazzle"
	
func interact():
	GameState.toggle_flag("talked_to.tazzle")
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
