extends "res://content/stat.gd"

func get_id():
	return "stamina_used"
	
func get_title():
	return "Total Stamina Used"
	
func _on_stat(id, params):
	if id != "stamina":
		return
		
	if params.old_value > params.new_value:
		value += params.old_value - params.new_value

func visible():
	return false
