extends "res://content/stat.gd"

var total = 0

func get_id():
	return "total_konpeto"

func get_title():
	return "Total Konpeto Earned"
	
func value():
	return total
	
func _on_stat(id, params):
	if id != "konpeto":
		return
		
	if params.new_value > params.old_value:
		total += params.new_value - params.old_value

func get_weight():
	return -1
