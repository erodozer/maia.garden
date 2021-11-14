extends "../request.gd"

func get_owner():
	return "tazzle"

func get_id():
	return "fish_2"

func get_requirements():
	return [
		{
			"hint": "Rare Fish",
			"type": "fish",
			"rare": true,
			"amount": 3,
		},
	]
	
func can_accept():
	return GameState.stats.fish_caught.value > 30 and GameState.flag("request:fish_1:completed")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh hey there Maia...",
		"Sorry, but...",
		"I'm already out of fish.",
		"So nothing to cook right now",
		"However, on that note",
		"What do you think makes",
		"a fish taste best?",
		"I think I like rare fish the best",
		"You can tell if a fish is rare",
		"by their golden color",
		"Could you help me catch some?",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Woah!!",
		"Some of these fish",
		"I've never seen so big before!",
		"But what's big in size,",
		"Big in flavor?",
		"Time to find out!",
		"Thanks again, Maia",
		"I'll return the favor somehow",
	]), "completed")
