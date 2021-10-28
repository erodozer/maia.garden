extends Node

var total_caught = 0
var records = {}

func _ready():
	for f in Content.Items:
		if f.type == "fish":
			records[f.id] = {
				"id": f.id,
				"size": 0,
			}

func catch(fish):
	var size = fish.size
	var prev = records[fish.ref.id].size
	var new_record = false
	
	if size > prev:
		records[fish.ref.id].size = size
		new_record = true
		emit_signal("new_record", fish)
	
	var is_rare = inverse_lerp(fish.ref.min_size, fish.ref.max_size, size) > .8
	
	var key = "%s:rare" % fish.ref.id \
		if is_rare \
		else fish.ref.id
		
	GameState.inventory.insert_item({
		"id": key,
		"ref": fish.ref,
		"amount": 1
	})
	
	total_caught += 1
	
	GameState.emit_signal("stat", "fish.caught", {
		"fish": fish.ref,
		"size": size,
		"rare": is_rare,
		"timestamp": OS.get_unix_time()
	})
	
	return new_record
