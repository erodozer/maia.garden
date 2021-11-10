extends "res://content/achievement.gd"

func get_id():
	return "fish1"

func _on_stat(id, _params):
	if id != "fish.caught":
		return false
		
	return true
	
func get_title():
	return "Shallow Waters"
	
func get_description():
	return "Catch every pond fish"
	
func get_progress():
	var progress = 0
	var required = 0
	for i in Content.Items:
		if i.type != "fish":
			continue
		
		if i.location != "pond":
			continue
		
		required += 1
		
		if GameState.fishing.records[i.id].size > 0:
			progress += 1
	return {
		"progress": progress,
		"required": required,
	}
