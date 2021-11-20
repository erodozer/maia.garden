extends Node

const godash = preload("res://addons/godash/godash.gd")

var task
var until = 0
var start = 0
var collection = {}

var is_hired setget ,get_hired
var collected setget ,is_collected

func is_collected():
	return len(collection) == 0

func collect():
	var inserted = GameState.inventory.insert_item(collection.values())
	if not inserted:
		return []
	var items = collection.values()
	collection = {}
	return items

func sell():
	var value = 0
	for i in collection.values():
		value += i.ref.price
	GameState.inventory.insert_item({
		"id": "konpeito",
		"amount": value,
	})
	collection = {}
	return value

func _on_calendar_advance(day):
	if day >= until:
		return
	
	if task == "Garden":
		for plant in GameState.garden.plots.values():
			if plant.age >= plant.ref.mature:
				GameState.garden.plots.erase(plant.cell)
				var add = collection.get(plant.ref.id, {
					"id": plant.ref.id,
					"ref": plant.ref,
					"amount": 0,
				})
				add.amount += 1
				collection[plant.ref.id] = add
			else:
				plant.watered = true
	elif task == "Fish":
		# fish a random amount
		var catch = randi() % 6
		var fish = []
		for i in Content.Items:
			if i.type != "fish":
				continue
			fish.append(i)
		for i in range(catch):
			var f = godash.rand_choice(fish)
			var add = collection.get(f.id, {
				"id": f.id,
				"ref": f,
				"amount": 0,
			})
			add.amount += 1
			collection[f.id] = add
	
func get_hired():
	return until > GameState.calendar.day
	
func start_task(task, duration):
	self.task = task
	until = GameState.calendar.day + duration + 86400 # start tomorrow
	start = GameState.calendar.day
	GameState.emit_signal("stat", "automate", {
		"task": task,
		"until": until,
		"start": start,
	})

func persist(data):
	var items = []
	for i in collection.values():
		items.append({
			"id": i.id,
			"amount": i.amount,
		})
	data["automate"] = {
		"task": task,
		"start": start,
		"until": until,
		"collect": items,
	}
	
func restore(data):
	task = data.get("automate", {}).get("task", "Fish")
	until = data.get("automate", {}).get("until", 0)
	start = data.get("automate", {}).get("start", 0)
	var items = data.get("automate", {}).get("collect", [])
	collection = {}
	for i in items:
		collection[i.id] = {
			"id": i.id,
			"ref": Content.get_item_reference(i.id),
			"amount": i.amount,
		}
	
