extends Node

signal changed(item, record)
	
var data = []
var bag_size setget ,get_bag_size

func _ready():
	for f in Content.Items:
		if f.get("starting") and f.starting > 0:
			insert_item({
				"id": f.id,
				"ref": f,
				"amount": f.starting
			})
			
func get_bag_size():
	var size = 20
	if GameState.flag("bag_expansion:level_3"):
		size += 10
	if GameState.flag("bag_expansion:level_2"):
		size += 10
	if GameState.flag("bag_expansion:level_1"):
		size += 10
	return size
	
func is_full():
	return len(data) >= self.bag_size

func insert_item(entry):
	var amount = entry.amount
	var item
	for i in data:
		if i.id == entry.id:
			if i.amount + entry.amount < i.ref.stack:
				item = i
				break
	
	if item:
		amount += item.amount
	
	if amount < 0:
		return false
	
	if not item:
		item = entry
		if len(data) + 1 < self.bag_size:
			data.append(entry)
		else:
			return false
	
	item.amount = amount
	emit_signal("changed", item.id, item)
	
	if item.amount == 0:
		data.remove(data.find(item))
	
	return true

func get_item(id):
	for i in data:
		if i.id == id:
			return i
	return null
