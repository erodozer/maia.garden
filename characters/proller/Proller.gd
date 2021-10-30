extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func introduction():
	visible = false
	collision_layer = 0
	var anim = get_node("AnimationPlayer")
	anim.play("fade_in")
	yield(anim, "animation_finished")
	collision_layer = 4

func hint():
	return "Talk to Proller"
	
func interact():
	if not GameState.flag("introduce.proller.complete"):
		yield(dialogue.open([
			"[wave amp=20 freq=2]Maia...[/wave]",
			"[wave amp=20 freq=2]Do you...know why...[/wave]",
			"[wave amp=20 freq=2]I summoned you here...[/wave]",
			"[wave amp=20 freq=2]...The garden...[/wave]",
			"[wave amp=20 freq=2]Has something...I desire[/wave]",
			"[shake rate=30 level=8]BRING IT TO ME[/shake]",
		]), "completed")
		GameState.toggle_flag("introduce.proller.complete")
	
	if can_talk():
		yield(check_requests(), "completed")
	else:
		yield(dialogue.open([
			"[wave amp=20 freq=2]Maia...[/wave]",
			"[wave amp=20 freq=2]why are you here...[/wave]",
			"[wave amp=20 freq=2]...your assistance...[/wave]",
			"[wave amp=20 freq=2]was not requested...[/wave]",
			"[wave amp=20 freq=2]Your presence...however[/wave]",
			"[wave amp=20 freq=2]...is appreciated...[/wave]",
		]), "completed")
