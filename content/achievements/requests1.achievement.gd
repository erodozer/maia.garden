extends "res://content/achievement.gd"

var requests_completed = []
	
func _on_stat(id, params):
	if id != "request.completed":
		return false
		
	if not (params.request in requests_completed):
		requests_completed.append(params.request)
		return true
	return false

func get_title():
	return "A Helping Hand"
	
func get_description():
	return "Fulfill requests"
	
func get_progress():
	return {
		"progress": len(requests_completed),
		"required": 3,
	}
