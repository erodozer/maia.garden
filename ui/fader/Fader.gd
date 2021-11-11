extends Control

func fade_in(duration = 0.4):
	var tween = get_node("Tween")
	tween.interpolate_property(self, "material:shader_param/transition", 0, 1.0, duration)
	tween.start()
	yield(tween, "tween_all_completed")
	
func fade_out(duration = 0.4):
	var tween = get_node("Tween")
	tween.interpolate_property(self, "material:shader_param/transition", 1.0, 0.0, duration)
	tween.start()
	yield(tween, "tween_all_completed")
