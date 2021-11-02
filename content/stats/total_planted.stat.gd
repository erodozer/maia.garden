extends "res://content/stat.gd"

func get_id():
	return "flowers_planted"
	
func get_title():
	return "Flowers planted"
	
func _on_stat(id, _params):
	if id != "garden.plant":
		return
		
	value += 1
	
