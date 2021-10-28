extends "res://content/stat.gd"

var total = 0

func get_title():
	return "Times Streamed"
	
func value():
	return total
	
func _on_stat(id, _params):
	if id != "streamed":
		return
		
	total += 1
	
