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
	return GameState.flag("request:cafe_1:completed") and \
		GameState.inventory.can_insert([
			{
				"id": "seed_pumpkin",
				"amount": 1
			},
			{
				"id": "seed_tomato",
				"amount": 1
			},
			{
				"id": "seed_wheat",
				"amount": 1
			}
		])

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"I recently got a seed shipment",
		"But they're for food",
		"And this is a flower shop...",
		"What should I do?",
		"Wait a second",
		"Would you want to grow them?",
		"How about I give you some!",
		"[Got 1 Pumpkin Seed]",
		"[Got 1 Tomato Seed]",
		"[Got 1 Wheat Seed]",
		"You can say thanks by",
		"giving me what you grow!",
	]), "completed")
	GameState.inventory.insert_item([
		{
			"id": "seed_pumpkin",
			"amount": 1
		},
		{
			"id": "seed_tomato",
			"amount": 1
		},
		{
			"id": "seed_wheat",
			"amount": 1
		}
	])
	GameState.toggle_flag("unlocked_vegetables")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"These look absolutely delicious!",
		"Maybe I will start selling these",
		"Thank you Maia!",
	]), "completed")
	GameState.toggle_flag("unlocked_vegetables")
	
