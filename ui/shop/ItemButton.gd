extends Button

var exchange = false
var item setget set_item

onready var sprite = get_node("ItemButton/Icon/TextureRect")
onready var pressed_bg = get_node("ItemButton/Icon/Pressed")
onready var unpressed_bg = get_node("ItemButton/Icon/Unpressed")
onready var cost = get_node("ItemButton/HBoxContainer/Cost")

func set_item(i):
	item = i
	sprite.texture = i.icon
	cost.text = "%d KP" % [i.price]

func _on_focus_entered():
	pressed_bg.visible = true
	unpressed_bg.visible = false

func _on_focus_exited():
	pressed_bg.visible = false
	unpressed_bg.visible = true
