extends Control

func fade_in():
	var anim = get_node("AnimationPlayer")
	anim.play("Fade")
	yield(anim, "animation_finished")
	
func fade_out():
	var anim = get_node("AnimationPlayer")
	anim.play_backwards("Fade")
	yield(anim, "animation_finished")
