extends StaticBody2D

const godash = preload("res://addons/godash/godash.gd")
const Cafe = preload("res://content/content.gd").CAFE

const sprites = [
	preload("res://scenes/cafe/yuuki/yuuki_old.tres"),
	preload("res://scenes/cafe/yuuki/yuuki.tres"),
]

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var requests = get_node("CanvasLayer/Requests")
onready var shop = get_node("CanvasLayer/Shop")
onready var sprite = get_node("Sprite")

func _ready():
	sprite.texture = godash.rand_choice(sprites)

func hint():
	return "Talk to Yuuki"

func interact():
	var choice = yield(dialogue.open([
		"Welcome to the Catfe, Maia~!",
	], ["Talk", "Shop"]), "completed")
	
	if choice == 1:
		yield(shop.open(Cafe, false), "completed")
		return
		
	if not game_state.flag("request.yuuki_1.complete") and game_state.flag("introduce.clover"):
		if not game_state.flag("request.yuuki_1.start"):
			yield(dialogue.open([
				"Hey Maia, could you help me?",
				"My cats deserve something nice",
				"Will you visit the flower shop",
				"They should have Catgrass",
				"Thank you~",
			]), "completed")
			game_state.toggle_flag("request.yuuki_1.start")
		
		var submitted = yield(requests.open(
			[
				{
					"hint": "5 Catgrass",
					"id": "catgrass",
					"amount": 5,
				},
			], 
			"Yuuki is in need of supplies for the Catfe"
		), "completed")
	
		if not submitted:
			return
		
		yield(dialogue.open([
			"This is perfect! Thank you Maia~",
		]), "completed")
		

func _on_Shop_exchange(item, value):
	if not game_state:
		return
	
	# cafe items restore stamina instead of going into the inventory
	game_state.stamina += item.stamina
