extends "res://content/achievement.gd"

var size = 0

func get_id():
	return "fish3"

func _on_stat(id, params):
	if id != "fish.caught":
		return false
	
	size = max(size, params.size)
	return true

func get_title():
	return "Dreaming Big"
	
func get_description():
	return "Catch a big fish (>75in)"
	
func get_progress():
	return {
		"progress": size,
		"required": 75,
	}
