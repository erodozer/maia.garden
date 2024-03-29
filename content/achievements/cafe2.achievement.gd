extends "res://content/achievement.gd"

var caffinated = false

func get_id():
	return "cafe2"
	
func _on_stat(id, params):
	if id != "shop.purchase":
		return false
		
	var item = params.item
	if item.type == "cafe":
		if GameState.player.stamina >= 100 and item.stamina > 0:
			caffinated = true
			return true
	return false
			
func get_title():
	return "Over Caffinated"
	
func get_description():
	return "Enjoy the Catfe with full stamina"
	
func get_progress():
	return {
		"progress": int(caffinated),
		"required": 1,
	}

func persist(data):
	var save = data.get("achievements", {})
	save["cafe2"] = caffinated
	
func restore(data):
	caffinated = data.get("achievements", {}).get("cafe2", false)
	
