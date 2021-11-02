extends Control

const button = preload("./ItemButton.tscn")

signal exchange(item, value)
signal end

onready var items = get_node("PanelContainer/ScrollContainer/Items")
onready var tween = get_node("Tween")
onready var description = get_node("Description/Label")
onready var scroll = get_node("PanelContainer/ScrollContainer")
	
var group

func _ready():
	set_process_input(false)
	
func exchange(btn):
	var item = btn.item
	var value = btn.price
	var stock = btn.stock
			
	# purchase an item
	if value > 0 and GameState.player.balance - value < 0:
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
	
	if item.get("stamina") and item.stamina > 0:
		if item.stack == 0 or value == 0:
			# most cafe items restore stamina directly 
			# instead of going into the inventory
			GameState.player.stamina += item.stamina
	
	if value > 0:
		GameState.player.balance -= value
		GameState.emit_signal("stat", "shop.purchase", {
			"item": item,
			"value": value,
		})
	else:
		GameState.emit_signal("stat", "shop.spend", {
			"item": item,
		})
	
	if stock > 0:
		stock -= 1
		btn.stock = stock
		
	if btn.stock == 0:
		btn.queue_free()

	emit_signal("exchange", item, value)
	return true
	
func open(item_list):
	group = ButtonGroup.new()
	
	for i in item_list:
		if i.stock != 0:
			var b = button.instance()
			items.add_child(b)
			b.item = i.ref
			b.price = i.price
			b.stock = i.stock
			b.group = group
			b.connect("focus_entered", self, "update_description", [i.ref])
			b.connect("toggled", self, "_on_toggle_button", [b])
		
	group.get_buttons().front().grab_focus()
		
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
	
func _on_toggle_button(pressed, btn):
	if not pressed:
		return
		
	exchange(btn)
	yield(get_tree(), "idle_frame")
	if items.get_child_count() <= 0:
		emit_signal("end")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")
