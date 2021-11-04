extends "../request.gd"

func get_owner():
	return "clover"
	
func get_id():
	return "flower_1"

func get_requirements():
	return [
		{
			"hint": "Pumpkin",
			"id": "pumpkin",
			"amount": 1
		},
		{
			"hint": "Tomato",
			"id": "tomato",
			"amount": 1
		},
		{
			"hint": "Wheat",
			"id": "wheat",
			"amount": 1
		},
	]
	
func can_accept():
	# must complete yuuki's first quest before this unlocks
	return GameState.flag("request:cafe_1:completed")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"I recently got a seed shipment",
		"But they're for farm crops",
		"And this is a flower shop...",
		"What should I do?",
		"Hey!",
		"How about I give them to you!",
		"[Got 1 Pumpkin Seed]",
		"[Got 1 Tomato Seed]",
		"[Got 1 Wheat Seed]",
		"You can say thanks by",
		"giving me what you grow!"
	]), "completed")
	var item = Content.get_item_reference("seed_pumpkin")
	GameState.inventory.insert_item({
		"id": item.id,
		"ref": item,
		"amount": 1
	})
	item = Content.get_item_reference("seed_tomato")
	GameState.inventory.insert_item({
		"id": item.id,
		"ref": item,
		"amount": 1
	})
	item = Content.get_item_reference("seed_wheat")
	GameState.inventory.insert_item({
		"id": item.id,
		"ref": item,
		"amount": 1
	})

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"These look absolutely delicious!",
		"Maybe I will start selling these",
		"Thank you Maia!",
		"[You can now buy farm seeds]"
	]), "completed")
	GameState.toggle_flag("unlocked_vegetables")
