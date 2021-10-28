extends "res://content/achievement.gd"

var caffinated = false

func _on_stat(id, params):
	if id != "shop.purchase":
		return false
		
	var item = params.item
	if item.type == "cafe":
		if GameState.stamina >= 100 and item.stamina > 0:
			caffinated = true
			return true
	return false
			
func get_title():
	return "Over Caffinated"
	
func get_description():
	return "Tried one of every cafe item"
	
func get_progress():
	return {
		"progress": int(caffinated),
		"required": 1,
	}
