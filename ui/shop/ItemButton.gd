extends Control

var exchange = false
var item setget set_item

onready var button = get_node("Button")
onready var sprite = get_node("Button/TextureRect")
onready var cost = get_node("HBoxContainer/Cost")

func set_item(i):
	item = i
	sprite.texture = load("res://content/%s/%s/item.%s.tres" % [
		item.type,
		item.id,
		"sell" if exchange else "buy",
	])
	cost.text = "%d KP" % [i.sell if exchange else i.cost]
