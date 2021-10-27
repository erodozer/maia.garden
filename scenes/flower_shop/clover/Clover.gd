extends "res://characters/npc/npc.gd"

const Content = preload("res://content/content.gd")

onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var shop = get_node("CanvasLayer/Shop")

func get_id():
	return "clover"

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
		yield(check_requests(), "complete")
		return
	
	var select = []
	for f in Content.ITEMS:
		if f.type != "tool":
			continue

		# only sell seeds
		if not f.id.begins_with("seed_"):
			continue

		if "unlock" in f and not game_state.flag(f.unlock):
			continue
		
		select.append(f)
	
	yield(shop.open(select, false), "completed")
