extends "res://content/achievement.gd"

const NPC_FLAGS = [
	"talked_to.clover",
	"talked_to.chie",
	"talked_to.yuuki",
	"talked_to.tazzle",
	"talked_to.proller",
]

func get_id():
	return "introduce"
	
func _on_stat(id, _params):
	if id != "flag":
		return false
		
	return true
	
func get_title():
	return "Neighbors"
	
func get_description():
	return "Meet all your friends"
	
func get_progress():
	var completed = 0
	for i in NPC_FLAGS:
		if GameState.flag(i):
			completed += 1
	return {
		"progress": completed,
		"required": len(NPC_FLAGS),
	}
