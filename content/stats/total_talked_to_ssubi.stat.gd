extends "res://content/stat.gd"

var total = 0

func get_id():
	return "talked_to_ssubi"

func get_title():
	return "Talked To Ssubi"
	
func value():
	return total
	
func _on_stat(id, params):
	if id != "npc.interact":
		return
		
	if params.id == "ssubi":
		total += 1
