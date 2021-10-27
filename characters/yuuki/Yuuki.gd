extends "res://characters/npc/npc.gd"

const godash = preload("res://addons/godash/godash.gd")
const Content = preload("res://content/content.gd")

const sprites = [
	preload("./yuuki_old.tres"),
	preload("./yuuki.tres"),
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
	for i in Content.ITEMS:
		if i.type == "cafe":
			if "unlock" in i and not game_state.flag(i.unlock):
				continue
			Cafe.append(i)
		
	yield(shop.open(Cafe, false), "completed")
