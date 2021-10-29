extends "res://content/achievement.gd"

const has_caught = {}

func get_id():
	return "fish1"

func _ready():
	for c in Content.Items:
		if c.type == "fish" and c.location == "pond":
			has_caught[c.id] = false

func _on_stat(id, params):
	if id != "fish.caught":
		return false
		
	var fish = params.fish
	if fish.id in has_caught:
		has_caught[fish.id] = true
		return true
	return false

func get_title():
	return "Shallow Waters"
	
func get_description():
	return "Catch every pond fish"
	
func get_progress():
	var progress = 0
	for i in has_caught.values():
		if i:
			progress += 1
	return {
		"progress": progress,
		"required": len(has_caught),
	}
