extends "res://content/stat.gd"

var total = 0

func get_id():
	return "fish_caught"

func get_title():
	return "Fish Caught"
	
func value():
	return total
	
func _on_stat(id, _params):
	if id != "fish.caught":
		return
		
	total += 1
