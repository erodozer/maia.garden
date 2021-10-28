extends "res://content/stat.gd"

var total = 0

func get_title():
	return "Flowers grown"
	
func value():
	return total
	
func _on_stat(id, _params):
	if id != "garden.plant":
		return
		
	total += 1
	
