extends "res://content/stat.gd"

func get_id():
	return "total_konpeto"

func get_title():
	return "Total Konpeito Earned"
	
func _on_stat(id, params):
	if id != "konpeto":
		return
		
	if params.new_value > params.old_value:
		value += params.new_value - params.old_value

func get_weight():
	return -1
