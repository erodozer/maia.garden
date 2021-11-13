extends Node2D

func _setup(_params):
	Bgm.change_song(preload("res://scenes/birthday/bgm.ogg"), 0)

func _start():
	var anim = get_node("AnimationPlayer")
	anim.play("Cutscene")
	yield(anim, "animation_finished")
	
	anim.play("FadeText")
	yield(get_tree(), "idle_frame")
	get_node("CanvasLayer/Message").visible = true
	yield(anim, "animation_finished")
	yield(get_tree().create_timer(8.0), "timeout")
	
	anim.play_backwards("FadeText")
	yield(anim, "animation_finished")
	get_node("CanvasLayer/Message/Lead").visible = false
	anim.play("FadeText")
	
	var tween = get_node("Tween")
	var letter = get_node("CanvasLayer/Message/MarginContainer")
	tween.interpolate_property(
		letter,
		"rect_position",
		Vector2(0, 150), Vector2(0, -letter.rect_size.y),
		(letter.rect_size.y / 5.0)
	)
	tween.start()
	yield(tween, "tween_all_completed")
	
	yield(get_tree().create_timer(5.0), "timeout")
	
	yield(Bgm.fadeout(2.0), "completed")
	
	GameState.toggle_flag("maia_birthday")
	
	var dialogue = get_node("CanvasLayer/Dialogue")
	yield(dialogue.open([
		"Completion data auto saved",
		"You can load this save data",
		"to continue tending your garden",
	]), "completed")
	
	GameState.calendar.advance_day()
	SceneManager.change_scene("title")
