extends StaticBody2D

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var menu = get_tree().get_nodes_in_group("explore").front()
onready var player = get_tree().get_nodes_in_group("player").front()
onready var fader = get_tree().get_nodes_in_group("fader").front()
onready var anchor = get_node("Anchor")
onready var bubble = get_node("Bubble")

export var flag = "waypoint.garden"

func _ready():
	set_process_input(false)
	bubble.visible = not GameState.flag(flag)
		

func interact():
	if not GameState.flag(flag):
		yield(dialogue.open([
			"Discovered [%s]" % name
		]), "completed")
		GameState.toggle_flag(flag)
		bubble.visible = false
	
	var waypoint = yield(menu.open(), "completed")
	
	if waypoint and waypoint != self:
		yield(waypoint.travel(), "complete")

func hint():
	if not GameState.flag(flag):
		return "Read Sign"
	return "Travel" 

func travel():
	yield(fader.fade_in(), "completed")
	player.global_position = anchor.global_position
	yield(fader.fade_out(), "completed")
