extends Node

signal changed(item, record)
	
var data = []
var bag_size setget ,get_bag_size

func _ready():
	reset()
			
func reset():
	data = []
	for f in Content.Items:
		if f.get("starting") and f.starting > 0:
			insert_item({
				"id": f.id,
				"ref": f,
				"amount": f.starting
			})
			
func persist(d):
	d["inventory"] = []
	for i in data:
		d.inventory.append({
			"id": i.id,
			"amount": i.amount
		})
		
	return d
	
func restore(d):
	data = []
	for i in d.inventory:
		data.append({
			"id": i.id,
			"ref": Content.get_item_reference(i.id),
			"amount": i.amount
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
			if i.amount + entry.amount <= i.ref.stack:
				item = i
				break
	
	if item:
		amount += item.amount
	
	if amount < 0:
		return false
	
	if not item:
		item = entry
		if len(data) + 1 <= self.bag_size:
			data.append(entry)
		else:
			return false
	
	item.amount = amount
	emit_signal("changed", item.id, item)
	
	if item.amount == 0:
		data.remove(data.find(item))
	
	return true

func get_item(id):
	var matching = []
	for i in data:
		if i.id == id:
			matching.append(i)
	return matching

# get list of all items (merged stacks) that are safe to process against (not required by any active quests)
func safe():
	var select = {}
	var requirements = {}
	for request in GameState.requests:
		if not request.accepted:
			continue
		if request.completed:
			continue
			
		for requirement in request.get_requirements():
			for i in request.get_matching_items(requirement):
				if i == "konpeito":
					continue
					
				var sum = requirements.get(i, 0)
				var item = GameState.inventory.get_item(i)
				for record in item:
					sum += record.amount
				requirements[i] = sum
			
	for i in GameState.inventory.data:
		if i.ref.id in select:
			select[i.ref.id].amount += i.amount
			continue
		
		select[i.ref.id] = {
			"ref": i.ref,
			"price": 0,
			"amount": i.amount,
		}
	
	for r in requirements:
		if not (r in select):
			continue
			
		select[r].amount -= requirements[r]
			
		if select[r].amount <= 0:
			select.erase(r)
	
	return select.values()
	
