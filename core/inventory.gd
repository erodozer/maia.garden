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
				"icon": f.icon,
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
	
func sort_by_stack_capacity(a, b):
	var space_a = a.ref.stack - a.amount
	var space_b = b.ref.stack - b.amount
	return space_a > space_b
	
func can_insert(entries):
	if not (entries is Array):
		entries = [entries]
	
	var total_stacks = len(data)
	
	for entry in entries:
		var ref = entry.ref if "ref" in entry else Content.get_item_reference(entry.id)
		var sell = entry.amount < 0
		
		var amount = entry.amount
		var total = 0
		for i in data:
			if i.id == entry.id:
				total += i.amount
			
		var current_stacks = int(ceil(total / float(ref.stack)))
		var new_stacks = int(ceil((total + amount) / float(ref.stack)))
		
		if sell:
			# break early if there's not enough items to support the request
			if total + amount < 0:
				return false
				
		# check if there's room for new stacks
		total_stacks += new_stacks - current_stacks
		
		if total_stacks > self.bag_size:
			return false
	
	return true

func insert_item(entries):
	if not (entries is Array):
		entries = [entries]
	
	if not can_insert(entries):
		return false
	
	for entry in entries:
		var ref = entry.ref if "ref" in entry else Content.get_item_reference(entry.id)
		var sell = entry.amount < 0
		
		var total = 0
		var items = []
		for i in data:
			if i.id == entry.id:
				items.append(i)
				total += i.amount
		total += entry.amount
	
		# insure we take or add to lower capacity stacks first so
		# all stacks are appropriately filled up
		items.sort_custom(self, "sort_by_stack_capacity")

		if sell:
			var amount = entry.amount
			for item in items:
				var a = item.amount
				item.amount = max(amount + a, 0)
				amount = min(amount + a, 0)
				if item.amount == 0:
					data.remove(data.find(item))
		else:
			var icon = ref.icon
			if ref.type == "fish":
				icon = preload("res://content/fish/rare.png") \
					if entry.id.ends_with(":rare") \
					else preload("res://content/fish/icon.png")

			var amount = entry.amount
			# fill existing stacks
			for i in items:
				var a = i.amount
				i.amount = min(ref.stack, amount + i.amount)
				amount -= i.amount - a
						
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

func sort_requirements_by_priority(a, b):
	return len(a.matches) > len(b.matches)

# get list of all items (merged stacks) that are safe to process against (not required by any active quests)
func safe():
	var requirements = []
	for request in GameState.requests:
		if not request.accepted:
			continue
		if request.completed:
			continue
			
		for requirement in request.get_requirements():
			requirements.append({
				"matches": request.get_matching_items(requirement),
				"amount": requirement.amount,
			})
	
	requirements.sort_custom(self, "sort_requirements_by_priority")
	
	var totals = {}
	
	for i in GameState.inventory.data:
		totals[i.id] = totals.get(i.id, 0) + i.amount
	
	for requirement in requirements:
		for i in requirement.matches:
			if i in totals:
				var a = totals[i]
				totals[i] = max(a - requirement.amount, 0)
				requirement.amount = max(requirement.amount - a, 0)
				
				if totals[i] <= 0:
					totals.erase(i)
			
			if requirement.amount <= 0:
				break

	var select = []
	for id in totals:
		var ref = Content.get_item_reference(id)
		var icon = ref.icon
		if ref.type == "fish":
			icon = preload("res://content/fish/rare.png") \
				if id.ends_with(":rare") \
				else preload("res://content/fish/icon.png")

		select.append({
			"id": id,
			"icon": icon,
			"ref": ref,
			"price": 0,
			"amount": totals[id],
		})
	
	select.sort_custom(self, "sort_by_stack_size")
	return select
	
