extends "res://content/achievement.gd"

func get_id():
	return "requests1"
	
func _on_stat(id, _params):
	if id != "request.completed":
		return false
		
	return true
	
func get_title():
	return "A Helping Hand"
	
func get_description():
	return "Fulfill requests"
	
func get_progress():
	var completed = 0
	for i in GameState.requests:
		if i.completed:
			completed += 1
	return {
		"progress": completed,
		"required": 3,
	}
