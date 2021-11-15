extends "res://content/achievement.gd"

var fortune_told = false

func get_id():
	return "fortune1"

func _on_stat(id, params):
	if id != "fortune.told":
		return false
		
	fortune_told = true
	return true

func get_title():
	return "In the Stars"
	
func get_description():
	return "Have your fortune told"
	
func get_progress():
	return {
		"progress": int(fortune_told),
		"required": 1,
	}

func persist(data):
	var save = data.get("achievements", {})
	save["fortune1"] = fortune_told
	
func restore(data):
	fortune_told = data.get("achievements", {}).get("fortune1", false)
	
