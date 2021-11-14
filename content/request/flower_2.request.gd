extends "../request.gd"

func get_owner():
	return "clover"

func get_id():
	return "flower_2"

func get_requirements():
	return [
		{
			"hint": "Konpeito",
			"id": "konpeito",
			"amount": 2500
		},
	]
	
func can_accept():
	# must complete yuuki's first quest before this unlocks
	return GameState.flag("request:flower_1:completed")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"You've been a big help lately",
		"The flowers you grow",
		"they sell out so fast!",
		"So I came up with an idea",
		"Let me help you help me",
		"I can make your garden bigger",
		"Then you can grow more",
		"But, uhhh, I can't work for free",
		"Expanding your garden",
		"That takes time",
		"time I could be selling flowers",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"This definitely covers expenses",
		"Alright, time to work the field",
		"Thanks a bunch, Maia",
		"I'm sure you'll love it",
	]), "completed")
	GameState.toggle_flag("garden.boost_1")
