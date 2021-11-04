extends "../request.gd"

func get_owner():
	return "yuuki"
	
func get_id():
	return "cafe_1"

func get_requirements():
	return [
		{
			"hint": "Catgrass",
			"id": "catgrass",
			"amount": 5
		}
	]
	
func can_accept():
	return GameState.flag("introduce.clover") and GameState.flag("introduce.yuuki")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Hey Maia, could you help me?",
		"My cats deserve something nice",
		"Will you visit the flower shop",
		"They should have Catgrass",
		"Thank you~",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"This is perfect! Thank you Maia~",
	]), "completed")

func can_talk_to_clover():
	return not GameState.flag("unlocked_catgrass")

func talk_to_clover():
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh Yuuki asked you to stop by?",
		"Sadly I don't have any catgrass",
		"However, I do have some seeds",
		"You can grow it in your garden",
		"The quality will be just as good",
		"[Got 5 Catgrass Seeds]",
		"When you're done helping",
		"Feel free to purchase more",
		"I will accept anything you grow",
	]), "completed")
	
	var catgrass = Content.get_item_reference("seed_catgrass")
	GameState.inventory.insert_item({
		"id": catgrass.id,
		"ref": catgrass,
		"amount": 5
	})
	GameState.toggle_flag("unlocked_catgrass")  # allow purchasing catgrass
