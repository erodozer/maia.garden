extends StaticBody2D

const Flowers = preload("res://content/content.gd").FLOWERS

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var shop = get_node("CanvasLayer/Shop")

func hint():
	return "Talk to Clover"

func interact():
	var choice = yield(dialogue.open([
		"Hi Maia!  What can I do for you?",
	], [
		"Talk",
		"Shop"
	]), "completed")
	
	if choice == 1:
		var select = []
		for f in Flowers.values():
			if not ("unlock" in f) or game_state.flag(f.unlock):
				select.append(f)
		
		yield(shop.open(select, false), "completed")
		return
	
	if game_state.flag("request.yuuki_1.start") and not game_state.flag("request.yuuki_1.talked_to_clover"):
		yield(dialogue.open([
			"Oh Yuuki asked you to stop by?",
			"Sadly I don't have any catgrass",
			"However, I do have some seeds",
			"You can grow it in your garden",
			"The quality will be just as good",
			"[Received 5 Catgrass seeds]",
			"Feel free to buy more if you need"
		]), "completed")
		game_state.inventory["seed:catgrass"] += 5
		game_state.toggle_flag("unlocked_catgrass")
		game_state.toggle_flag("request.yuuki_1.talked_to_clover")
		
	if game_state.flag("request.yuuki_1.completed"):
		if not game_state.flag("unlocked_vegetables"):
			yield(dialogue.open([
				"I recently got a seed shipment",
				"But they're for vegetables...",
				"I don't know what to do with them",
				"I'm not running a farmers market",
				"Unfortunately they're paid for",
				"Would you mind buying them off of me?",
				"[You can now buy vegetables]"
			]), "completed")
			game_state.toggle("unlocked_vegetables")
			
func _on_Shop_exchange(item, value):
	if not game_state:
		return

	if value < 0: # bought seeds
		game_state.inventory["seed:%s" % item.id] += 1
	else:
		game_state.inventory[item.id] -= 1
