extends "res://content/stat.gd"

func get_id():
	return "total_konpeito"

func get_title():
	return "Total Konpeito Earned"
	
func _on_stat(id, params):
	if id != "konpeito":
		return
		
	if params.new_value > params.old_value:
		value += params.new_value - params.old_value

func get_weight():
	return -1
