extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()

func hint():
	return "Talk to Clover"

func interact():
	var choices = []
	if can_talk():
		choices = ["Talk", "Shop"]
	
	var choice = yield(dialogue.open([
		"Hi Maia!  What can I do for you?",
	], choices), "completed")
	
	if choice == 0:
		yield(check_requests(), "completed")
		return
	
	var select = []
	for f in Content.Items:
		if f.type != "tool":
			continue

		# only sell seeds
		if not f.id.begins_with("seed_"):
			continue

		if f.unlock and not game_state.flag(f.unlock):
			continue
		
		select.append(f)
	
	yield(shop.open(select), "completed")
