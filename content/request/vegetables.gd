extends "../request.gd"

# state variables
var talked_to_clover = false

func get_owner():
	return "clover"

func get_id():
	return "vegetables"

func get_requirements():
	return [
		{
			"hint": "1 Pumpkin",
			"id": "pumpkin",
			"amount": 1
		},
		{
			"hint": "1 Tomato",
			"id": "tomato",
			"amount": 1
		},
	]

func prompt():
	return "Yuuki is in need of supplies for the Catfe"
	
func can_accept():
	return true

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"I recently got a seed shipment",
		"But they're for vegetables...",
		"I don't know what to do with them",
		"I'm not running a farmers market",
		"Unfortunately they're paid for",
		"Since I don't have a use for them",
		"How about I give them to you!",
		"[Got 1 Pumpkin Seed]",
		"[Got 1 Tomato Seed]",
	]), "completed")
	var item = Content.get_item_reference("seed_pumpkin")
	game_state.inventory.insert_item({
		"id": item.id,
		"ref": item,
		"amount": 5
	})
	item = Content.get_item_reference("seed_tomato")
	game_state.inventory.insert_item({
		"id": item.id,
		"ref": item,
		"amount": 5
	})

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"These look absolutely delicious!",
		"Maybe I will start selling these",
		"Thank you Maia!",
		"[You can now buy vegetables]"
	]), "completed")
	game_state.toggle("unlocked_vegetables")
