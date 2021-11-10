extends "res://content/achievement.gd"

func get_id():
	return "fish3"

func _on_stat(id, _params):
	if id != "fish.caught":
		return false
	
	return true

func get_title():
	return "Dreaming Big"
	
func get_description():
	return "Catch a big fish (>75in)"
	
func get_progress():
	var caught = 0
	for i in GameState.fishing.records.values():
		caught = max(caught, i.size)
	return {
		"progress": caught,
		"required": 75,
	}
