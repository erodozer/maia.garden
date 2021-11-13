extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func _ready():
	if not GameState.calendar.is_maia_day():
		queue_free()
		
func hint():
	return "Talk to Chie"

func can_talk():
	talk_indicator.visible = false
	return false

func interact():
	yield(
		dialogue.open([
			"Good morning, Maia!",
			"I have something to show you",
			"will you follow me?",
		], ["Okay!", "Of course~"]),
		"completed"
	)
	yield(
		dialogue.open([
			"Great!",
			"It's something you'll love!",
			"Right this way~",
		]),
		"completed"
	)
	
	var anim = get_node("AnimationPlayer")
	anim.play("fadeout")
	Bgm.fadeout(3.0)
	yield(anim, "animation_finished")
	SceneManager.change_scene("birthday")
	
