extends "res://content/achievement.gd"

var learned = {
	"ssubi.phrase_1": false,
	"ssubi.phrase_2": false,
	"ssubi.phrase_3": false,
	"ssubi.phrase_4": false,
	"ssubi.phrase_5": false,
}

func get_id():
	return "t"
	
func _on_stat(id, params):
	if id != "flag":
		return false
		
	if params.id in learned:
		learned[params.id] = true
		return true
	return false

func get_title():
	return "Bird Brain"
	
func get_description():
	return "Teach Ssubi some new words"
	
func get_progress():
	var count = 0
	for l in learned:
		if learned[l]:
			count += 1
	return {
		"progress": count,
		"required": len(learned),
	}
