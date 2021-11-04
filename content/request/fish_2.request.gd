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
		"The fish you caught last time",
		"were plenty good, but...",
		"I've been thinking again.",
		"Do you think a fish tastes better",
		"when it's harder to catch?",
		"Have you ever caught a rare fish?",
		"When a fish is larger than average,",
		"that is for its species,",
		"I consider rare.",
		"Could you help me catch some"
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Woah!!",
		"Some of these kinds of fish",
		"I've never seen so big before!",
		"But what's big in size,",
		"Big in flavor?",
		"Time to find out!",
		"Thanks again, Maia",
		"I'll return the favor somehow",
	]), "completed")
	GameState.toggle_flag("bag_expansion:level_1")
