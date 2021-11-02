extends "res://content/stat.gd"

func get_id():
	return "fish_caught"

func get_title():
	return "Fish Caught"
	
func _on_stat(id, _params):
	if id != "fish.caught":
		return
		
	value += 1
