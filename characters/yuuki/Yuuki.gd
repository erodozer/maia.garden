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
	GameState.toggle_flag("talked_to.yuuki")
	var choices = ["Shop"]
	if can_talk():
		choices.push_front("Talk")
	
	var choice = yield(dialogue.open([
		"Welcome to the Catfe, Maia~!",
	], choices), "completed")
	
	if choice == "Talk":
		yield(check_requests(), "completed")
		return
		
	var stock = GameState.shops.cafe.stock
	if len(stock) == 0:
		yield(dialogue.open([
			"Oh, sorry Maia",
			"It looks like I'm all out",
			"You'll have to visit tomorrow",
		]), "completed")
		return
	
	yield(shop.open(stock), "completed")
