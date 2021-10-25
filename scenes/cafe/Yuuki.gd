extends StaticBody2D

const godash = preload("res://addons/godash/godash.gd")
const Cafe = preload("res://content/content.gd").CAFE

const sprites = [
	preload("res://scenes/cafe/yuuki_old.tres"),
	preload("res://scenes/cafe/yuuki.tres"),
]

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var dialogue = get_node("Dialogue")
onready var shop = get_node("Shop")
onready var sprite = get_node("Sprite")

func _ready():
	sprite.texture = godash.rand_choice(sprites)

func hint():
	return "Talk to Yuuki"

func interact():
	dialogue.begin()
	dialogue.text(
		"Welcome to the Catfe, Maia~!"
	)
	yield(dialogue.exec(), "completed")
	yield(shop.open(Cafe, false), "completed")

func _on_Shop_exchange(item, value):
	if not game_state:
		return
	
	# cafe items restore stamina instead of going into the inventory
	game_state.stamina += item.stamina
