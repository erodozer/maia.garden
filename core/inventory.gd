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
		var record = {
			"id": i.id,
			"ref": Content.get_item_reference(i.id),
			"amount": i.amount
		}
		if record.ref.type == "fish":
			record["icon"] = preload("res://content/fish/rare.png") \
				if i.id.ends_with(":rare") \
				else preload("res://content/fish/icon.png")
		data.append(record)
	
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
			
		requirements[request] = {}
		for requirement in request.get_requirements():
			requirements[request][requirement] = {
				"matches": request.get_matching_items(requirement),
				"amount": requirement.amount,
			}
		
	for i in GameState.inventory.data:
		select[i.id] = {
			"id": i.id,
			"ref": i.ref,
			"price": 0,
			"amount": i.amount,
		}
		
		for request in requirements:
			for requirement in requirements[request].values():
				if i.id in requirement.matches:
					select[i.id].amount = max(i.amount - requirement.amount, 0)
					requirement.amount = max(requirement.amount - i.amount, 0)
		
		if select[i.id].amount <= 0:
			select.erase(i.id)
	
	return select.values()
	
