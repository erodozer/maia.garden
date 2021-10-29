extends Control

const button = preload("./ItemButton.tscn")

signal exchange(item, value)
signal end

onready var items = get_node("PanelContainer/MarginContainer/ScrollContainer/Items")
onready var tween = get_node("Tween")
onready var description = get_node("Description/MarginContainer/Label")
onready var scroll = get_node("PanelContainer/MarginContainer/ScrollContainer")
	
var group

func _ready():
	set_process_input(false)
	
func exchange(item, value):
	# purchase an item
	if value > 0 and GameState.konpeto - value < 0:
		return false
	
	var exchanged = false

	# if value is zero, it may cost an inventory item
	if value == 0:
		exchanged = GameState.inventory.insert_item({
			"id": item.id,
			"ref": item,
			"amount": -1,
		})
	elif item.stack > 0:
		exchanged = GameState.inventory.insert_item({
			"id": item.id,
			"ref": item,
			"amount": 1,
		})
	
	if not exchanged:
		return false
	
	if item.type == "cafe":
		if item.stack == 0 or value == 0:
			# most cafe items restore stamina directly 
			# instead of going into the inventory
			GameState.stamina += item.stamina
	
	if value > 0:
		GameState.konpeto -= value
		GameState.emit_signal("stat", "shop.purchase", {
			"item": item,
			"value": value,
		})
	else:
		GameState.emit_signal("stat", "shop.spend", {
			"item": item,
		})
	
	emit_signal("exchange", item, value)
	return true
	
func open(item_list):
	group = ButtonGroup.new()
	
	for i in item_list:
		var b = button.instance()
		items.add_child(b)
		b.item = i.ref
		b.price = i.price
		b.group = group
		b.connect("focus_entered", self, "update_description", [i])
		
	group.get_buttons()[0].pressed = true
	group.get_buttons()[0].grab_focus()
		
	visible = true
	tween.interpolate_property(self, "rect_position:y", -120, 0, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(self, "rect_position:y", 0, -120, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
	
	group.connect("changed", self, "update_label")
	
	for c in items.get_children():
		c.queue_free()

func update_description(item):
	description.text = item.description
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")
	if event.is_action_pressed("ui_accept"):
		var btn = group.get_pressed_button()
		var item = btn.item
		exchange(btn.item, btn.price)
