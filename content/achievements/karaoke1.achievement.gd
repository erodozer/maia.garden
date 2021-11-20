extends "res://content/achievement.gd"

var full_combo = false

func get_id():
	return "karaoke1"

func _on_stat(id, params):
	if id != "karaoke":
		return false
		
	if params.combo == params.note_count:
		full_combo = true
		return true
	return false

func get_title():
	return "A Perfect Performance"
	
func get_description():
	return "Get a Full Combo on any song"
	
func get_progress():
	return {
		"progress": int(full_combo),
		"required": 1,
	}

func persist(data):
	var save = data.get("achievements", {})
	save["karaoke1"] = full_combo
	data["achievements"] = save
	
func restore(data):
	full_combo = data.get("achievements", {}).get("karaoke1", false)
	
