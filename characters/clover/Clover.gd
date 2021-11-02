extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()

func hint():
	return "Talk to Clover"

func sell():
	var value = 0
	var flowers = []
	for f in GameState.inventory.data:
		if f.ref.type == "flower" and f.amount > 0:
			value += f.ref.price * f.amount
			flowers.append(f)
	
	if value <= 0:
		yield(dialogue.open([
			"Sorry Maia,",
			"I only buy flowers",
		]), "completed")
		return
	
	var choice = yield(dialogue.open([
		"Let's see...",
		"Yes, these look excellent!",
		"How does %d sound?" % [value]
	], ["Yes", "No"]), "completed")
	
	if choice == "Yes":
		yield(dialogue.open([
			"Great!  Thank you, Maia~",
		]), "completed")
		for f in flowers:
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

func interact():
	var choices = ["Shop", "Sell"]
	if can_talk():
		choices.push_front("Talk")
	
	var choice = yield(dialogue.open([
		"Hi Maia!  What can I do for you?",
	], choices), "completed")
	
	if choice == "Talk":
		yield(check_requests(), "completed")
		return
		
	if choice == "Sell":
		yield(sell(), "completed")
		return
	
	var select = []
	for f in Content.Items:
		if f.type != "tool":
			continue

		# only sell seeds
		if not f.id.begins_with("seed_"):
			continue

		if f.unlock and not GameState.flag(f.unlock):
			continue
		
		select.append({
			"ref": f,
			"price": f.price,
			"stock": -1,
		})
	
	yield(shop.open(select), "completed")
