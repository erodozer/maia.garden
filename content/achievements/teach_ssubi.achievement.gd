extends "res://content/achievement.gd"

var learned = [
	"ssubi.phrase_1",
	"ssubi.phrase_2",
	"ssubi.phrase_3",
	"ssubi.phrase_4",
	"ssubi.phrase_5",
]

func get_id():
	return "t"
	
func _on_stat(id, params):
	if id != "flag":
		return false
		
	if params.id in learned:
		return true
	return false

func get_title():
	return "Bird Brain"
	
func get_description():
	return "Teach Ssubi some new words"
	
func get_progress():
	var count = 0
	for l in learned:
		if GameState.flag(l):
			count += 1
	return {
		"progress": count,
		"required": len(learned),
	}
