extends StaticBody2D

export var goto = "Garden"
export var scene = false

onready var portals = get_tree().get_nodes_in_group("portals").front()
onready var player = get_tree().get_nodes_in_group("player").front()
onready var fader = get_tree().get_nodes_in_group("fader").front()

func can_interact():
	return not GameState.calendar.is_maia_day()

func hint():
	if scene:
		return "Enter %s" % goto.replace("_", " ")
	return "Go to %s" % goto.replace("_", " ")
	
func interact():
	if scene:
		SceneManager.change_scene(goto.to_lower())
		return
	
	yield(fader.fade_in(), "completed")
	var destination = portals.get_node(goto)
	player.position = destination.position
	yield(fader.fade_out(), "completed")
	
