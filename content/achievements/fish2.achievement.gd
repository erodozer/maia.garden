extends "res://content/achievement.gd"

func get_id():
	return "fish2"

func _on_stat(id, _params):
	if id != "fish.caught":
		return false
		
	return true

func get_title():
	return "River King"
	
func get_description():
	return "Catch every river fish"
	
func get_progress():
	var progress = 0
	var required = 0
	for i in Content.Items:
		if i.type != "fish":
			continue
		
		if i.location != "river":
			continue
		
		required += 1
		
		if GameState.fishing.records[i.id].size > 0:
			progress += 1
	return {
		"progress": progress,
		"required": required,
	}
