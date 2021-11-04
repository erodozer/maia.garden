extends StaticBody2D

func hint():
	return "Go to Sleep"

func interact():
	if GameState.flag("introduce.proller") and not GameState.flag("introduce.proller.complete"):
		SceneManager.change_scene("darkness")
	else:
		SceneManager.change_scene("garden", ["Home"])
	GameState.calendar.advance_day()
