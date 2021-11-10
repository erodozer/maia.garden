extends Control

const button = preload("./ItemButton.tscn")

signal exchange(item, value)
signal end

onready var items = get_node("PanelContainer/ScrollContainer/Items")
onready var tween = get_node("Tween")
onready var description = get_node("Description/Label")
onready var scroll = get_node("PanelContainer/ScrollContainer")

func _ready():
	set_process_input(false)
	
func exchange(btn):
	var item = btn.item
			
	# purchase an item
	if item.price > 0 and GameState.player.balance - item.price < 0:
		return false
	
	var exchanged = false

	# if value is zero, it may cost an inventory item
	if item.price == 0:
		exchanged = GameState.inventory.insert_item({
			"id": item.ref.id,
			"ref": item.ref,
			"amount": -1,
		})
	# handle putting items into your inventory
	elif item.ref.stack > 0:
		exchanged = GameState.inventory.insert_item({
			"id": item.ref.id,
			"ref": item.ref,
			"amount": 1,
		})
	# handle cafe items that are instant consume
	elif item.ref.stack == 0 and item.ref.get("stamina") and item.ref.stamina > 0:
		exchanged = true
	
	if not exchanged:
		return false
	
	if item.ref.get("stamina") and item.ref.stamina > 0:
		if item.ref.stack == 0 or item.price == 0:
			# most cafe items restore stamina directly 
			# instead of going into the inventory
			GameState.player.stamina += item.ref.stamina
	
	if item.price > 0:
		GameState.player.balance -= item.price
		GameState.emit_signal("stat", "shop.purchase", {
			"item": item.ref,
			"value": item.price,
		})
	else:
		GameState.emit_signal("stat", "shop.spend", {
			"item": item.ref,
		})
	
	if item.stock > 0:
		item.stock -= 1
			
	emit_signal("exchange", item.ref, item.price)
	
	if item.stock == 0:
		btn.queue_free()
		yield(btn, "tree_exited")
		if items.get_child_count() <= 0:
			emit_signal("end")
		else:
			items.get_child(0).grab_focus()
	else:
		btn.item = item

	return true
	
func sort_stock(a, b):
	if "sort_weight" in a.ref and "sort_weight" in b.ref:
		return a.ref.sort_weight < b.ref.sort_weight
	return false
	
func open(item_list):
	if len(item_list) <= 0:
		yield(get_tree(), "idle_frame")
		return
	
	var group = ButtonGroup.new()
	group.connect("changed", self, "update_label")
	group.connect("pressed", self, "exchange")
	
	item_list.sort_custom(self, "sort_stock")
	for i in item_list:
		if i.stock != 0:
			var b = button.instance()
			items.add_child(b)
			b.item = i
			b.group = group
			b.connect("focus_entered", self, "update_description", [i])
		
	yield(get_tree(), "idle_frame")
	
	visible = true
	tween.interpolate_property(self, "rect_position:y", -120, 0, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	items.get_child(0).grab_focus()
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(self, "rect_position:y", 0, -120, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
	
	for c in items.get_children():
		c.release_focus()
		c.queue_free()

func update_description(item):
	var ref = item.ref
	var d = ref.description
	if "description" in item and item.description:
		d = item.description
	if not d:
		d = ref.name
		
	if "stamina" in ref and ref.stamina > 0:
		d = "%s (%d ST)" % [d, ref.stamina]
	if item.ref.type == "tool" and item.ref.effect.type == "flower":
		d = "%s (%d days)" % [d, item.ref.effect.mature]
	
	description.text = d
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")
