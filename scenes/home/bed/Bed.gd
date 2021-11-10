extends StaticBody2D

func hint():
	return "Go to Sleep"

func interact():
	get_node("CanvasLayer/Fader").fade_in()
	Bgm.fadeout(1.0)
	#Bgm.change_song()
	yield(get_tree().create_timer(3.0), "timeout")
	
	GameState.calendar.advance_day()
	if GameState.flag("introduce.proller") and not GameState.flag("introduce.proller.complete"):
		SceneManager.change_scene("darkness")
	else:
		SceneManager.change_scene("garden", ["Home"])
