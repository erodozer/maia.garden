extends "res://content/stat.gd"

func get_id():
	return "talked_to_ssubi"

func get_title():
	return "Talked To Ssubi"
	
func _on_stat(id, params):
	if id != "npc.interact":
		return
		
	if params.id == "ssubi":
		value += 1
