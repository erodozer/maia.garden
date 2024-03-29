extends "res://content/achievement.gd"

var has_eaten = {}

func get_id():
	return "cafe1"

func _ready():
	for c in Content.Items:
		if c.type == "cafe" and c.stack == 0:
			has_eaten[c.id] = false

func _on_stat(id, params):
	if id != "shop.purchase":
		return false
		
	var item = params.item
	if item.id in has_eaten:
		has_eaten[item.id] = true
		return true
	return false

func get_title():
	return "Taste Tester"
	
func get_description():
	return "Tried one of every cafe item"
	
func get_progress():
	var progress = 0
	for i in has_eaten.values():
		if i:
			progress += 1
	return {
		"progress": progress,
		"required": len(has_eaten),
	}

func persist(data):
	var save = data.get("achievements", {})
	save["cafe1"] = has_eaten
	
func restore(data):
	has_eaten = {}
	for c in Content.Items:
		if c.type == "cafe" and c.stack == 0:
			var eaten = data.get("achievements", {}).get("cafe1", {}).get(c.id, false)
			has_eaten[c.id] = eaten
