extends "res://characters/npc/npc.gd"

const godash = preload("res://addons/godash/godash.gd")

const sprites = [
	preload("res://characters/yuuki/yuuki_old.tres"),
	preload("res://characters/yuuki/yuuki.tres"),
]

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()
onready var sprite = get_node("Sprite")

func _ready():
	sprite.texture = godash.rand_choice(sprites)

func hint():
	return "Talk to Yuuki"

func interact():
	var choices = ["Shop"]
	if can_talk():
		choices.push_front("Talk")
	
	var choice = yield(dialogue.open([
		"Welcome to the Catfe, Maia~!",
	], choices), "completed")
	
	if choice == "Talk":
		yield(check_requests(), "completed")
		return
	
	var Cafe = []
	for i in Content.Items:
		if i.type == "cafe":
			if i.unlock and not GameState.flag(i.unlock):
				continue
			Cafe.append({
				"ref": i,
				"value": i.price,
				"stock": -1,
			})
		
	yield(shop.open(Cafe), "completed")
