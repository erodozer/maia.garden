extends "res://content/achievement.gd"

var spend = 0

func get_id():
	return "cafe3"
	
func _on_stat(id, params):
	if id != "shop.purchase":
		return false
		
	var item = params.item
	if item.type == "cafe":
		spend += item.price
		return true
	return false

func get_title():
	return "Unhealthy Addiction"
	
func get_description():
	return "Spend at the cafe"
	
func get_progress():
	return {
		"progress": spend,
		"required": 500,
	}
