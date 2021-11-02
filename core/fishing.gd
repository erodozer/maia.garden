extends Node

const godash = preload("res://addons/godash/godash.gd")
const Fortunes = preload("res://core/fortune.gd").Fortunes

var records = {}

var exclusive = null
var empty = false

func _ready():
	reset()

func get_fish(type):
	if empty and randf() < .8:
		return null
	
	var fish
	if exclusive:
		if type == exclusive.type:
			fish = exclusive
		else:
			return null
	else:
		var selection = {}
		for f in Content.Items:
			if f.type == "fish" and f.location == type:
				selection[f] = f.rarity
		if len(selection) <= 0:
			return null
	
		# pick fish based on rarity weight
		fish = godash.rand_chance(selection)
		
	var size = randf()
	return {
		"ref": fish,
		"size": size,
		"length": lerp(fish.min_size, fish.max_size, size),
		"stamina": fish.strength
	}

func catch(fish):
	var size = fish.length
	var prev = records[fish.ref.id].size
	var new_record = false
	
	var is_rare = fish.size > .8
	
	var key = "%s:rare" % fish.ref.id \
		if is_rare \
		else fish.ref.id
		
	var inserted = GameState.inventory.insert_item({
		"id": key,
		"ref": fish.ref,
		"amount": 1
	})
	
	if not inserted:
		return false
	
	if size > prev:
		records[fish.ref.id].size = size
		new_record = true
	
	GameState.emit_signal("stat", "fish.caught", {
		"fish": fish.ref,
		"size": size,
		"rare": is_rare,
		"timestamp": OS.get_unix_time(),
		"record": new_record
	})
	
	return true

func _on_Fortune_changed(fortune):
	exclusive = null
	empty = false
	
	if fortune == Fortunes.BAD_LUCK_EXCLUSIVE_FISH:
		var selection = {}
		for f in Content.Items:
			if f.type == "fish":
				selection[f] = f.rarity
		if len(selection) <= 0:
			return null
		exclusive = godash.rand_chance(selection)
	
	if fortune == Fortunes.BAD_LUCK_LESS_FISH:
		empty = true
	
func persist(data):
	data["fishing"] = []
	for r in records.values():
		data.fishing.append({
			"id": r.id,
			"size": r.size,
		})
	return data
	
func restore(data):
	records = {}
	for r in data.fishing:
		records[r.id] = {
			"id": r.id,
			"size": r.size,
		}
	
func reset():
	records = {}
	for f in Content.Items:
		if f.type == "fish":
			records[f.id] = {
				"id": f.id,
				"size": 0,
			}
