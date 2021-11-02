extends "../request.gd"

func get_owner():
	return "tazzle"

func get_id():
	return "fish_1"

func get_requirements():
	return [
		{
			"hint": "5 Pond Fish",
			"type": "fish",
			"location": "pond",
			"amount": 5,
		},
		{
			"hint": "5 River Fish",
			"type": "fish",
			"location": "river",
			"amount": 5,
		}
	]
	
func can_accept():
	return GameState.stats.fish_caught.value > 10

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Fish is pretty delicious~",
		"But I've been wondering",
		"is there a difference in taste",
		"between pond and river fish?",
		"Hey Maia, you wouldn't mind",
		"helping me compare, right?",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh man!",
		"They all look so good",
		"Fry 'em, grill 'em, stew 'em",
		"I can't decide!",
		"Well, I guess I can",
		"I'll let you know later",
		"As for now, though",
		"A gift, as thanks!",
		"[You got a hat]",
		"[You got a bigger Backpack]",
		"Now you can fish even more!",
		"Good for you and me"
	]), "completed")
	GameState.toggle_flag("bag_expansion:level_1")
	GameState.toggle_flag("outfit.hat")
