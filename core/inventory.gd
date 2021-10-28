extends Node

signal changed(item, record)
	
var data = []

func _ready():
	for f in Content.Items:
		if f.type == "tool" and f.starting > 0:
			insert_item({
				"id": f.id,
				"ref": f,
				"amount": f.starting
			})
	

func insert_item(entry):
	var item = get_item(entry.id)
	var amount = entry.amount
	if item:
		amount += item.amount
	
	if amount < 0:
		return false
	
	if not item:
		item = entry
		data.append(entry)
	
	item.amount = amount
	emit_signal("changed", item.id, item)
	return true

func get_item(id):
	for i in data:
		if i.id == id:
			return i
	return null
