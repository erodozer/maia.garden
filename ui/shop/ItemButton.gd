extends Button

var exchange = false
var item setget set_item
var price setget set_price
var stock setget set_stock

onready var sprite = get_node("ItemButton/Icon/TextureRect")
onready var pressed_bg = get_node("ItemButton/Icon/Pressed")
onready var unpressed_bg = get_node("ItemButton/Icon/Unpressed")
onready var cost = get_node("ItemButton/Cost")
onready var count = get_node("ItemButton/Icon/Count")

func set_item(i):
	item = i
	sprite.texture = i.icon

func set_price(v):
	price = v
	if price == 0:
		cost.visible = false
	else:
		cost.visible = true
		cost.get_node("Label").text = "%d KP" % [v]
		
func set_stock(v):
	stock = v
	if stock < 0:
		count.visible = false
	else:
		count.visible = true
		count.text = "%d" % v

func _on_focus_entered():
	pressed_bg.visible = true
	unpressed_bg.visible = false

func _on_focus_exited():
	pressed_bg.visible = false
	unpressed_bg.visible = true
