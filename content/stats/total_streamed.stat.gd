extends "res://content/stat.gd"

func get_id():
	return "total_streamed"
	
func get_title():
	return "Times Streamed"
	
func _on_stat(id, _params):
	if id != "streamed":
		return
		
	value += 1
