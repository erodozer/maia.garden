extends "res://content/stat.gd"

var total = 0

func get_id():
	return "stamina_used"
	
func get_title():
	return "Total Stamina Used"
	
func value():
	return total
	
func _on_stat(id, params):
	if id != "stamina":
		return
		
	if params.old_value > params.new_value:
		total += params.old_value - params.new_value

func visible():
	return false
