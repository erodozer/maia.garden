extends "res://content/achievement.gd"

var full_combo = {
	0: false,
	1: false,
	2: false,
}

func get_id():
	return "karaoke2"

func _on_stat(id, params):
	if id != "karaoke":
		return false
		
	if params.combo == params.note_count:
		if params.difficulty in full_combo:
			full_combo[params.difficulty] = true
		return true
	return false

func get_title():
	return "All Star"
	
func get_description():
	return "Full Combo every karaoke song"
	
func get_progress():
	var completed = 0
	for i in full_combo.values():
		completed += int(i)
	return {
		"progress": completed,
		"required": len(full_combo),
	}

func persist(data):
	var save = data.get("achievements", {})
	save["karaoke2"] = full_combo
	data["achievements"] = save
	
func restore(data):
	full_combo = data.get("achievements", {}).get("karaoke2", {
		0: false,
		1: false,
		2: false,
	})
	
