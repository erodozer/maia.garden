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
		"Maia...",
		"I heard about Yuuki's Catfe",
		"and how she bakes fresh bread.",
		"It sounds so good",
		"I want to taste it so badly",
		"I rarely leave the shrine",
		"Could you please bring me some",
		"I'll forever be in your debt",
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
		"The Gods will always be in your favor!"
	]), "completed")

func can_talk_to_yuuki():
	return not GameState.flag("unlocked_chocobread")

func talk_to_yuuki():
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Chie asked you to get her bread?",
		"Not many stop by her shrine lately",
		"If she wants it fresh,",
		"She could just get it herself",
		"It's nice of you to help, though",
		"And since this is Chie,",
		"I'll bake something special.",
		"Here's a couple loaves",
		"Tell me what you think",
		"[Got 2 Chocolate Bread]",
		"I'm sure she'll want more",
		"But I can't give them for free"
	]), "completed")
	
	var catgrass = Content.get_item_reference("chocobread")
	GameState.inventory.insert_item({
		"id": catgrass.id,
		"ref": catgrass,
		"amount": 5
	})
	GameState.toggle_flag("unlocked_chocobread")  # allow purchasing catgrass
