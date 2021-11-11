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
		var ref = Content.get_item_reference(i.id)
		var record = {
			"id": i.id,
			"ref": ref,
			"icon": ref.icon,
			"amount": i.amount,
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
	var ref = entry.ref if "ref" in entry else Content.get_item_reference(entry.id)
	var sell = entry.amount < 0
	var amount = entry.amount
	var items = []
	for i in data:
		if i.id == entry.id:
			if sell:
				amount += i.amount
			else:
				amount -= i.amount
			items.append(i)
			
	var total = 0
	if sell:
		if amount < 0:
			return false
			
		amount = entry.amount
		for item in items:
			var a = item.amount
			item.amount = max(amount + a, 0)
			amount = min(amount + a, 0)
			if item.amount == 0:
				data.remove(data.find(item))
			else:
				total += item.amount
	else:
		# check if there's room for new stacks
		amount = entry.amount
		for i in items:
			if i.amount < ref.stack:
				amount -= ref.stack - i.amount
		var stacks = int(ceil(amount / float(ref.stack))) if amount > 0 else 0
		
		if len(data) + stacks > self.bag_size:
			return false
		
		amount = entry.amount
		# fill existing stacks
		for i in items:
			var a = i.amount
			i.amount = min(ref.stack, amount + i.amount)
			amount -= i.amount - a
			total += i.amount - a
		
		var icon = ref.icon
		if ref.type == "fish":
			icon = preload("res://content/fish/rare.png") \
				if entry.id.ends_with(":rare") \
				else preload("res://content/fish/icon.png")
		
		# create new stacks
		while amount > 0:
			var a = min(ref.stack, amount)
			data.append({
				"id": entry.id,
				"ref": ref,
				"icon": icon,
				"amount": a,
			})
			amount -= a
			total += a
			
	emit_signal("changed", entry.id, {
		"id": entry.id,
		"ref": ref,
		"amount": total,
	})
	
	return true

func get_item(id):
	var matching = []
	for i in data:
		if i.id == id:
			matching.append(i)
	return matching

func sort_by_stack_size(a, b):
	return a.amount < b.amount

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
		var item = {
			"id": i.id,
			"icon": i.icon,
			"ref": i.ref,
			"price": 0,
			"amount": i.amount + select.get(i.id, {}).get("amount", 0),
		}
		
		for request in requirements:
			for requirement in requirements[request].values():
				if i.id in requirement.matches:
					item.amount = max(i.amount - requirement.amount, 0)
					requirement.amount = max(requirement.amount - i.amount, 0)
		
		if item.amount <= 0:
			select.erase(i.id)
		else:
			select[i.id] = item
	
	var v = select.values()
	v.sort_custom(self, "sort_by_stack_size")
	return v
	
