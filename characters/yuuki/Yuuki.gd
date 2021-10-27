extends "res://characters/npc/npc.gd"

const godash = preload("res://addons/godash/godash.gd")

const sprites = [
	preload("res://characters/yuuki/yuuki_old.tres"),
	preload("res://characters/yuuki/yuuki_old.tres"),
]

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var shop = get_tree().get_nodes_in_group("shop").front()
onready var sprite = get_node("Sprite")

func _ready():
	sprite.texture = godash.rand_choice(sprites)

func hint():
	return "Talk to Yuuki"

func interact():
	var choices = []
	if can_talk():
		choices = ["Talk", "Shop"]
	
	var choice = yield(dialogue.open([
		"Welcome to the Catfe, Maia~!",
	], choices), "completed")
	
	if choice == 0:
		yield(check_requests(), "completed")
		return
	
	var Cafe = []
	for i in Content.Items:
		if i.type == "cafe":
			if i.unlock and not game_state.flag(i.unlock):
				continue
			Cafe.append(i)
		
	yield(shop.open(Cafe), "completed")
