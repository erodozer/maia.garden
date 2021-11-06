extends Button

var exchange = false
var item setget set_item

onready var sprite = get_node("ItemButton/Icon/TextureRect")
onready var pressed_bg = get_node("ItemButton/Icon/Pressed")
onready var unpressed_bg = get_node("ItemButton/Icon/Unpressed")
onready var cost = get_node("ItemButton/Cost")
onready var count = get_node("ItemButton/Icon/Count")
onready var sfx = get_node("Sfx")

func set_item(i):
	item = i
	sprite.texture = i.ref.icon
	if i.price == 0:
		cost.visible = false
	else:
		cost.visible = true
		cost.get_node("Label").text = "%d KP" % [i.price]
		
	if i.stock < 0:
		count.visible = false
	else:
		count.visible = true
		count.text = "%d" % i.stock

func _on_focus_entered():
	pressed_bg.visible = true
	unpressed_bg.visible = false
	sfx.play()

func _on_focus_exited():
	pressed_bg.visible = false
	unpressed_bg.visible = true
