extends AudioStreamPlayer

onready var tween = get_node("Tween")

func fadeout(duration = 1.0):
	if duration > 0:
		tween.interpolate_property(self, "volume_db", 0, -80.0, duration, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
	volume_db = -80.0
	stop()
	yield(get_tree(), "idle_frame")
	
func fadein(duration = 1.0):
	if duration > 0:
		volume_db = -80.0
		play()
		tween.interpolate_property(self, "volume_db", -80.0, 0.0, duration, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
	else:
		play()
	volume_db = 0
	yield(get_tree(), "idle_frame")
	
func change_song(song, fade = 0.3):
	if stream == song:
		if not playing:
			volume_db = 0
			play()
		return
		
	yield(fadeout(fade), "completed")
	stream = song
	yield(get_tree(), "idle_frame")
	yield(fadein(fade), "completed")
