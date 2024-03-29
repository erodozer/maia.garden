extends "../request.gd"

func get_owner():
	return "chie"
	
func get_id():
	return "shrine_2"

func get_requirements():
	return [
		{
			"hint": "Chocolate Bread",
			"id": "chocobread",
			"amount": 5
		}
	]
	
func can_accept():
	return GameState.flag("unlock_bread") and GameState.flag("request:shrine_1:completed")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Maia!",
		"So about what's new,",
		"I heard about Yuuki's Catfe",
		"and how she bakes fresh bread!",
		"It sounds so good",
		"I want to taste it so badly",
		"Since I rarely leave the shrine",
		"usually I cook for myself.",
		"Could you please bring me some",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh my...",
		"This...is...",
		"DELICIOUS",
		"[shake rate=30 level=8]Thank you so much Maia[/shake]",
		"[shake rate=30 level=8]WAAAAAAAAAAAA[/shake]",
		"I will always be in your favor!"
	]), "completed")

func can_talk_to_yuuki():
	return not GameState.flag("unlock_chocobread")

func talk_to_yuuki():
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	
	if not GameState.inventory.can_insert({
		"id": "chocobread",
		"amount": 2
	}):
		yield(dialogue.open([
			"Hi Maia~",
			"Are you here for some bread?",
			"Oh, looks like your bag is full",
			"Come back later",
			"I'll be sure to save you a loaf",
		]), "completed")
		return
	
	yield(dialogue.open([
		"Chie asked you to get bread?",
		"Hmm, since this is Chie,",
		"I'll bake something special!",
		"Just wait a few seconds",
	]), "completed")
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	yield(dialogue.open([
		"Here we are!",
		"Tell me what you think",
		"[Got 2 Chocolate Bread]",
		"I'm sure she'll want more",
		"But I can't give them for free",
		"Support my business too, okay?",
	]), "completed")
	
	GameState.toggle_flag("unlock_chocobread")  # allow purchasing catgrass
	GameState.inventory.insert_item({
		"id": "chocobread",
		"amount": 2
	})
	
